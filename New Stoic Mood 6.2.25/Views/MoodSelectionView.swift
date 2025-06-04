import SwiftUI

struct MoodSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMood: MoodType?
    @State private var selectedIntensity: Int = 5
    @EnvironmentObject private var themeManager: ThemeManager
    let onMoodSelected: (MoodType, Int) -> Void
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Text("How are you feeling?")
                    .font(.title)
                    .foregroundColor(themeManager.textColor)
                
                Text("Select your current mood")
                    .font(.body)
                    .foregroundColor(themeManager.secondaryTextColor)
                
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
                            .font(.headline)
                            .foregroundColor(themeManager.textColor)
                        
                        Slider(value: Binding(
                            get: { Double(selectedIntensity) },
                            set: { selectedIntensity = Int($0) }
                        ), in: 1...10, step: 1)
                        .tint(themeManager.accentColor)
                        
                        Text("\(selectedIntensity)")
                            .font(.body)
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                    .padding()
                    
                    Button(action: {
                        onMoodSelected(selectedMood, selectedIntensity)
                    }) {
                        Text("Continue to Journal")
                            .font(.body)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(themeManager.accentColor)
                            .cornerRadius(12)
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
        .environmentObject(ThemeManager())
} 