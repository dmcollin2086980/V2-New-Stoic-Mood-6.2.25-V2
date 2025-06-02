import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var showingExportOptions = false
    @State private var exportFormat: ExportFormat = .csv
    @State private var showingShareSheet = false
    @State private var exportData: String = ""
    
    enum ExportFormat {
        case csv, pdf
        
        var displayName: String {
            switch self {
            case .csv: return "CSV"
            case .pdf: return "PDF"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Statistics")) {
                    StatRow(title: "Current Streak", value: "\(viewModel.currentStreak) days")
                    StatRow(title: "Total Entries", value: "\(viewModel.totalEntries)")
                }
                
                Section(header: Text("Export Data")) {
                    Button(action: { showingExportOptions = true }) {
                        Label("Export Journal", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .navigationTitle("Insights")
            .actionSheet(isPresented: $showingExportOptions) {
                ActionSheet(
                    title: Text("Export Format"),
                    message: Text("Choose a format to export your journal"),
                    buttons: [
                        .default(Text("PDF")) { exportFormat = .pdf; prepareExport() },
                        .default(Text("CSV")) { exportFormat = .csv; prepareExport() },
                        .cancel()
                    ]
                )
            }
            .sheet(isPresented: $showingShareSheet) {
                if let data = exportData.data(using: .utf8) {
                    ShareSheet(items: [data])
                }
            }
        }
    }
    
    private func prepareExport() {
        switch exportFormat {
        case .csv:
            exportData = viewModel.exportAsCSV()
        case .pdf:
            exportData = viewModel.exportAsPDF()
        }
        showingShareSheet = true
    }
}

struct StatRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

struct TimePatternsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    
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
    @EnvironmentObject var viewModel: MoodViewModel
    
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
    @EnvironmentObject var viewModel: MoodViewModel
    
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
    @EnvironmentObject var viewModel: MoodViewModel
    
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
    @EnvironmentObject var viewModel: MoodViewModel
    
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
    @EnvironmentObject var viewModel: MoodViewModel
    
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
        InsightsView()
            .environmentObject(MoodViewModel())
    }
} 