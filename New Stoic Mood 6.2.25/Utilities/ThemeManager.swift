import SwiftUI

enum Theme: String {
    case light
    case dark
    
    var backgroundColor: Color {
        switch self {
        case .light: return Color(hex: "f5f5f5")
        case .dark: return Color(hex: "1a1a1a")
        }
    }
    
    var secondaryBackgroundColor: Color {
        switch self {
        case .light: return Color.white
        case .dark: return Color(hex: "242424")
        }
    }
    
    var tertiaryBackgroundColor: Color {
        switch self {
        case .light: return Color(hex: "fafafa")
        case .dark: return Color(hex: "2a2a2a")
        }
    }
    
    var primaryTextColor: Color {
        switch self {
        case .light: return Color(hex: "1a1a1a")
        case .dark: return Color(hex: "e0e0e0")
        }
    }
    
    var secondaryTextColor: Color {
        switch self {
        case .light: return Color(hex: "666666")
        case .dark: return Color(hex: "a0a0a0")
        }
    }
    
    var tertiaryTextColor: Color {
        switch self {
        case .light: return Color(hex: "999999")
        case .dark: return Color(hex: "707070")
        }
    }
    
    var accentColor: Color {
        switch self {
        case .light: return Color(hex: "d0d0d0")
        case .dark: return Color(hex: "4a4a4a")
        }
    }
    
    var accentLightColor: Color {
        switch self {
        case .light: return Color(hex: "e0e0e0")
        case .dark: return Color(hex: "5a5a5a")
        }
    }
    
    var borderColor: Color {
        switch self {
        case .light: return Color(hex: "e5e5e5")
        case .dark: return Color(hex: "333333")
        }
    }
}

extension Color {
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
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
} 