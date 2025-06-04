import Foundation
import SwiftUI

struct Quote: Identifiable, Codable {
    var id: UUID
    let text: String
    let author: String
    
    init(id: UUID = UUID(), text: String, author: String) {
        self.id = id
        self.text = text
        self.author = author
    }
}

class QuoteViewModel: ObservableObject {
    @Published var quotes: [Quote] = []
    @Published var dailyQuote: Quote
    @Published var savedQuotes: [Quote] = []
    @Published var isShareSheetPresented = false
    @Published var shareText: String = ""
    
    private let userDefaults = UserDefaults.standard
    private let dailyQuoteKey = "lastDailyQuoteDate"
    private let savedQuotesKey = "savedQuotes"
    
    init() {
        // Initialize with a default quote
        let defaultQuote = Quote(text: "The happiness of your life depends upon the quality of your thoughts.", author: "Marcus Aurelius")
        self.dailyQuote = defaultQuote
        
        // Load saved quotes
        if let savedData = userDefaults.data(forKey: savedQuotesKey),
           let decodedQuotes = try? JSONDecoder().decode([Quote].self, from: savedData) {
            self.savedQuotes = decodedQuotes
        }
        
        // Load quotes
        self.quotes = [
            Quote(text: "The happiness of your life depends upon the quality of your thoughts.", author: "Marcus Aurelius"),
            Quote(text: "Waste no more time arguing what a good man should be. Be one.", author: "Marcus Aurelius"),
            Quote(text: "You have power over your mind - not outside events. Realize this, and you will find strength.", author: "Marcus Aurelius"),
            Quote(text: "The best revenge is to be unlike him who performed the injury.", author: "Marcus Aurelius"),
            Quote(text: "If it is not right, do not do it, if it is not true, do not say it.", author: "Marcus Aurelius"),
            Quote(text: "He who fears death will never do anything worthy of a living man.", author: "Seneca"),
            Quote(text: "We suffer more often in imagination than in reality.", author: "Seneca"),
            Quote(text: "It is not that we have a short time to live, but that we waste a lot of it.", author: "Seneca"),
            Quote(text: "Luck is what happens when preparation meets opportunity.", author: "Seneca"),
            Quote(text: "The whole future lies in uncertainty: live immediately.", author: "Seneca")
        ]
        
        // Set up daily quote
        if let lastDate = userDefaults.string(forKey: dailyQuoteKey),
           let lastDateObj = ISO8601DateFormatter().date(from: lastDate),
           Calendar.current.isDateInToday(lastDateObj) {
            // Use existing daily quote
            self.dailyQuote = self.quotes[0] // Default to first quote if no daily quote set
        } else {
            // Set new daily quote
            self.dailyQuote = self.quotes.randomElement() ?? self.quotes[0]
            userDefaults.set(ISO8601DateFormatter().string(from: Date()), forKey: dailyQuoteKey)
        }
    }
    
    func refreshQuotes() {
        // In a real app, this would fetch new quotes from an API
        loadQuotes()
    }
    
    private func loadQuotes() {
        quotes = [
            Quote(text: "The happiness of your life depends upon the quality of your thoughts.", author: "Marcus Aurelius"),
            Quote(text: "Waste no more time arguing what a good man should be. Be one.", author: "Marcus Aurelius"),
            Quote(text: "You have power over your mind - not outside events. Realize this, and you will find strength.", author: "Marcus Aurelius"),
            Quote(text: "The best revenge is to be unlike him who performed the injury.", author: "Marcus Aurelius"),
            Quote(text: "If it is not right, do not do it, if it is not true, do not say it.", author: "Marcus Aurelius"),
            Quote(text: "He who fears death will never do anything worthy of a living man.", author: "Seneca"),
            Quote(text: "We suffer more often in imagination than in reality.", author: "Seneca"),
            Quote(text: "It is not that we have a short time to live, but that we waste a lot of it.", author: "Seneca"),
            Quote(text: "Luck is what happens when preparation meets opportunity.", author: "Seneca"),
            Quote(text: "The whole future lies in uncertainty: live immediately.", author: "Seneca")
        ]
    }
    
    func refreshDailyQuote() {
        dailyQuote = quotes.randomElement() ?? quotes[0]
        userDefaults.set(ISO8601DateFormatter().string(from: Date()), forKey: dailyQuoteKey)
    }
    
    func saveQuote(_ quote: Quote) {
        if !savedQuotes.contains(where: { $0.id == quote.id }) {
            savedQuotes.append(quote)
            saveQuotesToStorage()
        }
    }
    
    func removeSavedQuote(_ quote: Quote) {
        savedQuotes.removeAll { $0.id == quote.id }
        saveQuotesToStorage()
    }
    
    private func saveQuotesToStorage() {
        if let encoded = try? JSONEncoder().encode(savedQuotes) {
            userDefaults.set(encoded, forKey: savedQuotesKey)
        }
    }
    
    func shareQuote(_ quote: Quote) {
        shareText = "\"\(quote.text)\" — \(quote.author)"
        isShareSheetPresented = true
    }
    
    func copyQuote(_ quote: Quote) {
        let text = "\"\(quote.text)\" — \(quote.author)"
        #if os(iOS)
        UIPasteboard.general.string = text
        #elseif os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif
    }
} 