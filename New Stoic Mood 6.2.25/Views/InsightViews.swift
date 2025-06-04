import SwiftUI
import Charts

struct MoodFlowView: View {
    let data: [MoodFlowData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mood Flow")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Chart {
                ForEach(data) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Mood", dataPoint.value)
                    )
                    .foregroundStyle(themeManager.accentColor)
                    
                    PointMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Mood", dataPoint.value)
                    )
                    .foregroundStyle(themeManager.accentColor)
                }
            }
            .frame(height: 200)
        }
        .cardStyle()
    }
}

struct MoodDistributionView: View {
    let data: [MoodDistributionData]
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mood Distribution")
                .font(.headline)
                .foregroundColor(themeManager.textColor)
            
            Chart {
                ForEach(data) { dataPoint in
                    BarMark(
                        x: .value("Mood", dataPoint.mood),
                        y: .value("Count", dataPoint.count)
                    )
                    .foregroundStyle(by: .value("Mood", dataPoint.mood))
                }
            }
            .frame(height: 200)
        }
        .cardStyle()
    }
}

struct InsightTypePickerView: View {
    @Binding var selectedInsight: InsightType
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        NavigationView {
            List(InsightType.allCases, id: \.self) { insight in
                Button {
                    selectedInsight = insight
                    dismiss()
                } label: {
                    HStack {
                        Text(insight.rawValue)
                            .foregroundColor(themeManager.textColor)
                        Spacer()
                        if insight == selectedInsight {
                            Image(systemName: "checkmark")
                                .foregroundColor(themeManager.accentColor)
                        }
                    }
                }
            }
            .navigationTitle("Select Insight Type")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 