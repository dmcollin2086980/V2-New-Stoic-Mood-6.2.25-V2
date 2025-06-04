import SwiftUI

struct ThemeToggle: View {
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: {
            withAnimation {
                themeManager.toggleTheme()
            }
        }) {
            HStack(spacing: 8) {
                Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                Text(themeManager.isDarkMode ? "Dark Mode" : "Light Mode")
                    .font(.subheadline)
            }
            .foregroundColor(themeManager.accentColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(themeManager.borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ThemeToggle()
        .environmentObject(ThemeManager())
        .padding()
} 