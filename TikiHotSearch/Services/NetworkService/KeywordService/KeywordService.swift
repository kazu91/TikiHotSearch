//
//  KeywordService.swift
//  TikiHotSearch
//
//  Created by Kazu on 14/8/24.
//

import Foundation

protocol KeywordServiceProtocol {
    func getHotKeywords() async throws -> KeywordListResponse
}

class KeywordService<Client: APIClient>: KeywordServiceProtocol where Client.EndpointType == KeywordEndpoint {
    var apiClient: Client
    
    init(apiClient: Client) {
        self.apiClient = apiClient
    }
    
    func getHotKeywords() async throws -> KeywordListResponse {
        return try await apiClient.request(.getHotKeywords)
    }
}
