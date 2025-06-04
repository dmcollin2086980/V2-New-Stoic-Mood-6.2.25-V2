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
    case happy
    case grateful
    case focused
    case anxious
    case frustrated
    case sad
    case calm
    case energetic
    case proud
    case reflective
    case stressed
    
    var emoji: String {
        switch self {
        case .happy: return "😀"
        case .grateful: return "🙏"
        case .focused: return "🎯"
        case .anxious: return "😰"
        case .frustrated: return "😤"
        case .sad: return "😞"
        case .calm: return "🧘"
        case .energetic: return "⚡"
        case .proud: return "🎉"
        case .reflective: return "🥲"
        case .stressed: return "😵‍💫"
        }
    }
    
    var value: Int {
        switch self {
        case .happy: return 5
        case .grateful: return 5
        case .focused: return 4
        case .anxious: return 2
        case .frustrated: return 2
        case .sad: return 1
        case .calm: return 4
        case .energetic: return 4
        case .proud: return 5
        case .reflective: return 3
        case .stressed: return 2
        }
    }
    
    var displayName: String {
        rawValue.capitalized
    }
    
    /// Converts this MoodType to a Mood
    var toMood: Mood {
        switch self {
        case .happy: return .happy
        case .grateful: return .grateful
        case .focused: return .focused
        case .anxious: return .anxious
        case .frustrated: return .frustrated
        case .sad: return .sad
        case .calm: return .calm
        case .energetic: return .energetic
        case .proud: return .proud
        case .reflective: return .reflective
        case .stressed: return .stressed
        }
    }
} 