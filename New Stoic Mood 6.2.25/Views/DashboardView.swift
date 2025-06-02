import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var showingQuote = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Quote Section
                    if showingQuote {
                        QuoteView()
                            .transition(.move(edge: .top))
                    }
                    
                    // Stats Section
                    HStack(spacing: 15) {
                        StatCard(title: "Current Streak", value: "\(viewModel.currentStreak)", subtitle: "days of reflection")
                        StatCard(title: "Total Entries", value: "\(viewModel.totalEntries)", subtitle: "moments captured")
                    }
                    .padding(.horizontal)
                    
                    // Week Overview
                    WeekOverviewView()
                        .padding(.horizontal)
                    
                    // Mood Flow Chart
                    MoodFlowChartView()
                        .frame(height: 200)
                        .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Dashboard")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingQuote.toggle() }) {
                        Image(systemName: showingQuote ? "quote.bubble.fill" : "quote.bubble")
                    }
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            Text(value)
                .font(.system(size: 32, weight: .light))
                .foregroundColor(Theme.dark.primaryTextColor)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
}

struct QuoteView: View {
    let quotes = [
        (text: "The happiness of your life depends upon the quality of your thoughts.", author: "Marcus Aurelius"),
        (text: "It's not what happens to you, but how you react to it that matters.", author: "Epictetus"),
        (text: "Every new beginning comes from some other beginning's end.", author: "Seneca")
    ]
    
    @State private var currentQuote = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("\"\(quotes[currentQuote].text)\"")
                .font(.system(.body, design: .serif))
                .italic()
                .foregroundColor(Theme.dark.primaryTextColor)
            
            Text("— \(quotes[currentQuote].author)")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding()
        .background(Theme.dark.tertiaryBackgroundColor)
        .cornerRadius(12)
        .padding(.horizontal)
        .onAppear {
            currentQuote = Int.random(in: 0..<quotes.count)
        }
    }
}

struct MoodFlowChartView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    
    private struct MoodDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let value: Double
    }
    
    private var moodData: [MoodDataPoint] {
        (0..<7).compactMap { day in
            let date = Calendar.current.date(byAdding: .day, value: -6 + day, to: Date())!
            guard let mood = viewModel.averageMoodForDate(date) else { return nil }
            return MoodDataPoint(date: date, value: mood)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Flow - Last 7 Days")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            Chart(moodData) { point in
                LineMark(
                    x: .value("Day", point.date),
                    y: .value("Mood", point.value)
                )
                .foregroundStyle(Theme.dark.accentColor)
                
                PointMark(
                    x: .value("Day", point.date),
                    y: .value("Mood", point.value)
                )
                .foregroundStyle(Theme.dark.accentColor)
            }
            .chartYScale(domain: 1...5)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisValueLabel(format: .dateTime.weekday(.abbreviated))
                }
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
}

struct WeekOverviewView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week's Journey")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            HStack(spacing: 10) {
                ForEach(0..<7) { day in
                    let date = Calendar.current.date(byAdding: .day, value: -6 + day, to: Date())!
                    let entries = viewModel.entries.filter {
                        Calendar.current.isDate($0.timestamp, inSameDayAs: date)
                    }
                    
                    VStack(spacing: 8) {
                        Text(date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2)
                            .foregroundColor(Theme.dark.tertiaryTextColor)
                        
                        if let firstEntry = entries.first {
                            Text(firstEntry.mood.emoji)
                                .font(.title2)
                        } else {
                            Circle()
                                .fill(Theme.dark.tertiaryBackgroundColor)
                                .frame(width: 40, height: 40)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
}

struct RecentEntriesView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Recent Reflections")
                .font(.caption)
                .foregroundColor(Theme.dark.secondaryTextColor)
            
            if viewModel.entries.isEmpty {
                VStack(spacing: 10) {
                    Text("No entries yet")
                        .foregroundColor(Theme.dark.primaryTextColor)
                    Text("Start your journey with today's reflection")
                        .font(.caption)
                        .foregroundColor(Theme.dark.secondaryTextColor)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ForEach(viewModel.entries.prefix(3)) { entry in
                    EntryRow(entry: entry)
                }
            }
        }
        .padding()
        .background(Theme.dark.secondaryBackgroundColor)
        .cornerRadius(12)
    }
}

struct EntryRow: View {
    let entry: MoodEntry
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Text(entry.mood.emoji)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(entry.timestamp.formatted(.relative(presentation: .named)))
                    .font(.caption)
                    .foregroundColor(Theme.dark.tertiaryTextColor)
                
                Text(entry.content)
                    .font(.subheadline)
                    .foregroundColor(Theme.dark.secondaryTextColor)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 5)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(MoodViewModel())
    }
} 