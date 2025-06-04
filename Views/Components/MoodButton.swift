import SwiftUI

struct MoodButton: View {
    let mood: MoodType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(mood.emoji)
                    .font(.system(size: 32))
                
                Text(mood.displayName)
                    .font(Theme.current.bodyFont)
                    .foregroundColor(Theme.current.primaryTextColor)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                isSelected ?
                AnyView(Theme.current.accentGradient) :
                AnyView(Theme.current.secondaryBackgroundColor)
            )
            .cornerRadius(Theme.current.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.current.cornerRadius)
                    .stroke(Theme.current.borderColor, lineWidth: 1)
            )
        }
    }
}

#Preview {
    MoodButton(
        mood: .content,
        isSelected: true,
        action: {}
    )
} 