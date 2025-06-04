import SwiftUI

struct MoodSelectionGrid: View {
    let moods: [Mood]
    let selectedMood: Mood?
    let onMoodSelected: (Mood) -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            ForEach(moods) { mood in
                MoodCard(
                    mood: mood,
                    isSelected: selectedMood == mood,
                    action: { onMoodSelected(mood) }
                )
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    MoodSelectionGrid(
        moods: Mood.allCases,
        selectedMood: .calm,
        onMoodSelected: { _ in }
    )
    .environmentObject(ThemeManager())
} 