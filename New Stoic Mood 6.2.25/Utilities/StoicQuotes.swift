import Foundation

class StoicQuotesManager {
    static let shared = StoicQuotesManager()
    private(set) var quotes: [String] = []
    
    private init() {
        loadQuotes()
    }
    
    private func loadQuotes() {
        guard let url = Bundle.main.url(forResource: "stoic_quotes", withExtension: "json") else {
            print("Error: Could not find stoic_quotes.json")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            quotes = try JSONDecoder().decode([String].self, from: data)
        } catch {
            print("Error loading quotes: \(error)")
        }
    }
    
    func getRandomQuote() -> String {
        quotes.randomElement() ?? "The obstacle is the way."
    }
    
    func getDailyQuote() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: Date())
        return quotes[day % quotes.count]
    }
} 