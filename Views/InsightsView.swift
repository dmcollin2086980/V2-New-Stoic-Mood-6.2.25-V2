import SwiftUI
import Charts

struct InsightsView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @State private var selectedTimeRange: TimeRange = .week
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Time Range Picker
                    Picker("Time Range", selection: $selectedTimeRange) {
                        ForEach(TimeRange.allCases) { range in
                            Text(range.rawValue).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Mood Flow Chart
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mood Flow")
                            .font(.headline)
                        
                        Chart {
                            ForEach(viewModel.moodFlowData) { data in
                                LineMark(
                                    x: .value("Date", data.date),
                                    y: .value("Mood", data.value)
                                )
                                .foregroundStyle(Theme.current.accentColor.gradient)
                                
                                PointMark(
                                    x: .value("Date", data.date),
                                    y: .value("Mood", data.value)
                                )
                                .foregroundStyle(Theme.current.accentColor)
                            }
                        }
                        .frame(height: 200)
                        .chartYScale(domain: 1...5)
                    }
                    .padding()
                    .background(Theme.current.secondaryBackgroundColor)
                    .cornerRadius(15)
                    .shadow(radius: 2)
                    
                    // Mood Distribution
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Mood Distribution")
                            .font(.headline)
                        
                        Chart {
                            ForEach(viewModel.moodDistributionData) { data in
                                BarMark(
                                    x: .value("Mood", data.mood),
                                    y: .value("Count", data.count)
                                )
                                .foregroundStyle(Theme.current.accentColor.gradient)
                            }
                        }
                        .frame(height: 200)
                    }
                    .padding()
                    .background(Theme.current.secondaryBackgroundColor)
                    .cornerRadius(15)
                    .shadow(radius: 2)
                    
                    // Word Cloud
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Common Themes")
                            .font(.headline)
                        
                        WordCloudView(words: viewModel.wordCloudData)
                    }
                    .padding()
                    .background(Theme.current.secondaryBackgroundColor)
                    .cornerRadius(15)
                    .shadow(radius: 2)
                }
                .padding(.vertical)
            }
            .navigationTitle("Insights")
        }
    }
}

struct WordCloudView: View {
    let words: [(String, Int)]
    
    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(words, id: \.0) { word, count in
                Text(word)
                    .font(.system(size: CGFloat(count + 12)))
                    .foregroundColor(Theme.current.accentColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Theme.current.tertiaryBackgroundColor)
                    .cornerRadius(8)
            }
        }
    }
}

struct FlowLayout: Layout {
    var spacing: CGFloat
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        return layout(sizes: sizes, proposal: proposal).size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        let positions = layout(sizes: sizes, proposal: proposal).positions
        
        for (index, subview) in subviews.enumerated() {
            subview.place(at: positions[index], proposal: .unspecified)
        }
    }
    
    private func layout(sizes: [CGSize], proposal: ProposedViewSize) -> (positions: [CGPoint], size: CGSize) {
        guard let width = proposal.width else { return ([], .zero) }
        
        var positions: [CGPoint] = []
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var maxY: CGFloat = 0
        var rowHeight: CGFloat = 0
        
        for size in sizes {
            if currentX + size.width > width {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            
            positions.append(CGPoint(x: currentX, y: currentY))
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
            maxY = max(maxY, currentY + size.height)
        }
        
        return (positions, CGSize(width: width, height: maxY))
    }
}

#Preview {
    InsightsView()
        .environmentObject(MoodViewModel())
} 