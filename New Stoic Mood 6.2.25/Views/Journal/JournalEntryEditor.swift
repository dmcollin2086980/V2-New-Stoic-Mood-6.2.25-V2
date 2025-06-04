import SwiftUI

struct JournalEntryEditor: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            TextEditor(text: $text)
                .font(.body)
                .foregroundColor(themeManager.textColor)
                .padding(4)
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeManager.borderColor, lineWidth: 1)
                )
            
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .allowsHitTesting(false)
            }
        }
    }
}

#Preview {
    JournalEntryEditor(
        text: .constant(""),
        placeholder: "Write your thoughts here..."
    )
    .environmentObject(ThemeManager())
    .padding()
} 