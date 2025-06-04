import SwiftUI

struct MoodSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMood: MoodType?
    @State private var selectedIntensity: Int = 5
    let onMoodSelected: (MoodType, Int) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("How are you feeling?")
                    .font(Theme.current.titleFont)
                    .foregroundColor(Theme.current.primaryTextColor)
                
                Text("Select your current mood")
                    .font(Theme.current.bodyFont)
                    .foregroundColor(Theme.current.secondaryTextColor)
                
                // Mood Grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach(MoodType.allCases, id: \.self) { mood in
                        MoodButton(
                            mood: mood,
                            isSelected: selectedMood == mood
                        ) {
                            selectedMood = mood
                        }
                    }
                }
                .padding()
                
                if let selectedMood = selectedMood {
                    VStack(spacing: 15) {
                        Text("Intensity")
                            .font(Theme.current.headlineFont)
                            .foregroundColor(Theme.current.primaryTextColor)
                        
                        Slider(value: Binding(
                            get: { Double(selectedIntensity) },
                            set: { selectedIntensity = Int($0) }
                        ), in: 1...10, step: 1)
                        .tint(Theme.current.accentColor)
                        
                        Text("\(selectedIntensity)")
                            .font(Theme.current.bodyFont)
                            .foregroundColor(Theme.current.secondaryTextColor)
                    }
                    .padding()
                    
                    Button(action: {
                        onMoodSelected(selectedMood, selectedIntensity)
                    }) {
                        Text("Continue to Journal")
                            .font(Theme.current.bodyFont)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Theme.current.accentColor)
                            .cornerRadius(Theme.current.cornerRadius)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    MoodSelectionView { _, _ in }
} 