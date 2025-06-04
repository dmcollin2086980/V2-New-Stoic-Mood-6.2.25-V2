import Foundation
import SwiftUI

class MoodViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []
    @Published var textAnalysis: TextAnalysis?
    @Published var moodTransitions: [MoodTransition]?
    @Published var timePatterns: [TimePatternData] = []
    @Published var growthInsights: [String]?
    @Published var reflectionQuality: ReflectionQuality?
    @Published var currentStreak: Int = 0
    @Published var moodFlowData: [MoodFlowData] = []
    
    private let journalManager = JournalManager.shared
    
    init() {
        loadData()
    }
    
    func loadData() {
        entries = journalManager.entries
        analyzeData()
        calculateCurrentStreak()
        calculateMoodFlowData()
    }
    
    private func analyzeData() {
        analyzeText()
        analyzeMoodTransitions()
        analyzeTimePatterns()
        generateGrowthInsights()
        calculateReflectionQuality()
    }
    
    private func analyzeText() {
        guard !entries.isEmpty else { return }
        
        let allText = entries.map { $0.content }.joined(separator: " ")
        let words = allText.split(separator: " ").map(String.init)
        let wordCount = words.count
        
        // Simple word frequency analysis
        let wordFrequencies = Dictionary(grouping: words, by: { $0.lowercased() })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
        
        let topWords = Array(wordFrequencies.prefix(10).map { $0.key })
        
        textAnalysis = TextAnalysis(
            averageLength: wordCount / entries.count,
            topWords: topWords,
            writingStyle: determineWritingStyle(words: words),
            sentiment: calculateSentiment(text: allText),
            themes: identifyThemes(words: words)
        )
    }
    
    private func analyzeMoodTransitions() {
        guard entries.count >= 2 else { return }
        
        var transitions: [MoodTransition] = []
        for i in 0..<entries.count - 1 {
            let from = entries[i].mood
            let to = entries[i + 1].mood
            
            if let index = transitions.firstIndex(where: { $0.from == from && $0.to == to }) {
                transitions[index] = MoodTransition(
                    from: from,
                    to: to,
                    count: transitions[index].count + 1
                )
            } else {
                transitions.append(MoodTransition(from: from, to: to, count: 1))
            }
        }
        
        moodTransitions = transitions.sorted { $0.count > $1.count }
    }
    
    private func analyzeTimePatterns() {
        var patterns: [TimePatternData] = []
        
        // Analyze morning entries
        let morningEntries = entries.filter { entry in
            let hour = Calendar.current.component(.hour, from: entry.date)
            return hour >= 5 && hour < 12
        }
        
        if !morningEntries.isEmpty {
            patterns.append(TimePatternData(
                icon: "sunrise.fill",
                title: "Morning Reflection",
                description: "You tend to journal in the morning \(String(morningEntries.count)) times",
                hour: 9,
                count: morningEntries.count
            ))
        }
        
        // Analyze evening entries
        let eveningEntries = entries.filter { entry in
            let hour = Calendar.current.component(.hour, from: entry.date)
            return hour >= 18 && hour < 24
        }
        
        if !eveningEntries.isEmpty {
            patterns.append(TimePatternData(
                icon: "moon.stars.fill",
                title: "Evening Reflection",
                description: "You tend to journal in the evening \(String(eveningEntries.count)) times",
                hour: 21,
                count: eveningEntries.count
            ))
        }
        
        timePatterns = patterns
    }
    
    private func generateGrowthInsights() {
        guard !entries.isEmpty else { return }
        
        var insights: [String] = []
        
        // Analyze consistency
        let consistency = calculateConsistency()
        if consistency < 0.5 {
            insights.append("Try to maintain a more consistent journaling schedule")
        }
        
        // Analyze depth
        let averageLength = entries.map { $0.content.split(separator: " ").count }.reduce(0, +) / entries.count
        if averageLength < 50 {
            insights.append("Consider writing longer entries to explore your thoughts more deeply")
        }
        
        growthInsights = insights
    }
    
    private func calculateReflectionQuality() {
        guard !entries.isEmpty else { return }
        
        let averageLength = entries.map { $0.content.split(separator: " ").count }.reduce(0, +) / entries.count
        let consistency = calculateConsistency()
        
        reflectionQuality = ReflectionQuality(
            length: averageLength,
            consistency: Int(consistency * 100),
            feedback: generateFeedback(length: averageLength, consistency: consistency)
        )
    }
    
    private func calculateCurrentStreak() {
        guard !entries.isEmpty else {
            currentStreak = 0
            return
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        var currentDate = today
        var streak = 0
        
        // Sort entries by date in descending order
        let sortedEntries = entries.sorted { $0.date > $1.date }
        
        // Check each day from today backwards
        while true {
            let hasEntry = sortedEntries.contains { entry in
                calendar.isDate(entry.date, inSameDayAs: currentDate)
            }
            
            if hasEntry {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                break
            }
        }
        
        currentStreak = streak
    }
    
    private func calculateMoodFlowData() {
        guard !entries.isEmpty else {
            moodFlowData = []
            return
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var dataPoints: [MoodFlowData] = []
        
        // Create a data point for each day
        for dayOffset in 0...6 {
            let date = calendar.date(byAdding: .day, value: dayOffset - 6, to: today)!
            
            // Get entries for this day
            let dayEntries = entries.filter { entry in
                calendar.isDate(entry.date, inSameDayAs: date)
            }
            
            if !dayEntries.isEmpty {
                // Calculate average mood value for the day
                let totalMoodValue = dayEntries.reduce(0) { sum, entry in
                    sum + entry.mood.toMoodType.value
                }
                let averageMoodValue = Double(totalMoodValue) / Double(dayEntries.count)
                
                dataPoints.append(MoodFlowData(
                    date: date,
                    value: averageMoodValue
                ))
            } else {
                // Add a data point with 0 value for days without entries
                dataPoints.append(MoodFlowData(
                    date: date,
                    value: 0
                ))
            }
        }
        
        moodFlowData = dataPoints
    }
    
    // MARK: - Helper Methods
    
    private func determineWritingStyle(words: [String]) -> String {
        let avgWordLength = Double(words.joined().count) / Double(words.count)
        let longWords = words.filter { $0.count > 6 }.count
        let longWordPercentage = Double(longWords) / Double(words.count)
        
        if avgWordLength > 5 && longWordPercentage > 0.2 {
            return "Reflective and detailed"
        } else if avgWordLength > 4 {
            return "Balanced and thoughtful"
        } else {
            return "Concise and direct"
        }
    }
    
    private func calculateSentiment(text: String) -> Double {
        // Simple sentiment analysis based on positive/negative word lists
        // In a real app, you'd use a more sophisticated NLP approach
        let positiveWords = ["happy", "joy", "grateful", "peace", "love", "good", "great", "wonderful"]
        let negativeWords = ["sad", "angry", "frustrated", "anxious", "bad", "terrible", "awful"]
        
        let words = text.lowercased().split(separator: " ").map(String.init)
        let positiveCount = words.filter { positiveWords.contains($0) }.count
        let negativeCount = words.filter { negativeWords.contains($0) }.count
        
        return Double(positiveCount - negativeCount) / Double(words.count)
    }
    
    private func identifyThemes(words: [String]) -> [String] {
        // Simple theme identification based on word frequency
        // In a real app, you'd use topic modeling or other NLP techniques
        let wordFrequencies = Dictionary(grouping: words, by: { $0.lowercased() })
            .mapValues { $0.count }
            .sorted { $0.value > $1.value }
        
        return Array(wordFrequencies.prefix(5).map { $0.key })
    }
    
    private func calculateConsistency() -> Double {
        guard !entries.isEmpty else { return 0 }
        
        let calendar = Calendar.current
        let dates = entries.map { calendar.startOfDay(for: $0.date) }
        let uniqueDates = Set(dates)
        
        return Double(uniqueDates.count) / Double(entries.count)
    }
    
    private func generateFeedback(length: Int, consistency: Double) -> String {
        if length < 30 && consistency < 0.5 {
            return "Try to write longer entries more consistently"
        } else if length < 30 {
            return "Consider writing longer entries to explore your thoughts more deeply"
        } else if consistency < 0.5 {
            return "Try to maintain a more consistent journaling schedule"
        } else {
            return "Great job maintaining a consistent and thoughtful journaling practice"
        }
    }
} 