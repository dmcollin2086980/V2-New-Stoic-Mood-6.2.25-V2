import Foundation
import SwiftUI

class MoodViewModel: ObservableObject {
    @Published var entries: [MoodEntry] = []
    @Published var currentFilter: JournalFilter = .all
    @Published var searchQuery: String = ""
    @Published var currentStreak: Int = 0
    @Published var totalEntries: Int = 0
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "moodEntries"
    
    init() {
        loadEntries()
        updateStats()
    }
    
    func addEntry(_ entry: MoodEntry) {
        entries.insert(entry, at: 0)
        saveEntries()
        updateStats()
    }
    
    func deleteEntry(_ entry: MoodEntry) {
        entries.removeAll { $0.id == entry.id }
        saveEntries()
        updateStats()
    }
    
    func updateEntry(_ entry: MoodEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntries()
        }
    }
    
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let decoded = try? JSONDecoder().decode([MoodEntry].self, from: data) {
            entries = decoded
        }
    }
    
    private func updateStats() {
        totalEntries = entries.count
        currentStreak = calculateStreak()
    }
    
    func calculateStreak() -> Int {
        if entries.isEmpty { return 0 }
        
        var streak = 0
        let today = Calendar.current.startOfDay(for: Date())
        
        for i in 0..<entries.count {
            let entryDate = Calendar.current.startOfDay(for: entries[i].timestamp)
            let dayDiff = Calendar.current.dateComponents([.day], from: entryDate, to: today).day ?? 0
            
            if dayDiff == streak {
                streak += 1
            } else if dayDiff > streak {
                break
            }
        }
        
        return streak
    }
    
    func filteredEntries() -> [MoodEntry] {
        var filtered = entries
        
        // Apply time filter
        switch currentFilter {
        case .week:
            let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            filtered = filtered.filter { $0.timestamp > weekAgo }
        case .month:
            let monthAgo = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            filtered = filtered.filter { $0.timestamp > monthAgo }
        case .all:
            break
        }
        
        // Apply search filter
        if !searchQuery.isEmpty {
            filtered = filtered.filter {
                $0.content.localizedCaseInsensitiveContains(searchQuery) ||
                $0.mood.rawValue.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        return filtered
    }
    
    func entriesForLastSevenDays() -> [MoodEntry] {
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        return entries.filter { $0.timestamp >= sevenDaysAgo }
    }
    
    func averageMoodForDate(_ date: Date) -> Double? {
        let dayEntries = entries.filter {
            Calendar.current.isDate($0.timestamp, inSameDayAs: date)
        }
        
        guard !dayEntries.isEmpty else { return nil }
        
        let total = dayEntries.reduce(0) { $0 + $1.mood.value }
        return Double(total) / Double(dayEntries.count)
    }
    
    func exportAsCSV() -> String {
        var csv = "Date,Time,Mood,Entry,Word Count\n"
        entries.forEach { entry in
            let date = entry.timestamp.formatted(date: .numeric, time: .omitted)
            let time = entry.timestamp.formatted(date: .omitted, time: .shortened)
            let content = entry.content.replacingOccurrences(of: "\"", with: "\"\"")
            csv += "\"\(date)\",\"\(time)\",\"\(entry.mood.displayName)\",\"\(content)\",\(entry.wordCount)\n"
        }
        return csv
    }
    
    func exportAsPDF() -> String {
        var html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Mood Journal</title>
            <style>
                body { font-family: -apple-system, system-ui, sans-serif; margin: 40px; color: #333; }
                h1 { color: #1a1a1a; margin-bottom: 30px; }
                .entry { margin-bottom: 30px; page-break-inside: avoid; }
                .date { font-weight: bold; color: #666; }
                .mood { display: inline-block; margin-left: 10px; }
                .content { margin-top: 10px; line-height: 1.6; }
                .wordcount { font-size: 12px; color: #999; margin-top: 5px; }
            </style>
        </head>
        <body>
            <h1>Mood Journal</h1>
            <p>Generated on \(Date().formatted(date: .long, time: .shortened))</p>
            <hr>
        """
        
        entries.forEach { entry in
            html += """
                <div class="entry">
                    <div class="date">\(entry.timestamp.formatted(date: .long, time: .shortened))</div>
                    <div class="mood">Mood: \(entry.mood.displayName) \(entry.mood.emoji)</div>
                    <div class="content">\(entry.content)</div>
                    <div class="wordcount">Words: \(entry.wordCount)</div>
                </div>
            """
        }
        
        html += "</body></html>"
        return html
    }
}

enum JournalFilter: String, CaseIterable {
    case all = "All"
    case week = "This Week"
    case month = "This Month"
} 