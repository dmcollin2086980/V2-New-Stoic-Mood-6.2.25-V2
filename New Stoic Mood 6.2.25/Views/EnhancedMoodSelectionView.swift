import SwiftUI

/// A view that allows users to select their mood and intensity level.
/// This view provides a grid of mood options and a slider for intensity selection.
struct EnhancedMoodSelectionView: View {
    // MARK: - Properties
    
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    /// The callback function that is called when a mood and intensity are selected
    let onSelect: (Mood, Double) -> Void
    
    /// The currently selected mood
    @State private var selectedMood: Mood?
    
    /// The current intensity value
    @State private var intensity: Double = 0.5
    
    /// A boolean indicating whether the view is presented
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: ThemeManager.padding * 2) {
                // Header
                VStack(spacing: ThemeManager.smallPadding) {
                    Text("How are you feeling?")
                        .font(.title)
                        .foregroundColor(themeManager.textColor)
                    
                    Text("Select your mood and intensity")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                
                // Mood grid
                LazyVGrid(columns: [
                    GridItem(.adaptive(minimum: 80, maximum: 100), spacing: ThemeManager.padding)
                ], spacing: ThemeManager.padding) {
                    ForEach(Mood.allCases) { mood in
                        EnhancedMoodButton(
                            mood: mood,
                            isSelected: selectedMood == mood,
                            action: { selectedMood = mood }
                        )
                    }
                }
                .padding(.horizontal)
                
                // Intensity slider
                VStack(spacing: ThemeManager.smallPadding) {
                    Text("Intensity: \(Int(intensity * 100))%")
                        .font(.headline)
                        .foregroundColor(themeManager.textColor)
                    
                    Slider(value: $intensity, in: 0...1)
                        .accentColor(themeManager.accentColor)
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationTitle("Select Mood")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        if let mood = selectedMood {
                            onSelect(mood, intensity)
                            dismiss()
                        }
                    }
                    .disabled(selectedMood == nil)
                }
            }
        }
    }
}

/// A button that represents a mood option in the selection grid
struct EnhancedMoodButton: View {
    /// The mood represented by this button
    let mood: Mood
    
    /// A boolean indicating whether this mood is selected
    let isSelected: Bool
    
    /// The action to perform when the button is tapped
    let action: () -> Void
    
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: ThemeManager.smallPadding) {
                Text(mood.emoji)
                    .font(.system(size: 32))
                
                Text(mood.name)
                    .font(.caption)
                    .foregroundColor(isSelected ? .white : themeManager.textColor)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? themeManager.accentColor : themeManager.cardBackgroundColor)
            .cornerRadius(ThemeManager.cornerRadius)
        }
    }
}

// MARK: - Preview

struct EnhancedMoodSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedMoodSelectionView { _, _ in }
            .environmentObject(ThemeManager())
    }
} 