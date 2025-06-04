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

struct TimePatternsSectionView: View {
    let patterns: [TimePatternData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Time Patterns")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            ForEach(patterns) { pattern in
                TimePatternCard(pattern: pattern)
            }
        }
        .cardStyle()
    }
}

struct TimePatternCard: View {
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