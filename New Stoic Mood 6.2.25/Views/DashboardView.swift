import SwiftUI
import Charts

struct DashboardView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Stats Row
                HStack(spacing: 15) {
                    StatCard(
                        title: "Current Streak",
                        value: "\(viewModel.currentStreak)",
                        subtitle: "days of reflection",
                        themeManager: themeManager
                    )
                    
                    StatCard(
                        title: "Total Entries",
                        value: "\(viewModel.entries.count)",
                        subtitle: "moments captured",
                        themeManager: themeManager
                    )
                }
                .padding(.horizontal)
                
                // Daily Quote
                QuoteView(themeManager: themeManager)
                    .padding(.horizontal)
                
                // Mood Flow Chart
                DashboardMoodFlowChartView(data: viewModel.moodFlowData)
                    .padding(.horizontal)
                
                // Week Overview
                WeekOverviewView(entries: viewModel.entries, themeManager: themeManager)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationTitle("Dashboard")
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(themeManager.textColor)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(themeManager.secondaryTextColor)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
}

struct QuoteView: View {
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Daily Stoic Wisdom")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Text(StoicQuotesManager.shared.getRandomQuote())
                .font(.system(size: 18, weight: .medium, design: .serif))
                .multilineTextAlignment(.center)
                .foregroundColor(themeManager.textColor)
                .padding()
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
}

struct DashboardMoodFlowChartView: View {
    let data: [MoodFlowData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Flow")
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
            
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
            .chartYScale(domain: 0...10)
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
}

struct WeekOverviewView: View {
    let entries: [JournalEntry]
    let themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This Week's Journey")
                .font(.caption)
                .foregroundColor(themeManager.secondaryTextColor)
            
            HStack(spacing: 10) {
                ForEach(0..<7) { day in
                    let date = Calendar.current.date(byAdding: .day, value: -6 + day, to: Date())!
                    let dayEntries = entries.filter {
                        Calendar.current.isDate($0.date, inSameDayAs: date)
                    }
                    
                    VStack(spacing: 8) {
                        Text(date.formatted(.dateTime.weekday(.abbreviated)))
                            .font(.caption2)
                            .foregroundColor(themeManager.secondaryTextColor)
                        
                        if let firstEntry = dayEntries.first {
                            Text(firstEntry.mood.emoji)
                                .font(.title2)
                        } else {
                            Circle()
                                .fill(themeManager.cardBackgroundColor)
                                .frame(width: 40, height: 40)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding()
        .background(themeManager.cardBackgroundColor)
        .cornerRadius(12)
    }
}

#Preview {
    DashboardView()
        .environmentObject(MoodViewModel())
        .environmentObject(ThemeManager())
} 