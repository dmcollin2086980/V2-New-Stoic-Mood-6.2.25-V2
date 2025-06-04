import Foundation
import SwiftUI

class JournalViewModel: ObservableObject {
    @Published var entries: [MoodEntry] = []
    
    init() {
        // Load saved entries or initialize with empty array
        loadEntries()
    }
    
    func addEntry(mood: MoodType, intensity: Int, content: String = "") {
        let now = Date()
        let entry = MoodEntry(
            id: now,
            mood: mood,
            content: content,
            timestamp: now,
            wordCount: content.split(separator: " ").count,
            isQuickEntry: false
        )
        entries.insert(entry, at: 0)
        saveEntries()
    }
    
    private func loadEntries() {
        // TODO: Implement loading from persistent storage
        // For now, using sample data
        let now = Date()
        let yesterday = now.addingTimeInterval(-86400)
        
        entries = [
            MoodEntry(
                id: now,
                mood: .calm,
                content: "Feeling balanced and at peace today. The morning meditation helped set a positive tone.",
                timestamp: now,
                wordCount: 15,
                isQuickEntry: false
            ),
            MoodEntry(
                id: yesterday,
                mood: .focused,
                content: "Productive day at work. Managed to complete several important tasks.",
                timestamp: yesterday,
                wordCount: 10,
                isQuickEntry: false
            )
        ]
    }
    
    private func saveEntries() {
        // TODO: Implement saving to persistent storage
    }
} 