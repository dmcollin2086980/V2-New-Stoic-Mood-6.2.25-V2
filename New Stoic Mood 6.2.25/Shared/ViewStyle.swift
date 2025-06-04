import SwiftUI

// MARK: - Card Style
struct CardModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(themeManager.borderColor, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Section Header Style
struct SectionHeaderModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .font(.headline)
            .foregroundColor(themeManager.textColor)
            .padding(.horizontal)
            .padding(.vertical, 8)
    }
}

// MARK: - Chart Container Style
struct ChartContainerModifier: ViewModifier {
    @EnvironmentObject private var themeManager: ThemeManager
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(themeManager.borderColor, lineWidth: 1)
            )
    }
}

// MARK: - View Extensions
extension View {
    func cardStyle() -> some View {
        self.modifier(CardModifier())
    }
    
    func sectionHeader() -> some View {
        self.modifier(SectionHeaderModifier())
    }
    
    func chartContainer() -> some View {
        self.modifier(ChartContainerModifier())
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        Text("Card Style")
            .cardStyle()
        
        Text("Section Header")
            .sectionHeader()
        
        Text("Chart Container")
            .chartContainer()
    }
    .environmentObject(ThemeManager())
    .padding()
} 