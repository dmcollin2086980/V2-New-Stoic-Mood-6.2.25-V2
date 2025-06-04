import SwiftUI
import Charts

struct TimePatternsView: View {
    let timePatterns: [TimePatternData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Time Patterns")
                .font(.headline)
            if !timePatterns.isEmpty {
                ForEach(timePatterns) { pattern in
                    TimePatternCard(pattern: pattern)
                }
            } else {
                Text("Not enough data")
                    .foregroundColor(themeManager.secondaryTextColor)
            }
        }
        .padding(.vertical, 8)
    }
}

struct InsightMoodFlowChartView: View {
    let data: [MoodFlowData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            Text("Mood Flow")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            Chart(data) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Mood", point.value)
                )
                .foregroundStyle(themeManager.accentColor)
                PointMark(
                    x: .value("Date", point.date),
                    y: .value("Mood", point.value)
                )
                .foregroundStyle(themeManager.accentColor)
            }
            .frame(height: 200)
            .chartYScale(domain: 1...5)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.weekday())
                }
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}

struct MoodTransitionsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Mood Transitions")
                .font(.headline)
            
            if let transitions = viewModel.moodTransitions {
                ForEach(transitions, id: \.from) { transition in
                    HStack {
                        Text("\(transition.from) → \(transition.to)")
                            .foregroundColor(themeManager.textColor)
                        Spacer()
                        Text("\(transition.count) times")
                            .foregroundColor(themeManager.secondaryTextColor)
                    }
                }
            } else {
                Text("Not enough data")
                    .foregroundColor(themeManager.secondaryTextColor)
            }
        }
        .padding(.vertical, 8)
    }
}

struct JournalAnalysisView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Journal Analysis")
                .font(.headline)
            
            if let analysis = viewModel.textAnalysis {
                VStack(alignment: .leading, spacing: 8) {
                    StatRow(title: "Average Length", value: "\(analysis.averageLength) words")
                    StatRow(title: "Most Used Words", value: analysis.topWords.joined(separator: ", "))
                    StatRow(title: "Writing Style", value: analysis.writingStyle)
                }
            } else {
                Text("Not enough data")
                    .foregroundColor(themeManager.secondaryTextColor)
            }
        }
        .padding(.vertical, 8)
    }
}

struct EmotionalPatternsView: View {
    let patterns: [String]?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            if let patterns = patterns {
                ForEach(patterns, id: \.self) { pattern in
                    Text(pattern)
                        .foregroundColor(themeManager.textColor)
                }
            } else {
                Text("Add more entries to see emotional patterns")
                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.7))
            }
        }
    }
}

struct GrowthInsightsView: View {
    let insights: [String]?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            if let insights = insights {
                ForEach(insights, id: \.self) { insight in
                    Text(insight)
                        .foregroundColor(themeManager.textColor)
                }
            } else {
                Text("Continue journaling to receive growth insights")
                    .foregroundColor(themeManager.secondaryTextColor.opacity(0.7))
            }
        }
    }
}

struct ReflectionQualityView: View {
    let length: Int
    let consistency: Int
    let feedback: String?
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            Text("Reflection Quality")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            Text("Average Length: \(length) words")
                .foregroundColor(themeManager.textColor)
            Text("Consistency: \(consistency)%")
                .foregroundColor(themeManager.textColor)
            if let feedback = feedback {
                Text(feedback)
                    .font(.subheadline)
                    .foregroundColor(themeManager.accentColor)
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}

struct StatRow: View {
    let title: String
    let value: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(themeManager.textColor)
            Spacer()
            Text(value)
                .foregroundColor(themeManager.secondaryTextColor)
        }
    }
}

struct InsightComponents: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 20) {
            TimePatternsView(timePatterns: viewModel.timePatterns)
            GrowthInsightsView(insights: viewModel.growthInsights)
            // Add other sections as needed, passing data from viewModel
        }
        .padding()
    }
}

