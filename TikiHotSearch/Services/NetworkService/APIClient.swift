//
//  APIClient.swift
//  TikiHotSearch
//
//  Created by Kazu on 14/8/24.
//

import Foundation

protocol APIClient {
    associatedtype EndpointType = APIEndpoint
    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T
}

enum APIError: Error, Equatable {
    case noInternetConnection
    case invalidResponse
    case clientError(message: String)
    case accessTokenRevoked
    case serverError
}

protocol URLSessionProtocol {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol { }

class URLSessionAPIClient<EndpointType: APIEndpoint>: APIClient {
    private let urlSession: URLSessionProtocol
    private let urlCache: URLCache
    
    init(urlSession: URLSessionProtocol = URLSession.shared, urlCache: URLCache = .shared) {
        self.urlSession = urlSession
        self.urlCache = urlCache
    }
    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
        let url = endpoint.baseURL.appendingPathComponent(endpoint.path)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if endpoint.method == .get && !(endpoint.parameters.isEmpty) {
            components?.queryItems = endpoint.parameters.map({ param in
                URLQueryItem(name: param.key, value: "\(param.value)")
            })
        }
        
        guard let safeUrl = components?.url else {
            throw APIError.clientError(message: "Invalid URL")
        }
        
        var request = URLRequest(url: safeUrl)
        request.httpMethod = endpoint.method.rawValue
        
        endpoint.headers?.forEach { request.addValue($0.value, forHTTPHeaderField: $0.key) }
        
        if endpoint.method == .post || endpoint.method == .put {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: endpoint.parameters)
            } catch {
                throw APIError.clientError(message: "Invalid Body Parameters")
            }
        }
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.serverError
        }
        
        switch httpResponse.statusCode {
        case 400..<500:
            if httpResponse.statusCode == 401 {
                throw APIError.accessTokenRevoked
            }
            throw APIError.clientError(message: httpResponse.debugDescription)
        case 500..<600:
            throw APIError.serverError
        default:
            break
        }
        
        let cachedResponse = CachedURLResponse(response: response, data: data)
        urlCache.storeCachedResponse(cachedResponse, for: URLRequest(url: safeUrl))
                
        let decodedData = try JSONDecoder().decode(T.self, from: data)
        return decodedData
    }
}
