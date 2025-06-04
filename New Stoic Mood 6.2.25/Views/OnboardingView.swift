import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var currentPage = 0
    @EnvironmentObject private var themeManager: ThemeManager
    
    var body: some View {
        ZStack {
            themeManager.backgroundColor.ignoresSafeArea()
            
            TabView(selection: $currentPage) {
                ForEach(OnboardingPage.pages.indices, id: \.self) { index in
                    OnboardingPageView(themeManager: themeManager, page: OnboardingPage.pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // Page Indicator
            VStack {
                Spacer()
                
                HStack(spacing: 8) {
                    ForEach(OnboardingPage.pages.indices, id: \.self) { index in
                        Circle()
                            .fill(currentPage == index ? themeManager.accentColor : themeManager.secondaryTextColor)
                            .frame(width: 8, height: 8)
                            .scaleEffect(currentPage == index ? 1.2 : 1.0)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 20)
                
                // Navigation Buttons
                HStack {
                    if currentPage > 0 {
                        Button {
                            withAnimation {
                                currentPage -= 1
                            }
                        } label: {
                            Text("Previous")
                                .foregroundColor(themeManager.secondaryTextColor)
                        }
                    }
                    
                    Spacer()
                    
                    if currentPage < OnboardingPage.pages.count - 1 {
                        Button {
                            withAnimation {
                                currentPage += 1
                            }
                        } label: {
                            Text("Next")
                                .foregroundColor(themeManager.accentColor)
                        }
                    } else {
                        Button {
                            hasCompletedOnboarding = true
                        } label: {
                            Text("Get Started")
                                .foregroundColor(themeManager.backgroundColor)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(themeManager.accentColor)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingPage: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
    let quote: String
    let quoteAuthor: String
    
    static let pages = [
        OnboardingPage(
            image: "moon.stars.fill",
            title: "Welcome to Stoic Mood",
            subtitle: "Your personal journey to emotional wisdom begins here",
            quote: "The happiness of your life depends upon the quality of your thoughts.",
            quoteAuthor: "Marcus Aurelius"
        ),
        OnboardingPage(
            image: "heart.text.square.fill",
            title: "Track Your Emotions",
            subtitle: "Record your moods and discover patterns in your emotional landscape",
            quote: "You have power over your mind - not outside events. Realize this, and you will find strength.",
            quoteAuthor: "Marcus Aurelius"
        ),
        OnboardingPage(
            image: "book.fill",
            title: "Daily Reflections",
            subtitle: "Capture your thoughts and insights with guided Stoic prompts",
            quote: "Every new beginning comes from some other beginning's end.",
            quoteAuthor: "Seneca"
        ),
        OnboardingPage(
            image: "chart.line.uptrend.xyaxis",
            title: "Gain Insights",
            subtitle: "Discover patterns and growth opportunities through detailed analytics",
            quote: "Difficulties strengthen the mind, as labor does the body.",
            quoteAuthor: "Seneca"
        )
    ]
}

struct OnboardingPageView: View {
    let themeManager: ThemeManager
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            
            Image(systemName: page.image)
                .font(.system(size: 80))
                .foregroundColor(themeManager.accentColor)
                .symbolEffect(.bounce, options: .repeating)
            
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.title)
                    .foregroundColor(themeManager.textColor)
                    .multilineTextAlignment(.center)
                
                Text(page.subtitle)
                    .font(.body)
                    .foregroundColor(themeManager.secondaryTextColor)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 32)
            
            VStack(spacing: 8) {
                Text(page.quote)
                    .font(.body)
                    .foregroundColor(themeManager.textColor)
                    .italic()
                    .multilineTextAlignment(.center)
                
                Text("— \(page.quoteAuthor)")
                    .font(.caption)
                    .foregroundColor(themeManager.secondaryTextColor)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 24)
            .background(themeManager.cardBackgroundColor)
            .cornerRadius(12)
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

#Preview {
    OnboardingView()
        .environmentObject(ThemeManager())
} 