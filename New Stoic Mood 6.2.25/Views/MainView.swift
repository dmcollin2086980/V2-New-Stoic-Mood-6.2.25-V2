import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewModel: MoodViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showingMoodSelection = false
    @State private var showingJournal = false
    @State private var selectedMood: Mood?
    @State private var selectedIntensity: Int = 5
    
    var body: some View {
        NavigationStack {
            VStack(spacing: ThemeManager.padding) {
                StoicQuoteView()
                    .padding(.top)
                
                Spacer()
                
                Button(action: {
                    showingMoodSelection = true
                }) {
                    Text("How are you feeling?")
                        .font(.title2)
                        .foregroundColor(themeManager.textColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(themeManager.backgroundColor)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(themeManager.accentColor, lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                Button(action: {
                    showingJournal = true
                }) {
                    Text("View Journal")
                        .font(.title2)
                        .foregroundColor(themeManager.textColor)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(themeManager.backgroundColor)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(themeManager.accentColor, lineWidth: 1)
                        )
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .background(themeManager.backgroundColor)
            .navigationTitle("Stoic Mood")
            .navigationBarItems(trailing: NavigationLink(destination: SettingsView()) {
                Image(systemName: "gear")
                    .foregroundColor(themeManager.textColor)
            })
            .sheet(isPresented: $showingMoodSelection) {
                EnhancedMoodSelectionView { _, intensity in
                    selectedIntensity = Int(intensity)
                    showingJournal = true
                }
            }
            .sheet(isPresented: $showingJournal) {
                JournalView()
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(MoodViewModel())
        .environmentObject(ThemeManager())
} 
