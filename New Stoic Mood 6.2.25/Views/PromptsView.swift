import SwiftUI

struct PromptsView: View {
    let onPromptSelected: (String) -> Void
    let themeManager: ThemeManager
    var body: some View {
        VStack {
            ForEach(StoicPrompts.prompts, id: \.self) { prompt in
                Button(action: { onPromptSelected(prompt) }) {
                    Text(prompt)
                        .foregroundColor(themeManager.textColor)
                        .padding()
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
}

struct StoicPrompts {
    static let prompts = [
        "What challenged me today?",
        "What am I grateful for in this moment?",
        "How did I grow today?",
        "What wisdom can I take from today's experiences?"
    ]
}

#Preview {
    PromptsView(
        onPromptSelected: { prompt in
            print("Selected prompt: \(prompt)")
        },
        themeManager: ThemeManager()
    )
} 