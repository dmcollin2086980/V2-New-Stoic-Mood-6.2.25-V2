import SwiftUI

struct QuoteListView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        List {
            ForEach(viewModel.quotes) { quote in
                QuoteCard(quote: quote.text, author: quote.author)
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
                    .padding(.vertical, 8)
            }
        }
        .listStyle(PlainListStyle())
        .background(themeManager.backgroundColor)
        .navigationTitle("Stoic Quotes")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.refreshQuotes()
                }) {
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(themeManager.accentColor)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        QuoteListView()
            .environmentObject(ThemeManager())
    }
} 