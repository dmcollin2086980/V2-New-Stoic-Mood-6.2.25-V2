import SwiftUI

struct StoicQuoteView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var currentQuote: String = ""
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text(currentQuote)
                .font(.system(size: 24, weight: .medium, design: .serif))
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.textColor)
                .padding()
                .opacity(isAnimating ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: isAnimating)
                .themeCard(themeManager: themeManager)
            
            Button(action: {
                withAnimation {
                    isAnimating = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        currentQuote = StoicQuotesManager.shared.getRandomQuote()
                        isAnimating = true
                        let generator = UIImpactFeedbackGenerator(style: .medium)
                        generator.impactOccurred()
                    }
                }
            }) {
                Text("New Quote")
                    .font(.headline)
            }
            .themePrimaryButton(themeManager: themeManager)
        }
        .padding()
        .onAppear {
            currentQuote = StoicQuotesManager.shared.getRandomQuote()
            isAnimating = true
        }
    }
}

#Preview {
    StoicQuoteView()
        .environmentObject(ThemeManager())
} 