import SwiftUI

/// A custom search bar view
struct SearchBar: View {
    /// The text to display in the search bar
    @Binding var text: String
    
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(themeManager.secondaryTextColor)
            
            TextField("Search entries...", text: $text)
                .foregroundColor(themeManager.textColor)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(themeManager.secondaryTextColor)
                }
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

// MARK: - Preview

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant(""))
            .environmentObject(ThemeManager())
            .padding()
    }
} 