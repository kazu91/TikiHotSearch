//
//  Utils.swift
//  TikiHotSearch
//
//  Created by Kazu on 14/8/24.
//

import Foundation
import SwiftUI

// MARK: - Constant
enum Constant {
    struct URLString {
        static let baseURL = "https://run.mocky.io/v3/7b830025-284a-40f7-88ad-2587baa95f1a"
    }
}

// MARK: - Extensions

extension Color {
    // Helper initializer to convert hex to Color
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
}

enum TitleBgColor: CaseIterable {
    case first, second, third, fourth, fifth, sixth, seventh, eighth, ninth
    
    var color: Color {
        switch self {
        case .first:
            return Color(hex: "#16702e")
        case .second:
            return Color(hex: "#005a51")
        case .third:
            return Color(hex: "#996c00")
        case .fourth:
            return Color(hex: "#5c0a6b")
        case .fifth:
            return Color(hex: "#006d90")
        case .sixth:
            return Color(hex: "#974e06")
        case .seventh:
            return Color(hex: "#99272e")
        case .eighth:
            return Color(hex: "#89221f")
        case .ninth:
            return Color(hex: "#00345d")
        }
    }
    
}
