import SwiftUI

public struct Theme {
    public static let primaryColor = Color("PrimaryColor")
    public static let secondaryColor = Color("SecondaryColor")
    public static let backgroundColor = Color("BackgroundColor")
    public static let textColor = Color("TextColor")
    public static let accentColor = Color("AccentColor")
    
    public static let cardBackground = Color("CardBackground")
    public static let cardBorder = Color("CardBorder")
    
    public static let successColor = Color("SuccessColor")
    public static let warningColor = Color("WarningColor")
    public static let errorColor = Color("ErrorColor")
    
    public static let shadowColor = Color.black.opacity(0.1)
    
    public static let cornerRadius: CGFloat = 12
    public static let padding: CGFloat = 16
    public static let smallPadding: CGFloat = 8
    
    public static let animationDuration: Double = 0.3
}

public extension Color {
    static let theme = Theme.self
}

public extension View {
    func themeBackground() -> some View {
        self.background(Theme.backgroundColor)
    }
    
    func themeText() -> some View {
        self.foregroundColor(Theme.textColor)
    }
    
    func themeCard() -> some View {
        self
            .background(Theme.cardBackground)
            .cornerRadius(Theme.cornerRadius)
            .shadow(color: Theme.shadowColor, radius: 5, x: 0, y: 2)
    }
} 