import SwiftUI
import Speech

struct JournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    let mood: Mood
    let intensity: Double
    let onSave: (String) -> Void
    
    @State private var journalText = ""
    @State private var isRecording = false
    @State private var showingPermissionAlert = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.padding) {
                // Mood and Intensity Display
                HStack {
                    Text(mood.emoji)
                        .font(.title)
                    Text(mood.name)
                        .font(.headline)
                    Spacer()
                    Text("Intensity: \(Int(intensity * 100))%")
                        .font(.subheadline)
                        .foregroundColor(themeManager.secondaryTextColor)
                }
                .padding()
                .background(themeManager.cardBackgroundColor)
                .cornerRadius(ThemeManager.cornerRadius)
                
                // Journal Text Editor
                TextEditor(text: $journalText)
                    .frame(maxHeight: .infinity)
                    .padding()
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(ThemeManager.cornerRadius)
                    .foregroundColor(themeManager.textColor)
                
                // Voice Recording Button
                HStack {
                    Button(action: {
                        if isRecording {
                            stopRecording()
                        } else {
                            startRecording()
                        }
                    }) {
                        Image(systemName: isRecording ? "stop.circle.fill" : "mic.circle.fill")
                            .font(.system(size: 44))
                            .foregroundColor(isRecording ? .red : themeManager.accentColor)
                    }
                    
                    if isRecording {
                        Text("Recording...")
                            .foregroundColor(themeManager.textColor)
                    }
                }
                .padding()
            }
            .padding()
            .background(themeManager.backgroundColor)
            .navigationTitle("New Entry")
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
                        onSave(journalText)
                        dismiss()
                    }
                    .foregroundColor(themeManager.textColor)
                }
            }
            .alert("Microphone Access Required", isPresented: $showingPermissionAlert) {
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
    
    private func startRecording() {
        // TODO: Implement voice recording
        isRecording = true
    }
    
    private func stopRecording() {
        // TODO: Implement voice recording
        isRecording = false
    }
}

#Preview {
    JournalEntryView(mood: .happy, intensity: 0.8) { _ in }
        .environmentObject(ThemeManager())
} 