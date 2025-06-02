import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var selectedTimeRange: TimeRange = .week
    
    private var moodDistribution: [(mood: String, count: Int)] {
        let moodCounts = Dictionary(grouping: viewModel.entries, by: { $0.mood.rawValue })
            .mapValues { $0.count }
        
        return moodCounts.map { mood, count in
            (mood: mood, count: count)
        }.sorted { $0.count > $1.count }
    }
    
    private var timePatternData: [[Int]] {
        // Initialize 8x7 grid (8 time blocks, 7 days) with zeros
        var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 7), count: 8)
        
        // Fill in the grid based on entries
        for entry in viewModel.entries {
            let calendar = Calendar.current
            
            // Safely extract date components
            let dateComponents = calendar.dateComponents([.hour, .weekday], from: entry.timestamp)
            
            guard let hour = dateComponents.hour,
                  let weekday = dateComponents.weekday else {
                continue
            }
            
            // Ensure weekday is in valid range (1-7) before converting to 0-6
            guard weekday >= 1 && weekday <= 7 else { continue }
            let weekdayIndex = weekday - 1
            
            // Map hour to 0-7 range (3-hour blocks)
            // Ensure hour is valid (0-23) and calculate block index
            guard hour >= 0 && hour <= 23 else { continue }
            let hourIndex = min(hour / 3, 7)
            
            // Double-check bounds before incrementing
            guard hourIndex >= 0 && hourIndex < grid.count,
                  weekdayIndex >= 0 && weekdayIndex < grid[hourIndex].count else {
                continue
            }
            
            grid[hourIndex][weekdayIndex] += 1
        }
        
        return grid
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Range Picker
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases) { range in
                            Text(range.displayName)
                                .tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Mood Flow Chart
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Mood Flow")
                            .font(.headline)
                            .foregroundColor(Theme.current.primaryTextColor)
                        
                        MoodFlowChartView()
                            .frame(height: 200)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Theme.current.secondaryBackgroundColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Mood Distribution
                    InsightCard(title: "Mood Distribution") {
                        MoodDistributionChart(data: moodDistribution)
                    }
                    .padding(.horizontal)
                    
                    // Time of Day Patterns
                    InsightCard(title: "Time of Day Patterns") {
                        TimeOfDayHeatmap(data: timePatternData)
                    }
                    .padding(.horizontal)
                    
                    // Word Cloud
                    InsightCard(title: "Common Themes") {
                        WordCloudView(words: viewModel.journalAnalysis?.topWords ?? [])
                    }
                    .padding(.horizontal)
                    
                    // Emotional Patterns
                    InsightCard(title: "Emotional Patterns") {
                        EmotionalPatternsView()
                    }
                    .padding(.horizontal)
                    
                    // Growth Insights
                    InsightCard(title: "Growth Insights") {
                        GrowthInsightsView()
                    }
                    .padding(.horizontal)
                    
                    // Reflection Quality
                    InsightCard(title: "Reflection Quality") {
                        ReflectionQualityView()
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Insights")
        }
    }
}

#Preview {
    InsightsView()
        .environmentObject(MoodViewModel())
}