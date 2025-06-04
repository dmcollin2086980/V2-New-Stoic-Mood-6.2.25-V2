import SwiftUI

/// A view that displays and manages journal entries.
/// This view provides functionality for viewing, filtering, and exporting journal entries.
struct JournalView: View {
    // MARK: - Properties
    
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    /// The state object that manages journal entries
    @StateObject private var journalManager = JournalManager.shared
    
    /// The search text used to filter journal entries
    @State private var searchText = ""
    
    /// The currently selected filter for journal entries
    @State private var selectedFilter: JournalFilter = .all
    
    /// A boolean indicating whether the journal flow sheet is presented
    @State private var showingJournalSheet = false
    
    /// The current step in the journal entry flow
    @State private var flowStep: JournalFlowStep = .moodSelection
    
    /// The selected mood and intensity for the new entry
    @State private var selectedMood: Mood?
    @State private var selectedIntensity: Double?
    
    /// A boolean indicating whether the export options view is presented
    @State private var showingExportOptions = false
    
    // MARK: - Computed Properties
    
    /// Returns the filtered journal entries based on search text and selected filter
    private var filteredEntries: [JournalEntry] {
        journalManager.entries.filter { entry in
            let matchesSearch = searchText.isEmpty || 
                entry.content.localizedCaseInsensitiveContains(searchText)
            
            let matchesFilter: Bool
            switch selectedFilter {
            case .all:
                matchesFilter = true
            case .thisWeek:
                matchesFilter = Calendar.current.isDate(entry.date, equalTo: Date(), toGranularity: .weekOfYear)
            case .thisMonth:
                matchesFilter = Calendar.current.isDate(entry.date, equalTo: Date(), toGranularity: .month)
            case .thisYear:
                matchesFilter = Calendar.current.isDate(entry.date, equalTo: Date(), toGranularity: .year)
            }
            
            return matchesSearch && matchesFilter
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: ThemeManager.padding) {
                    // Search bar
                    SearchBar(text: $searchText)
                        .padding(.horizontal)
                    
                    // Filter buttons
                    HStack(spacing: ThemeManager.smallPadding) {
                        ForEach(JournalFilter.allCases, id: \.self) { filter in
                            FilterButton(
                                title: filter.title,
                                isSelected: selectedFilter == filter,
                                action: { selectedFilter = filter }
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // Journal entries list
                    ScrollView {
                        LazyVStack(spacing: ThemeManager.padding) {
                            ForEach(filteredEntries) { entry in
                                JournalEntryCard(entry: entry)
                            }
                        }
                        .padding()
                    }
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { 
                            flowStep = .moodSelection
                            showingJournalSheet = true 
                        }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(themeManager.accentColor)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 3)
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
            .sheet(isPresented: $showingJournalSheet) {
                Group {
                    switch flowStep {
                    case .moodSelection:
                        MoodSelectionView { mood, intensity in
                            selectedMood = mood.toMood
                            selectedIntensity = Double(intensity) / 10.0
                            flowStep = .journalEntry
                        }
                    case .journalEntry:
                        if let mood = selectedMood, let intensity = selectedIntensity {
                            JournalEntryView(mood: mood, intensity: intensity) { content in
                                journalManager.addEntry(mood: mood, intensity: intensity, content: content)
                                selectedMood = nil
                                selectedIntensity = nil
                                showingJournalSheet = false
                            }
                        }
                    }
                }
                .presentationDetents([.large])
            }
            .sheet(isPresented: $showingExportOptions) {
                ExportOptionsView()
            }
        }
    }
}

/// The steps in the journal entry flow
enum JournalFlowStep {
    case moodSelection
    case journalEntry
}

/// A button used for filtering journal entries
struct FilterButton: View {
    /// The title text displayed on the button
    let title: String
    
    /// A boolean indicating whether the button is selected
    let isSelected: Bool
    
    /// The action to perform when the button is tapped
    let action: () -> Void
    
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, ThemeManager.padding)
                .padding(.vertical, ThemeManager.smallPadding)
                .background(isSelected ? themeManager.accentColor : themeManager.cardBackgroundColor)
                .foregroundColor(isSelected ? .white : themeManager.textColor)
                .cornerRadius(ThemeManager.cornerRadius)
        }
    }
}

/// A card view that displays a single journal entry
struct JournalEntryCard: View {
    /// The journal entry to display
    let entry: JournalEntry
    
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
            HStack {
                Text(entry.mood.emoji)
                    .font(.title)
                Text(entry.mood.name)
                    .font(.headline)
                Spacer()
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Text(entry.content)
                .font(.body)
                .foregroundColor(themeManager.textColor)
            
            HStack {
                Text("Intensity: \(Int(entry.intensity * 100))%")
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryTextColor)
                Spacer()
                Text("\(entry.wordCount) words")
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(ThemeManager.cornerRadius)
    }
}

/// A view that provides options for exporting journal entries
struct ExportOptionsView: View {
    /// The environment object that provides theme-related functionality
    @EnvironmentObject var themeManager: ThemeManager
    
    /// The state object that manages journal entries
    @StateObject private var journalManager = JournalManager.shared
    
    /// A boolean indicating whether the view is presented
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button("Export as PDF") {
                        // TODO: Implement PDF export
                        dismiss()
                    }
                    
                    Button("Export as CSV") {
                        // TODO: Implement CSV export
                        dismiss()
                    }
                    
                    Button("Export as JSON") {
                        // TODO: Implement JSON export
                        dismiss()
                    }
                }
            }
            .navigationTitle("Export Options")
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

// MARK: - Preview

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
            .environmentObject(ThemeManager())
    }
} 
