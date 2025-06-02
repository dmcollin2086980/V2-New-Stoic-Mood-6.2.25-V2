import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MoodViewModel()
    @State private var selectedTab = 0
    @State private var showingMoodSelection = false
    @State private var showingJournalEntry = false
    @State private var selectedMood: MoodType?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar")
                }
                .tag(0)
            
            JournalView()
                .tabItem {
                    Label("Journal", systemImage: "book")
                }
                .tag(1)
            
            InsightsView()
                .tabItem {
                    Label("Insights", systemImage: "lightbulb")
                }
                .tag(2)
        }
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        showingMoodSelection = true
                    }) {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Theme.dark.accentColor)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        )
        .sheet(isPresented: $showingMoodSelection) {
            MoodSelectionView(
                selectedMood: $selectedMood,
                showingMoodSelection: $showingMoodSelection,
                showingJournalEntry: $showingJournalEntry
            )
        }
        .sheet(isPresented: $showingJournalEntry) {
            if let mood = selectedMood {
                JournalEntryView(selectedMood: mood)
            }
        }
        .environmentObject(viewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
} 