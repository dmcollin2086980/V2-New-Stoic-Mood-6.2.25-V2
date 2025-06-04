import SwiftUI

struct QuoteCard: View {
    let quote: String
    let author: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(quote)
                .font(.body)
                .italic()
                .foregroundColor(themeManager.textColor)
            
            Text("— \(author)")
                .font(.subheadline)
                .foregroundColor(themeManager.secondaryTextColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(themeManager.borderColor, lineWidth: 1)
        )
    }
}

#Preview {
    QuoteCard(
        quote: "The happiness of your life depends upon the quality of your thoughts.",
        author: "Marcus Aurelius"
    )
    .environmentObject(ThemeManager())
    .padding()
} 