struct TimePatternCard: View {
    let pattern: TimePatternData
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack {
            Image(systemName: pattern.icon)
                .font(.title2)
                .foregroundColor(themeManager.accentColor)
                .frame(width: 40)
            
            VStack(alignment: .leading) {
                Text(pattern.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(themeManager.textColor)
                Text(pattern.description)
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(10)
    }
}

struct GrowthInsightCard: View {
    let insight: GrowthInsight
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(insight.title)
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Text(insight.description)
                .font(.subheadline)
                .foregroundColor(themeManager.secondaryTextColor)
            
            ProgressView(value: insight.progress)
                .tint(themeManager.accentColor)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(10)
    }
}

struct MoodDistributionChart: View {
    let data: [MoodDistribution]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            Text("Mood Distribution")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Chart(data) { distribution in
                BarMark(
                    x: .value("Mood", distribution.mood.rawValue),
                    y: .value("Count", distribution.count)
                )
                .foregroundStyle(themeManager.accentColor)
            }
            .frame(height: 200)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}

struct TimeOfDayHeatmap: View {
    let data: [[Int]]
    private let timeLabels = ["12am-3am", "3am-6am", "6am-9am", "9am-12pm", "12pm-3pm", "3pm-6pm", "6pm-9pm", "9pm-12am"]
    private let dayLabels = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            HStack(alignment: .top, spacing: Theme.smallPadding) {
                // Time labels
                VStack(alignment: .trailing, spacing: Theme.smallPadding) {
                    ForEach(timeLabels, id: \.self) { label in
                        Text(label)
                            .font(.caption)
                            .foregroundColor(themeManager.textColor)
                    }
                }
                
                // Heatmap grid
                VStack(spacing: Theme.smallPadding) {
                    // Day labels
                    HStack(spacing: Theme.smallPadding) {
                        ForEach(dayLabels, id: \.self) { day in
                            Text(day)
                                .font(.caption)
                                .foregroundColor(themeManager.textColor)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Grid cells
                    ForEach(0..<8) { row in
                        HStack(spacing: Theme.smallPadding) {
                            ForEach(0..<7) { col in
                                let count = data[row][col]
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(count > 0 ? themeManager.accentColor.opacity(Double(count) / 3.0) : themeManager.cardBackgroundColor)
                                    .frame(height: 20)
                                    .overlay(
                                        Text("\(count)")
                                            .font(.caption2)
                                            .foregroundColor(count > 0 ? .white : themeManager.textColor)
                                    )
                            }
                        }
                    }
                }
            }
        }
    }
}

struct WordCloudView: View {
    let words: [(String, Int)]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(words, id: \.0) { word, size in
                Text(word)
                    .font(.system(size: CGFloat(size + 12)))
                    .foregroundColor(themeManager.textColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(themeManager.cardBackgroundColor)
                    .cornerRadius(Theme.cornerRadius)
            }
        }
    }
}

struct TimePatternData: Identifiable {
    let id = UUID()
    let icon: String
    let title: String
    let description: String
    let hour: Int
    let count: Int
}

struct TimePatternChart: View {
    let data: [TimePatternData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            Text("Time Patterns")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Chart(data) { pattern in
                BarMark(
                    x: .value("Hour", pattern.hour),
                    y: .value("Count", pattern.count)
                )
                .foregroundStyle(themeManager.accentColor)
            }
            .frame(height: 200)
            .chartXAxis {
                AxisMarks(values: .stride(by: 4)) { value in
                    AxisGridLine()
                    AxisValueLabel {
                        if let hour = value.as(Int.self) {
                            Text("\(hour)")
                        }
                    }
                }
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}

struct EmotionalPatternView: View {
    let pattern: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            Text("Emotional Pattern")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Text(pattern)
                .foregroundColor(themeManager.textColor)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}

struct GrowthInsightView: View {
    let insight: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.smallPadding) {
            Text("Growth Insight")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Text(insight)
                .foregroundColor(themeManager.textColor)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(Theme.cornerRadius)
    }
}

// Preview
struct InsightComponents_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InsightMoodFlowChartView(data: [
                MoodFlowData(date: Date(), value: 4),
                MoodFlowData(date: Date().addingTimeInterval(86400), value: 3),
                MoodFlowData(date: Date().addingTimeInterval(172800), value: 5)
            ])
            
            MoodDistributionChart(data: [
                MoodDistribution(mood: .calm, count: 5, percentage: 0.5),
                MoodDistribution(mood: .focused, count: 3, percentage: 0.3),
                MoodDistribution(mood: .anxious, count: 1, percentage: 0.1)
            ])
            
            TimePatternChart(data: [
                TimePatternData(icon: "sunrise.fill", title: "Morning", description: "Morning entries", hour: 9, count: 3),
                TimePatternData(icon: "sun.max.fill", title: "Noon", description: "Noon entries", hour: 12, count: 5),
                TimePatternData(icon: "moon.stars.fill", title: "Evening", description: "Evening entries", hour: 18, count: 2)
            ])
        }
        .padding()
        .environmentObject(ThemeManager())
    }
} 