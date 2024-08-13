//
//  Item.swift
//  TikiHotSearch
//
//  Created by Kazu on 14/8/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
