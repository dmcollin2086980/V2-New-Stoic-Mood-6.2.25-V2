import SwiftUI

class EnhancedInsightsViewModel: ObservableObject {
    @Published var moodFlowData: [MoodFlowData] = []
    @Published var moodDistributionData: [MoodDistributionData] = []
    @Published var timePatterns: [TimePatternData] = []
    @Published var growthInsights: [GrowthInsight] = []
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        // Sample mood flow data
        moodFlowData = [
            MoodFlowData(date: Date().addingTimeInterval(-6*86400), value: 4),
            MoodFlowData(date: Date().addingTimeInterval(-5*86400), value: 3),
            MoodFlowData(date: Date().addingTimeInterval(-4*86400), value: 5),
            MoodFlowData(date: Date().addingTimeInterval(-3*86400), value: 4),
            MoodFlowData(date: Date().addingTimeInterval(-2*86400), value: 3),
            MoodFlowData(date: Date().addingTimeInterval(-1*86400), value: 4),
            MoodFlowData(date: Date(), value: 5)
        ]
        
        // Sample mood distribution data
        moodDistributionData = [
            MoodDistributionData(mood: "Happy", count: 12),
            MoodDistributionData(mood: "Calm", count: 8),
            MoodDistributionData(mood: "Anxious", count: 5),
            MoodDistributionData(mood: "Sad", count: 3)
        ]
        
        // Sample time patterns
        timePatterns = [
            TimePatternData(
                icon: "sunrise.fill",
                title: "Morning Reflection",
                description: "You tend to reflect most in the morning hours",
                hour: 9,
                count: 5
            ),
            TimePatternData(
                icon: "moon.stars.fill",
                title: "Evening Insights",
                description: "Your evening entries show deeper reflection",
                hour: 21,
                count: 4
            ),
            TimePatternData(
                icon: "sun.max.fill",
                title: "Midday Check-ins",
                description: "Regular midday check-ins help maintain awareness",
                hour: 12,
                count: 3
            )
        ]
        
        // Sample growth insights
        growthInsights = [
            GrowthInsight(
                title: "Consistent Practice",
                description: "You've maintained a 7-day journaling streak!",
                progress: 0.7
            ),
            GrowthInsight(
                title: "Emotional Awareness",
                description: "Your ability to identify emotions has improved",
                progress: 0.5
            ),
            GrowthInsight(
                title: "Reflection Depth",
                description: "Your journal entries show increasing depth",
                progress: 0.8
            )
        ]
    }
    
    func exportInsights(format: ExportFormat) {
        // Implementation for exporting insights
    }
} 