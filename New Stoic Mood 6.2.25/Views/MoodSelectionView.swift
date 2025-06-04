import SwiftUI

struct MoodSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedMood: MoodType?
    @State private var selectedIntensity: Int = 5
    @EnvironmentObject private var themeManager: ThemeManager
    let onMoodSelected: (MoodType, Int) -> Void
    
    private let moods: [(type: MoodType, emoji: String, label: String)] = [
        (.happy, "😀", "Happy"),
        (.grateful, "🙏", "Grateful"),
        (.focused, "🎯", "Focused"),
        (.anxious, "😰", "Anxious"),
        (.frustrated, "😤", "Frustrated"),
        (.sad, "😞", "Sad"),
        (.calm, "🧘", "Calm"),
        (.energetic, "⚡", "Energetic"),
        (.proud, "🎉", "Proud"),
        (.reflective, "🥲", "Reflective"),
        (.stressed, "😵‍💫", "Stressed")
    ]
    
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
                    ForEach(moods, id: \.type) { mood in
                        VStack {
                            Text(mood.emoji)
                                .font(.system(size: 40))
                            Text(mood.label)
                                .font(.caption)
                                .foregroundColor(themeManager.textColor)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: ThemeManager.cornerRadius)
                                .fill(selectedMood == mood.type ? 
                                    themeManager.accentColor.opacity(0.2) : 
                                    themeManager.cardBackgroundColor)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: ThemeManager.cornerRadius)
                                .stroke(selectedMood == mood.type ? 
                                    themeManager.accentColor : 
                                    themeManager.borderColor, 
                                    lineWidth: 1)
                        )
                        .onTapGesture {
                            selectedMood = mood.type
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
                            .cornerRadius(ThemeManager.cornerRadius)
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