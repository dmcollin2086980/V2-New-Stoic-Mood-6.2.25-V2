import Foundation

/// A manager class that handles journal entries and their persistence
class JournalManager: ObservableObject {
    /// The shared instance of the journal manager
    static let shared = JournalManager()
    
    /// The array of journal entries
    @Published private(set) var entries: [JournalEntry] = []
    
    private init() {
        loadEntries()
    }
    
    /// Adds a new journal entry
    /// - Parameters:
    ///   - mood: The mood associated with the entry
    ///   - intensity: The intensity of the mood (0.0 to 1.0)
    ///   - content: The content of the journal entry
    func addEntry(mood: Mood, intensity: Double, content: String = "") {
        let entry = JournalEntry(
            id: UUID(),
            date: Date(),
            mood: mood,
            intensity: intensity,
            content: content
        )
        entries.insert(entry, at: 0)
        saveEntries()
    }
    
    /// Deletes a journal entry
    /// - Parameter entry: The entry to delete
    func deleteEntry(_ entry: JournalEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    /// Updates an existing journal entry
    /// - Parameter entry: The updated entry
    func updateEntry(_ entry: JournalEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    // MARK: - Private Methods
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "journalEntries")
        }
    }
    
    private func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: "journalEntries"),
           let decoded = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            entries = decoded
        }
    }
}

/// A model representing a journal entry
struct JournalEntry: Identifiable, Codable {
    /// The unique identifier of the entry
    let id: UUID
    
    /// The date when the entry was created
    let date: Date
    
    /// The mood associated with the entry
    let mood: Mood
    
    /// The intensity of the mood (0.0 to 1.0)
    let intensity: Double
    
    /// The content of the journal entry
    let content: String
    
    /// The number of words in the entry
    var wordCount: Int {
        content.split(separator: " ").count
    }
} 