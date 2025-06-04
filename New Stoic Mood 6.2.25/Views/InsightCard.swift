import SwiftUI

/// A reusable card view for displaying insights with a title and content
struct InsightCard<Content: View>: View {
    let title: String
    let content: Content
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            content
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
}

#Preview {
    InsightCard(title: "Sample Insight") {
        Text("This is a sample insight card with some content.")
            .foregroundColor(.secondary)
    }
    .environmentObject(ThemeManager())
} 