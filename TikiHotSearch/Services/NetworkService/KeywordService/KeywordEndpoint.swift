//
//  KeywordEndpoint.swift
//  TikiHotSearch
//
//  Created by Kazu on 14/8/24.
//

import Foundation

enum KeywordEndpoint: APIEndpoint {
    case getHotKeywords
    
    var baseURL: URL {
        return URL(string: Constant.URLString.baseURL)!
    }
    
    var path: String {
        return ""
    }
    
    var method: HTTPMethod {
        switch self {
        case .getHotKeywords:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getHotKeywords:
            return [:]
        }
    }
    
    var parameters: [String : Any] {
        switch self {
        case .getHotKeywords:
            return [:]
        }
    }
    
    
}
