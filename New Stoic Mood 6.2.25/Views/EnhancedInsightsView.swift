import SwiftUI
import Charts

// MARK: - Chart Components
struct MoodBarMark: ChartContent {
    let data: MoodDistributionData
    
    var body: some ChartContent {
        BarMark(
            x: .value("Mood", data.mood),
            y: .value("Count", data.count)
        )
        .foregroundStyle(by: .value("Mood", data.mood))
    }
}

// MARK: - Time Range Picker
struct TimeRangePickerView: View {
    @Binding var selectedTimeRange: TimeRange
    
    var body: some View {
        Picker("Time Range", selection: $selectedTimeRange) {
            ForEach(TimeRange.allCases) { range in
                Text(range.displayName).tag(range)
            }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

// MARK: - Export Menu
struct ExportMenuView: View {
    let onExport: (ExportFormat) -> Void
    
    var body: some View {
        Menu {
            Button(action: { onExport(.pdf) }) {
                Label("PDF Document", systemImage: "doc.fill")
            }
            Button(action: { onExport(.csv) }) {
                Label("CSV Spreadsheet", systemImage: "tablecells")
            }
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
}

// MARK: - Time Pattern Components
struct TimePatternIcon: View {
    let icon: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        Image(systemName: icon)
            .font(.title2)
            .foregroundColor(themeManager.accentColor)
            .frame(width: 40)
    }
}

struct TimePatternContent: View {
    let title: String
    let description: String
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(themeManager.textColor)
            Text(description)
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
        }
    }
}

struct InsightTimePatternCard: View {
    let title: String
    let description: String
    let icon: String
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(themeManager.accentColor)
                .frame(width: 40, height: 40)
                .background(themeManager.accentColor.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(15)
    }
}

// MARK: - Section Views
struct TimePatternsSectionView: View {
    let patterns: [TimePatternData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Time Patterns")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            ForEach(patterns) { pattern in
                EnhancedTimePatternCard(pattern: pattern)
            }
        }
        .cardStyle()
    }
}

struct EnhancedTimePatternCard: View {
    let pattern: TimePatternData
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: pattern.icon)
                .font(.title2)
                .foregroundColor(themeManager.accentColor)
                .frame(width: 40, height: 40)
                .background(themeManager.accentColor.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pattern.title)
                    .font(.headline)
                    .foregroundColor(themeManager.textColor)
                
                Text(pattern.description)
                    .font(.subheadline)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            
            Spacer()
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(15)
    }
}

struct MoodDistributionSectionView: View {
    let data: [MoodDistributionData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mood Distribution")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Chart {
                ForEach(data) { data in
                    MoodBarMark(data: data)
                }
            }
            .frame(height: 200)
        }
        .cardStyle()
    }
}

struct GrowthInsightsSectionView: View {
    let insights: [GrowthInsight]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Growth Insights")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            ForEach(insights) { insight in
                GrowthInsightCard(insight: insight)
            }
        }
        .cardStyle()
    }
}

// MARK: - Main View
struct EnhancedInsightsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var selectedTimeRange: TimeRange = .week
    @State private var showingTimeRangePicker = false
    @State private var selectedInsight: InsightType = .moodFlow
    @State private var showingInsightPicker = false
    
    // Sample data - replace with real data from your data model
    private let moodFlowData: [MoodFlowData] = [
        MoodFlowData(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, value: 7),
        MoodFlowData(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, value: 6),
        MoodFlowData(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, value: 8),
        MoodFlowData(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, value: 5),
        MoodFlowData(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, value: 7),
        MoodFlowData(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, value: 8),
        MoodFlowData(date: Date(), value: 7)
    ]
    
    private let moodDistributionData: [MoodDistributionData] = [
        MoodDistributionData(mood: "Happy", count: 12),
        MoodDistributionData(mood: "Calm", count: 8),
        MoodDistributionData(mood: "Anxious", count: 5),
        MoodDistributionData(mood: "Sad", count: 3)
    ]
    
    private let timePatterns: [TimePatternData] = [
        TimePatternData(
            icon: "sunrise.fill",
            title: "Morning Reflection",
            description: "You tend to journal more in the morning hours",
            hour: 9,
            count: 5
        ),
        TimePatternData(
            icon: "calendar",
            title: "Weekend Focus",
            description: "More detailed entries on weekends",
            hour: 12,
            count: 3
        ),
        TimePatternData(
            icon: "moon.stars.fill",
            title: "Evening Review",
            description: "Regular evening reflection sessions",
            hour: 21,
            count: 4
        )
    ]
    
    private let growthInsights: [GrowthInsight] = [
        GrowthInsight(
            title: "Consistency Improvement",
            description: "Your journaling consistency has improved by 25% this month",
            progress: 0.25
        ),
        GrowthInsight(
            title: "Emotional Awareness",
            description: "You're showing better emotional awareness in your entries",
            progress: 0.15
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    TimeRangePickerView(selectedTimeRange: $selectedTimeRange)
                    
                    switch selectedInsight {
                    case .moodFlow:
                        MoodFlowView(data: moodFlowData)
                    case .moodDistribution:
                        MoodDistributionSectionView(data: moodDistributionData)
                    case .timePatterns:
                        TimePatternsSectionView(patterns: timePatterns)
                    }
                    
                    GrowthInsightsSectionView(insights: growthInsights)
                }
                .padding()
            }
            .navigationTitle("Insights")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingInsightPicker = true
                    } label: {
                        Image(systemName: "chart.bar")
                    }
                }
            }
            .sheet(isPresented: $showingInsightPicker) {
                InsightTypePickerView(selectedInsight: $selectedInsight)
            }
        }
    }
}

// MARK: - Supporting Views
struct ExportButton: View {
    @EnvironmentObject private var themeManager: ThemeManager
    @Binding var showingMenu: Bool
    
    var body: some View {
        Button {
            showingMenu = true
        } label: {
            Image(systemName: "square.and.arrow.up")
                .foregroundColor(themeManager.accentColor)
        }
    }
}

#Preview {
    NavigationView {
        EnhancedInsightsView()
            .environmentObject(ThemeManager())
    }
} 
