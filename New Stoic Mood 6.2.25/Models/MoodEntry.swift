import Foundation

struct MoodEntry: Identifiable, Codable {
    let id: Date
    let mood: MoodType
    let content: String
    let timestamp: Date
    let wordCount: Int
    var isQuickEntry: Bool
    
    init(id: Date = Date(), mood: MoodType, content: String, timestamp: Date = Date(), wordCount: Int? = nil, isQuickEntry: Bool = false) {
        self.id = id
        self.mood = mood
        self.content = content
        self.timestamp = timestamp
        self.wordCount = wordCount ?? content.split(separator: " ").count
        self.isQuickEntry = isQuickEntry
    }
}

enum MoodType: String, Codable, CaseIterable {
    case content
    case grateful
    case focused
    case anxious
    case frustrated
    case sad
    
    var emoji: String {
        switch self {
        case .content: return "😌"
        case .grateful: return "🙏"
        case .focused: return "🎯"
        case .anxious: return "😟"
        case .frustrated: return "😤"
        case .sad: return "😔"
        }
    }
    
    var value: Int {
        switch self {
        case .content: return 4
        case .grateful: return 5
        case .focused: return 4
        case .anxious: return 2
        case .frustrated: return 2
        case .sad: return 1
        }
    }
    
    var displayName: String {
        rawValue.capitalized
    }
} 