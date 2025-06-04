import Foundation

/// Represents a mood that can be selected by the user
enum Mood: String, CaseIterable, Identifiable, Codable {
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
    
    /// A unique identifier for the mood
    var id: String { rawValue }
    
    /// The display name of the mood
    var name: String {
        switch self {
        case .happy: return "Happy"
        case .grateful: return "Grateful"
        case .focused: return "Focused"
        case .anxious: return "Anxious"
        case .frustrated: return "Frustrated"
        case .sad: return "Sad"
        case .calm: return "Calm"
        case .energetic: return "Energetic"
        case .proud: return "Proud"
        case .reflective: return "Reflective"
        case .stressed: return "Stressed"
        }
    }
    
    /// The emoji representation of the mood
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
    
    /// Converts this Mood to a MoodType
    var toMoodType: MoodType {
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