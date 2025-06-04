import SwiftUI

/// A manager class that handles theme-related functionality and styling for the app.
/// This class provides access to colors, spacing, and styling modifiers that can be used
/// throughout the app to maintain consistent design.
class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    // MARK: - Constants
    
    /// The standard corner radius used throughout the app
    static let cornerRadius: CGFloat = 12
    
    /// The standard padding used for most views
    static let padding: CGFloat = 16
    
    /// A smaller padding value used for compact views
    static let smallPadding: CGFloat = 8
    
    /// The standard animation duration used for transitions
    static let animationDuration: Double = 0.3
    
    init() {
        self.isDarkMode = UserDefaults.standard.bool(forKey: "isDarkMode")
    }
    
    func toggleTheme() {
        isDarkMode.toggle()
    }
    
    // MARK: - Colors
    
    /// The main background color of the app
    var backgroundColor: Color { Color("AppBackground") }
    
    /// The background color used for cards and elevated surfaces
    var cardBackgroundColor: Color { Color("CardBackgroundColor") }
    
    /// The primary accent color used for interactive elements
    var accentColor: Color { Color("AccentColor") }
    
    /// A secondary accent color used for less prominent interactive elements
    var secondaryAccentColor: Color { Color("SecondaryAccentColor") }
    
    /// The primary text color used for most content
    var textColor: Color { Color("TextColor") }
    
    /// A secondary text color used for less prominent text
    var secondaryTextColor: Color { Color("SecondaryTextColor") }
    
    /// The color used for borders and dividers
    var borderColor: Color { Color("BorderColor") }
    
    /// The color used to indicate success states
    var successColor: Color { Color("SuccessColor") }
    
    /// The color used to indicate warning states
    var warningColor: Color { Color("WarningColor") }
    
    /// The color used to indicate error states
    var errorColor: Color { Color("ErrorColor") }
    
    var shadowColor: Color {
        Color.black.opacity(0.1)
    }
    
    // MARK: - View Modifiers
    
    /// Applies the primary button style to a view
    /// - Returns: A view with the primary button style applied
    func primaryButtonStyle() -> some ViewModifier {
        PrimaryButtonStyleModifier(themeManager: self)
    }
    
    /// Applies the secondary button style to a view
    /// - Returns: A view with the secondary button style applied
    func secondaryButtonStyle() -> some ViewModifier {
        SecondaryButtonStyleModifier(themeManager: self)
    }
}

// MARK: - View Modifiers
struct PrimaryButtonStyleModifier: ViewModifier {
    @ObservedObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeManager.accentColor)
            .foregroundColor(themeManager.backgroundColor)
            .cornerRadius(ThemeManager.cornerRadius)
            .shadow(color: themeManager.shadowColor, radius: 5, x: 0, y: 2)
    }
}

struct SecondaryButtonStyleModifier: ViewModifier {
    @ObservedObject var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(themeManager.cardBackgroundColor)
            .foregroundColor(themeManager.accentColor)
            .cornerRadius(ThemeManager.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: ThemeManager.cornerRadius)
                    .stroke(themeManager.accentColor, lineWidth: 1)
            )
    }
}

// MARK: - View Extensions
extension View {
    /// Applies the theme background color to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme background color applied
    func themeBackground(themeManager: ThemeManager) -> some View {
        self.background(themeManager.backgroundColor)
    }
    
    /// Applies the theme text color to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme text color applied
    func themeText(themeManager: ThemeManager) -> some View {
        self.foregroundColor(themeManager.textColor)
    }
    
    /// Applies the theme card style to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme card style applied
    func themeCard(themeManager: ThemeManager) -> some View {
        self.cardStyle()
    }
    
    /// Applies the theme primary button style to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme primary button style applied
    func themePrimaryButton(themeManager: ThemeManager) -> some View {
        self.modifier(themeManager.primaryButtonStyle())
    }
    
    /// Applies the theme secondary button style to a view
    /// - Parameter themeManager: The theme manager instance
    /// - Returns: A view with the theme secondary button style applied
    func themeSecondaryButton(themeManager: ThemeManager) -> some View {
        self.modifier(themeManager.secondaryButtonStyle())
    }
} 
