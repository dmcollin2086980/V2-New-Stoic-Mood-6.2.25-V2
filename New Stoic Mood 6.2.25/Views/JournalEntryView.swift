import SwiftUI

struct JournalEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: MoodViewModel
    let selectedMood: MoodType
    
    @State private var content: String = ""
    @State private var isQuickEntry: Bool = false
    @State private var showingDiscardAlert: Bool = false
    
    private var wordCount: Int {
        content.split(separator: " ").count
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Mood Header
                HStack {
                    Text(selectedMood.emoji)
                        .font(.system(size: 40))
                    
                    VStack(alignment: .leading) {
                        Text(selectedMood.displayName)
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        Text("How are you feeling about this?")
                            .font(.subheadline)
                            .foregroundColor(Theme.dark.secondaryTextColor)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Theme.dark.secondaryBackgroundColor)
                
                // Journal Entry
                TextEditor(text: $content)
                    .font(.body)
                    .padding()
                    .background(Theme.dark.backgroundColor)
                    .scrollContentBackground(.hidden)
                
                // Bottom Bar
                VStack(spacing: 0) {
                    Divider()
                    
                    HStack {
                        // Word Count
                        Text("\(wordCount) words")
                            .font(.caption)
                            .foregroundColor(Theme.dark.secondaryTextColor)
                        
                        Spacer()
                        
                        // Quick Entry Toggle
                        Toggle("Quick Entry", isOn: $isQuickEntry)
                            .toggleStyle(SwitchToggleStyle(tint: Theme.dark.accentColor))
                            .labelsHidden()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Theme.dark.secondaryBackgroundColor)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        if !content.isEmpty {
                            showingDiscardAlert = true
                        } else {
                            dismiss()
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(content.isEmpty)
                }
            }
            .alert("Discard Entry?", isPresented: $showingDiscardAlert) {
                Button("Discard", role: .destructive) {
                    dismiss()
                }
                Button("Keep Editing", role: .cancel) {}
            } message: {
                Text("Are you sure you want to discard this entry?")
            }
        }
    }
    
    private func saveEntry() {
        let entry = MoodEntry(
            mood: selectedMood,
            content: content,
            isQuickEntry: isQuickEntry
        )
        viewModel.addEntry(entry)
        dismiss()
    }
}

struct JournalEntryView_Previews: PreviewProvider {
    static var previews: some View {
        JournalEntryView(
            viewModel: MoodViewModel(),
            selectedMood: .content
        )
    }
} 