import SwiftUI
import Speech

struct JournalEntryView: View {
    @StateObject private var viewModel: JournalEntryViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    init(moodViewModel: MoodViewModel, initialPrompt: String? = nil) {
        _viewModel = StateObject(wrappedValue: JournalEntryViewModel(moodViewModel: moodViewModel, initialPrompt: initialPrompt))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.padding) {
                // Prompt Section
                VStack(alignment: .leading, spacing: Theme.smallPadding) {
                    Text("Reflection Prompt")
                        .font(.headline)
                        .themeText()
                    
                    Text(viewModel.currentPrompt)
                        .font(.body)
                        .themeText()
                }
                .padding()
                .themeCard()
                
                // Journal Text Editor
                TextEditor(text: $viewModel.journalText)
                    .frame(maxHeight: .infinity)
                    .padding()
                    .themeCard()
                    .themeText()
                
                // Voice Recording Button
                HStack {
                    Button(action: {
                        if viewModel.isRecording {
                            viewModel.stopRecording()
                        } else {
                            viewModel.startRecording()
                        }
                    }) {
                        Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(viewModel.isRecording ? .red : Theme.accentColor)
                    }
                    
                    if viewModel.isRecording {
                        Text("Recording...")
                            .themeText()
                    }
                }
                .padding()
            }
            .padding()
            .themeBackground()
            .navigationTitle("New Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .themeText()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // Save entry
                        dismiss()
                    }
                    .themeText()
                }
            }
            .alert("Microphone Access Required", isPresented: $viewModel.showingPermissionAlert) {
                Button("Settings", role: .none) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Please enable microphone access in Settings to use voice recording.")
            }
        }
    }
}

#Preview {
    JournalEntryView(moodViewModel: MoodViewModel())
        .environmentObject(ThemeManager())
} 