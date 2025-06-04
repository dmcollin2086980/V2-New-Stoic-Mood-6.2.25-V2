import Foundation

/// Represents a single data point in the mood flow chart
struct MoodDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

/// Represents the distribution of moods across entries
struct MoodDistribution: Identifiable {
    let id = UUID()
    let mood: Mood
    let count: Int
    let percentage: Double
}

/// Represents the analysis of journal text
struct TextAnalysis {
    let averageLength: Int
    let topWords: [String]
    let writingStyle: String
    let sentiment: Double
    let themes: [String]
}

/// Represents a transition between moods
struct MoodTransition: Identifiable {
    let id = UUID()
    let from: Mood
    let to: Mood
    let count: Int
}

/// Represents a time-based pattern in mood entries
struct TimePattern: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
}

/// Represents a growth insight
struct GrowthInsight: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let progress: Double
}

/// Represents the quality of reflection
struct ReflectionQuality {
    let length: Int
    let consistency: Int
    let feedback: String?
} 