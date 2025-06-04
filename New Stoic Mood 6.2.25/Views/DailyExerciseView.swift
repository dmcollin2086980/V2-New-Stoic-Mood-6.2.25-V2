import SwiftUI

struct DailyExerciseView: View {
    @StateObject private var viewModel = DailyExerciseViewModel()
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Header with Quote
                        VStack(spacing: 16) {
                            Text(viewModel.currentExercise.quote)
                                .font(.title)
                                .foregroundColor(themeManager.textColor)
                                .multilineTextAlignment(.center)
                                .padding()
                                .background(themeManager.cardBackgroundColor)
                                .cornerRadius(12)
                            
                            Text("— \(viewModel.currentExercise.author)")
                                .font(.body)
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        
                        // Exercise Content
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Today's Exercise")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            Text(viewModel.currentExercise.exercise)
                                .font(.body)
                                .foregroundColor(themeManager.secondaryTextColor)
                                .padding()
                                .background(themeManager.cardBackgroundColor)
                                .cornerRadius(12)
                        }
                        
                        // Action Steps
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Action Steps")
                                .font(.headline)
                                .foregroundColor(themeManager.textColor)
                            
                            ForEach(viewModel.currentExercise.steps, id: \.self) { step in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "circle.fill")
                                        .font(.system(size: 8))
                                        .foregroundColor(themeManager.accentColor)
                                        .padding(.top, 6)
                                    
                                    Text(step)
                                        .font(.body)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                            }
                        }
                        .padding()
                        .background(themeManager.cardBackgroundColor)
                        .cornerRadius(12)
                        
                        // Reflection Section
                        if viewModel.isExerciseComplete {
                            ExerciseReflectionView(viewModel: viewModel, themeManager: themeManager)
                        }
                        
                        // Complete Button
                        if !viewModel.isExerciseComplete {
                            Button {
                                withAnimation {
                                    viewModel.completeExercise()
                                }
                            } label: {
                                Text("Complete Exercise")
                                    .font(.body)
                                    .foregroundColor(themeManager.textColor)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(themeManager.accentColor)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Daily Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.secondaryTextColor)
                }
            }
        }
    }
}

class DailyExerciseViewModel: ObservableObject {
    @Published var currentExercise: StoicExercise
    @Published var isExerciseComplete = false
    @Published var reflectionText = ""
    
    init() {
        // TODO: Load exercise from persistent storage or API
        self.currentExercise = StoicExercise(
            id: UUID(),
            date: Date(),
            quote: "The happiness of your life depends upon the quality of your thoughts.",
            author: "Marcus Aurelius",
            exercise: "Practice negative visualization by imagining the loss of something you value. This exercise helps cultivate gratitude and resilience.",
            steps: [
                "Choose something you value (e.g., health, relationships, career)",
                "Imagine it being taken away",
                "Reflect on how you would cope",
                "Appreciate what you have now",
                "Write down your insights"
            ]
        )
    }
    
    func completeExercise() {
        isExerciseComplete = true
        // TODO: Save completion status
    }
    
    func saveReflection() {
        // TODO: Save reflection to persistent storage
        print("Saving reflection: \(reflectionText)")
    }
}

struct StoicExercise: Identifiable {
    let id: UUID
    let date: Date
    let quote: String
    let author: String
    let exercise: String
    let steps: [String]
}

struct ExerciseReflectionView: View {
    @ObservedObject var viewModel: DailyExerciseViewModel
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Reflection Prompt")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            TextEditor(text: $viewModel.reflectionText)
                .frame(height: 120)
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(12)
                .foregroundColor(themeManager.textColor)
            Button("Save Reflection") {
                viewModel.saveReflection()
            }
            .padding()
            .background(themeManager.accentColor)
            .foregroundColor(themeManager.textColor)
            .cornerRadius(8)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
}

struct ReflectionPromptsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    let selectedPrompt: (String) -> Void
    
    private let prompts = [
        "What insights did you gain from this exercise?",
        "How did this practice affect your perspective?",
        "What challenges did you encounter?",
        "How can you apply these insights in your daily life?",
        "What would you like to explore further?"
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                themeManager.backgroundColor.ignoresSafeArea()
                
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(prompts, id: \.self) { prompt in
                            Button {
                                selectedPrompt(prompt)
                            } label: {
                                Text(prompt)
                                    .font(.body)
                                    .foregroundColor(themeManager.textColor)
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(themeManager.cardBackgroundColor)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Reflection Prompts")
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
    DailyExerciseView()
        .environmentObject(ThemeManager())
} 