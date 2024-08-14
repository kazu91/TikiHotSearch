//
//  MockAPIClient.swift
//  TikiHotSearchTests
//
//  Created by Kazu on 14/8/24.
//

import Foundation

class MockAPIClient: APIClient {
    typealias EndpointType = KeywordEndpoint
    
    var result: Result<KeywordListResponse, APIError>?
    
    func request<T: Decodable>(_ endpoint: EndpointType) async throws -> T {
        switch result {
        case .success(let data as T):
            return data
        case .failure(let error):
            throw error
        default:
            fatalError("MockAPIClient result is not set or invalid type")
        }
    }
}
