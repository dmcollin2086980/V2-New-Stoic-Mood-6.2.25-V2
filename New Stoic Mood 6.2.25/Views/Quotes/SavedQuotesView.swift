import SwiftUI

struct SavedQuotesView: View {
    @StateObject private var viewModel = QuoteViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        List {
            if viewModel.savedQuotes.isEmpty {
                ContentUnavailableView(
                    "No Saved Quotes",
                    systemImage: "bookmark.slash",
                    description: Text("Quotes you save will appear here")
                )
            } else {
                ForEach(viewModel.savedQuotes) { quote in
                    SavedQuoteRow(quote: quote, viewModel: viewModel)
                }
            }
        }
        .listStyle(PlainListStyle())
        .background(themeManager.backgroundColor)
        .navigationTitle("Saved Quotes")
    }
}

private struct SavedQuoteRow: View {
    let quote: Quote
    @ObservedObject var viewModel: QuoteViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: { showingDetail = true }) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(quote.text)
                        .font(.body)
                        .italic()
                        .foregroundColor(themeManager.textColor)
                        .lineLimit(2)
                    
                    Text("— \(quote.author)")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        viewModel.removeSavedQuote(quote)
                    }
                }) {
                    Image(systemName: "bookmark.fill")
                        .foregroundColor(themeManager.accentColor)
                }
            }
            .padding()
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            NavigationView {
                QuoteDetailView(quote: quote)
            }
        }
    }
}

#Preview {
    NavigationView {
        SavedQuotesView()
            .environmentObject(ThemeManager())
    }
} 