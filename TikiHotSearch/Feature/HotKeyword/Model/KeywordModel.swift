//
//  KeywordModel.swift
//  TikiHotSearch
//
//  Created by Kazu on 14/8/24.
//

import Foundation

// MARK: - List Keyword
struct KeywordListResponse: Codable, Hashable {
    let items: [Keyword]
}

// MARK: - Item
struct Keyword: Codable, Hashable, Identifiable {
    var id = UUID()
    
    var icon : String
    var name : String
    
    enum CodingKeys: String, CodingKey {
        case icon = "icon"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        icon = try values.decode(String.self, forKey: .icon)
        name = try values.decode(String.self, forKey: .name)
    }
    
    init(icon: String, name: String) {
        self.icon = icon
        self.name = name
    }
}
