import SwiftUI
import Charts

struct InsightsView: View {
    @ObservedObject var viewModel: MoodViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time of Day Patterns
                    TimePatternsView(viewModel: viewModel)
                        .padding(.horizontal)
                    
                    // Mood Transitions
                    MoodTransitionsView(viewModel: viewModel)
                        .padding(.horizontal)
                    
                    // Journal Analysis
                    JournalAnalysisView(viewModel: viewModel)
                        .padding(.horizontal)
                    
                    // Emotional Patterns
                    EmotionalPatternsView(viewModel: viewModel)
                        .padding(.horizontal)
                    
                    // Growth Insights
                    GrowthInsightsView(viewModel: viewModel)
                        .padding(.horizontal)
                    
                    // Reflection Quality
                    ReflectionQualityView(viewModel: viewModel)
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Insights")
        }
    }
}

struct TimePatternsView: View {
    @ObservedObject var viewModel: MoodViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Patterns by Time of Day")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 5) {
                ForEach(0..<24) { hour in
                    let entries = viewModel.entries.filter {
                        Calendar.current.component(.hour, from: $0.timestamp) == hour
                    }
                    
                    VStack {
                        Text(String(format: "%02d:00", hour))
                            .font(.caption2)
                            .foregroundColor(Theme.dark.tertiaryTextColor)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(entries.isEmpty ? Theme.dark.tertiaryBackgroundColor : Theme.dark.accentColor)
                            .frame(height: 30)
                    }
                }
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
}

struct MoodTransitionsView: View {
    @ObservedObject var viewModel: MoodViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Transitions")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: MoodType.allCases.count), spacing: 2) {
                ForEach(MoodType.allCases, id: \.self) { fromMood in
                    ForEach(MoodType.allCases, id: \.self) { toMood in
                        let transitions = viewModel.entries.enumerated().filter { index, entry in
                            guard index < viewModel.entries.count - 1 else { return false }
                            return entry.mood == fromMood && viewModel.entries[index + 1].mood == toMood
                        }
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(transitions.isEmpty ? Theme.dark.tertiaryBackgroundColor : Theme.dark.accentColor)
                            .frame(height: 30)
                            .overlay(
                                Text("\(transitions.count)")
                                    .font(.caption2)
                                    .foregroundColor(Theme.dark.primaryTextColor)
                            )
                    }
                }
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
}

struct JournalAnalysisView: View {
    @ObservedObject var viewModel: MoodViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Journal Analysis")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            if viewModel.entries.isEmpty {
                Text("Start journaling to see your analysis")
                    .foregroundColor(Theme.dark.secondaryTextColor)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Average entry length: \(averageWordCount) words")
                    Text("Most common mood: \(mostCommonMood)")
                    Text("Best writing time: \(bestWritingTime)")
                }
                .foregroundColor(Theme.dark.primaryTextColor)
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
    
    private var averageWordCount: Int {
        let total = viewModel.entries.reduce(0) { $0 + $1.wordCount }
        return total / max(1, viewModel.entries.count)
    }
    
    private var mostCommonMood: String {
        let moodCounts = Dictionary(grouping: viewModel.entries, by: { $0.mood })
            .mapValues { $0.count }
        return moodCounts.max(by: { $0.value < $1.value })?.key.displayName ?? "N/A"
    }
    
    private var bestWritingTime: String {
        let hourCounts = Dictionary(grouping: viewModel.entries) {
            Calendar.current.component(.hour, from: $0.timestamp)
        }.mapValues { $0.count }
        
        if let bestHour = hourCounts.max(by: { $0.value < $1.value })?.key {
            return String(format: "%02d:00", bestHour)
        }
        return "N/A"
    }
}

struct EmotionalPatternsView: View {
    @ObservedObject var viewModel: MoodViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Emotional Patterns")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            if viewModel.entries.isEmpty {
                Text("Start tracking your moods to discover patterns")
                    .foregroundColor(Theme.dark.secondaryTextColor)
            } else {
                VStack(spacing: 8) {
                    ForEach(MoodType.allCases, id: \.self) { mood in
                        let count = viewModel.entries.filter { $0.mood == mood }.count
                        let percentage = Double(count) / Double(viewModel.entries.count) * 100
                        
                        HStack {
                            Text(mood.emoji)
                            Text(mood.displayName)
                            Spacer()
                            Text("\(Int(percentage))%")
                                .foregroundColor(Theme.dark.secondaryTextColor)
                        }
                        .foregroundColor(Theme.dark.primaryTextColor)
                    }
                }
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
}

struct GrowthInsightsView: View {
    @ObservedObject var viewModel: MoodViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Growth Opportunities")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            if viewModel.entries.count < 5 {
                Text("Add more entries to see growth insights")
                    .foregroundColor(Theme.dark.secondaryTextColor)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your reflection depth is \(reflectionTrend).")
                    Text("Average \(averageWordsPerDay) words per day this week.")
                    Text("Consider exploring deeper themes in your reflections.")
                }
                .foregroundColor(Theme.dark.primaryTextColor)
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
    
    private var reflectionTrend: String {
        let recentEntries = viewModel.entries.prefix(7)
        let olderEntries = viewModel.entries.dropFirst(7).prefix(7)
        
        let recentAvg = recentEntries.reduce(0) { $0 + $1.wordCount } / max(1, recentEntries.count)
        let olderAvg = olderEntries.reduce(0) { $0 + $1.wordCount } / max(1, olderEntries.count)
        
        return recentAvg > olderAvg ? "increasing" : "steady"
    }
    
    private var averageWordsPerDay: Int {
        let weekEntries = viewModel.entries.prefix(7)
        let totalWords = weekEntries.reduce(0) { $0 + $1.wordCount }
        return totalWords / max(1, weekEntries.count)
    }
}

struct ReflectionQualityView: View {
    @ObservedObject var viewModel: MoodViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Reflection Quality")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            if viewModel.entries.isEmpty {
                Text("Start journaling to track your reflection quality")
                    .foregroundColor(Theme.dark.secondaryTextColor)
            } else {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Average reflection length: \(averageWordCount) words")
                    Text("Current consistency streak: \(viewModel.currentStreak) days")
                    Text(qualityFeedback)
                }
                .foregroundColor(Theme.dark.primaryTextColor)
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
    
    private var averageWordCount: Int {
        let total = viewModel.entries.reduce(0) { $0 + $1.wordCount }
        return total / max(1, viewModel.entries.count)
    }
    
    private var qualityFeedback: String {
        if averageWordCount > 50 {
            return "Your reflections show good depth and thoughtfulness."
        } else {
            return "Try writing longer reflections to explore your thoughts more deeply."
        }
    }
}

struct InsightsView_Previews: PreviewProvider {
    static var previews: some View {
        InsightsView(viewModel: MoodViewModel())
    }
} 