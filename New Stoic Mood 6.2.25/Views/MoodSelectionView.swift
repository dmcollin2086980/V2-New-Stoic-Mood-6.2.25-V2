import SwiftUI

struct MoodSelectionView: View {
    @Binding var selectedMood: MoodType?
    @Binding var showingMoodSelection: Bool
    @Binding var showingJournalEntry: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
                VStack(spacing: 10) {
                    Text("How are you feeling?")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text("Take a moment to acknowledge your current state")
                        .font(.subheadline)
                        .foregroundColor(Theme.dark.secondaryTextColor)
                }
                .padding(.top, 30)
                
                // Mood Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(MoodType.allCases, id: \.self) { mood in
                        MoodOptionButton(mood: mood) {
                            selectedMood = mood
                            showingMoodSelection = false
                            showingJournalEntry = true
                        }
                    }
                }
                .padding()
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingMoodSelection = false
                    }
                }
            }
        }
    }
}

struct MoodOptionButton: View {
    let mood: MoodType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Text(mood.emoji)
                    .font(.system(size: 32))
                
                Text(mood.displayName)
                    .font(.subheadline)
                    .foregroundColor(Theme.dark.primaryTextColor)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.dark.secondaryBackgroundColor)
            .cornerRadius(12)
        }
    }
}

struct MoodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MoodSelectionView(
            selectedMood: .constant(nil),
            showingMoodSelection: .constant(true),
            showingJournalEntry: .constant(false)
        )
    }
} 