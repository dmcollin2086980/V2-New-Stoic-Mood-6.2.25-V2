import SwiftUI

struct MoodButton: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(mood.emoji)
                    .font(.system(size: 32))
                
                Text(mood.displayName)
                    .font(.body)
                    .foregroundColor(themeManager.textColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isSelected ?
                themeManager.accentColor :
                themeManager.cardBackgroundColor
            )
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(themeManager.borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    MoodButton(
        mood: .calm,
        isSelected: true,
        action: {}
    )
    .environmentObject(ThemeManager())
    .padding()
} 