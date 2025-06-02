import SwiftUI

struct JournalView: View {
    @ObservedObject var viewModel: MoodViewModel
    @State private var showingExportOptions = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $viewModel.searchQuery)
                    .padding()
                
                // Filter Buttons
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(JournalFilter.allCases, id: \.self) { filter in
                            FilterButton(
                                title: filter.rawValue,
                                isSelected: viewModel.currentFilter == filter
                            ) {
                                viewModel.currentFilter = filter
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
                
                // Journal Entries
                if viewModel.filteredEntries().isEmpty {
                    EmptyJournalView(searchQuery: viewModel.searchQuery)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(viewModel.filteredEntries()) { entry in
                                JournalEntryCard(entry: entry)
                                    .transition(.opacity)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingExportOptions = true }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showingExportOptions) {
                ExportOptionsView()
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            TextField("Search entries...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Theme.dark.secondaryTextColor)
                }
            }
        }
        .padding(10)
        .background(Theme.dark.tertiaryBackgroundColor)
        .cornerRadius(10)
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.dark.accentColor : Theme.dark.secondaryBackgroundColor)
                .foregroundColor(isSelected ? Theme.dark.primaryTextColor : Theme.dark.secondaryTextColor)
                .cornerRadius(8)
        }
    }
}

struct JournalEntryCard: View {
    let entry: MoodEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(entry.timestamp.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(Theme.dark.tertiaryTextColor)
                
                Spacer()
                
                Text(entry.mood.emoji)
                    .font(.title2)
            }
            
            Text(entry.content)
                .font(.body)
                .foregroundColor(Theme.dark.primaryTextColor)
                .lineLimit(nil)
            
            HStack {
                Text("\(entry.wordCount) words")
                    .font(.caption)
                    .foregroundColor(Theme.dark.tertiaryTextColor)
                
                if entry.isQuickEntry {
                    Text("Quick Entry")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Theme.dark.accentColor)
                        .foregroundColor(Theme.dark.primaryTextColor)
                        .cornerRadius(4)
                }
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
}

struct EmptyJournalView: View {
    let searchQuery: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "book")
                .font(.system(size: 48))
                .foregroundColor(Theme.dark.tertiaryTextColor)
            
            Text(searchQuery.isEmpty ? "Your journal is empty" : "No entries found")
                .font(.headline)
                .foregroundColor(Theme.dark.primaryTextColor)
            
            Text(searchQuery.isEmpty ? "Add your first entry to begin" : "Try adjusting your filters or search terms")
                .font(.subheadline)
                .foregroundColor(Theme.dark.secondaryTextColor)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.dark.backgroundColor)
    }
}

struct ExportOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ExportOptionRow(title: "PDF Document", description: "Beautiful formatted journal with all entries", icon: "doc.text")
                    ExportOptionRow(title: "CSV Spreadsheet", description: "Data format for analysis in Excel or Google Sheets", icon: "tablecells")
                    ExportOptionRow(title: "JSON Data", description: "Raw data format for backup or import", icon: "doc.badge.gearshape")
                    ExportOptionRow(title: "Markdown", description: "Plain text format for note-taking apps", icon: "doc.plaintext")
                }
            }
            .navigationTitle("Export Journal")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ExportOptionRow: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(Theme.dark.accentColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(Theme.dark.secondaryTextColor)
            }
        }
        .padding(.vertical, 8)
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView(viewModel: MoodViewModel())
    }
} 