import SwiftUI
import Speech

struct EnhancedJournalEntryView: View {
    @StateObject private var viewModel: JournalEntryViewModel
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var showingPrompts = false
    @State private var showingMicrophoneAlert = false
    
    init(moodViewModel: MoodViewModel) {
        _viewModel = StateObject(wrappedValue: JournalEntryViewModel(moodViewModel: moodViewModel))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.padding) {
                // Journal Text Editor
                TextEditor(text: $viewModel.journalText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .background(themeManager.backgroundColor)
                    .cornerRadius(Theme.cornerRadius)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .stroke(themeManager.accentColor, lineWidth: 1)
                    )
                
                // Voice Recording Button
                Button(action: {
                    if viewModel.isRecording {
                        viewModel.stopRecording()
                    } else {
                        if viewModel.showingPermissionAlert {
                            showingMicrophoneAlert = true
                        } else {
                            viewModel.startRecording()
                        }
                    }
                }) {
                    HStack {
                        Image(systemName: viewModel.isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.title)
                        Text(viewModel.isRecording ? "Stop Recording" : "Start Recording")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(themeManager.accentColor)
                    .foregroundColor(themeManager.backgroundColor)
                    .cornerRadius(Theme.cornerRadius)
                }
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(themeManager.textColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.saveEntry(mood: .reflective, intensity: 5, content: viewModel.journalText)
                        dismiss()
                    }
                    .foregroundColor(themeManager.textColor)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingPrompts = true }) {
                        Image(systemName: "lightbulb")
                    }
                    .foregroundColor(themeManager.textColor)
                }
            }
            .sheet(isPresented: $showingPrompts) {
                PromptsView(
                    onPromptSelected: { prompt in
                        viewModel.journalText += "\n\n" + prompt
                        showingPrompts = false
                    },
                    themeManager: themeManager
                )
            }
            .alert("Microphone Access Required", isPresented: $showingMicrophoneAlert) {
                Button("Settings", role: .none) {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enable microphone access in Settings to use voice recording.")
            }
            .background(themeManager.backgroundColor)
        }
    }
}

#Preview {
    EnhancedJournalEntryView(moodViewModel: MoodViewModel())
        .environmentObject(ThemeManager())
} 
