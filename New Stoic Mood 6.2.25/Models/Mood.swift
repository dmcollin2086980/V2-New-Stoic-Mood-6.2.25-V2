import Foundation

/// Represents a mood that can be selected by the user
enum Mood: String, CaseIterable, Identifiable, Codable {
    case content
    case grateful
    case focused
    case anxious
    case frustrated
    case sad
    
    /// A unique identifier for the mood
    var id: String { rawValue }
    
    /// The display name of the mood
    var name: String {
        switch self {
        case .content: return "Content"
        case .grateful: return "Grateful"
        case .focused: return "Focused"
        case .anxious: return "Anxious"
        case .frustrated: return "Frustrated"
        case .sad: return "Sad"
        }
    }
    
    /// The emoji representation of the mood
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
    
    /// Converts this Mood to a MoodType
    var toMoodType: MoodType {
        switch self {
        case .content: return .content
        case .grateful: return .grateful
        case .focused: return .focused
        case .anxious: return .anxious
        case .frustrated: return .frustrated
        case .sad: return .sad
        }
    }
} 