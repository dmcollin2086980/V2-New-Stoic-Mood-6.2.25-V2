import SwiftUI
import Charts

struct InsightsView: View {
    @StateObject private var viewModel = MoodViewModel()
    @EnvironmentObject private var themeManager: ThemeManager
    @State private var selectedSection: InsightSection = .patterns
    
    enum InsightSection: String, CaseIterable {
        case patterns = "Patterns"
        case analysis = "Analysis"
        case growth = "Growth"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Section Picker
                Picker("Section", selection: $selectedSection) {
                    ForEach(InsightSection.allCases, id: \.self) { section in
                        Text(section.rawValue).tag(section)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Content
                ScrollView {
                    VStack(spacing: ThemeManager.padding) {
                        switch selectedSection {
                        case .patterns:
                            patternsSection
                        case .analysis:
                            analysisSection
                        case .growth:
                            growthSection
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Insights")
            .themeBackground()
        }
    }
    
    // MARK: - Section Views
    
    private var patternsSection: some View {
        VStack(spacing: ThemeManager.padding) {
            // Mood Transitions
            if let transitions = viewModel.moodTransitions, !transitions.isEmpty {
                InsightCard(title: "Mood Patterns") {
                    VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                        ForEach(transitions.prefix(3), id: \.id) { transition in
                            HStack {
                                Text("\(transition.from.emoji) → \(transition.to.emoji)")
                                    .font(.title2)
                                
                                Spacer()
                                
                                Text("\(transition.count) times")
                                    .foregroundColor(themeManager.secondaryTextColor)
                            }
                        }
                    }
                }
            }
            
            // Time Patterns
            if !viewModel.timePatterns.isEmpty {
                InsightCard(title: "Journaling Habits") {
                    VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                        ForEach(viewModel.timePatterns, id: \.title) { pattern in
                            HStack {
                                Image(systemName: pattern.icon)
                                    .foregroundColor(themeManager.accentColor)
                                
                                VStack(alignment: .leading) {
                                    Text(pattern.title)
                                        .font(.headline)
                                    
                                    Text(pattern.description)
                                        .font(.subheadline)
                                        .foregroundColor(themeManager.secondaryTextColor)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var analysisSection: some View {
        VStack(spacing: ThemeManager.padding) {
            // Text Analysis
            if let analysis = viewModel.textAnalysis {
                InsightCard(title: "Writing Analysis") {
                    VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                        Text("Average Length: \(analysis.averageLength) words")
                            .themeText()
                        
                        Text("Writing Style: \(analysis.writingStyle)")
                            .themeText()
                        
                        Text("Sentiment: \(formatSentiment(analysis.sentiment))")
                            .themeText()
                        
                        if !analysis.themes.isEmpty {
                            Text("Common Themes:")
                                .themeText()
                                .padding(.top, 4)
                            
                            FlowLayout(spacing: 8) {
                                ForEach(analysis.themes, id: \.self) { theme in
                                    Text(theme)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(themeManager.accentColor.opacity(0.2))
                                        .foregroundColor(themeManager.accentColor)
                                        .cornerRadius(ThemeManager.cornerRadius)
                                }
                            }
                        }
                    }
                }
            }
            
            // Reflection Quality
            if let quality = viewModel.reflectionQuality {
                InsightCard(title: "Reflection Quality") {
                    VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                        HStack {
                            Text("Average Length")
                            Spacer()
                            Text("\(quality.length) words")
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        
                        HStack {
                            Text("Consistency")
                            Spacer()
                            Text("\(quality.consistency)%")
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                        
                        Text(quality.feedback ?? "Keep up the good work with your reflections!")
                            .themeText()
                            .padding(.top, 4)
                    }
                }
            }
        }
    }
    
    private var growthSection: some View {
        VStack(spacing: ThemeManager.padding) {
            // Growth Insights
            if let insights = viewModel.growthInsights, !insights.isEmpty {
                InsightCard(title: "Growth Opportunities") {
                    VStack(alignment: .leading, spacing: ThemeManager.smallPadding) {
                        ForEach(insights, id: \.self) { insight in
                            HStack(alignment: .top) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(themeManager.accentColor)
                                
                                Text(insight)
                                    .themeText()
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func formatSentiment(_ value: Double) -> String {
        switch value {
        case ..<(-0.3):
            return "Negative"
        case (-0.3)..<0.3:
            return "Neutral"
        default:
            return "Positive"
        }
    }
}

#Preview {
    InsightsView()
        .environmentObject(ThemeManager())
}
