import SwiftUI

struct FloatingAddButton: View {
    @EnvironmentObject private var themeManager: ThemeManager
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.title2)
                .foregroundColor(themeManager.textColor)
                .frame(width: 56, height: 56)
                .background(themeManager.accentColor)
                .clipShape(Circle())
                .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
        }
        .position(x: UIScreen.main.bounds.width - 44, y: UIScreen.main.bounds.height - 100)
    }
}

#Preview {
    FloatingAddButton(action: {})
        .environmentObject(ThemeManager())
} 