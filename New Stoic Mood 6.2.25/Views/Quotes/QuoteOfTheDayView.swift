import SwiftUI

struct QuoteOfTheDayView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 15) {
            // Quote Card
            QuoteCard(quote: viewModel.dailyQuote.text, author: viewModel.dailyQuote.author)
                .padding(.horizontal)
            
            // Refresh Button
            Button(action: {
                withAnimation {
                    viewModel.refreshDailyQuote()
                }
            }) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("New Quote")
                }
                .font(.subheadline)
                .foregroundColor(themeManager.accentColor)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(20)
            }
        }
        .padding(.vertical)
        .background(themeManager.backgroundColor)
    }
}

#Preview {
    QuoteOfTheDayView()
        .environmentObject(ThemeManager())
} 