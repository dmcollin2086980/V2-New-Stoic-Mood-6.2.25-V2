import Foundation

/// An enum representing the available filters for journal entries
enum JournalFilter: String, CaseIterable {
    case all = "All"
    case thisWeek = "This Week"
    case thisMonth = "This Month"
    case thisYear = "This Year"
    
    /// The display title for the filter
    var title: String {
        switch self {
        case .all: return "All"
        case .thisWeek: return "This Week"
        case .thisMonth: return "This Month"
        case .thisYear: return "This Year"
        }
    }
}

/// An enum representing the available export formats
enum ExportFormat: String, CaseIterable {
    case pdf = "PDF"
    case csv = "CSV"
    case json = "JSON"
    case markdown = "Markdown"
    
    /// The display title for the export format
    var title: String {
        switch self {
        case .pdf: return "PDF Document"
        case .csv: return "CSV Spreadsheet"
        case .json: return "JSON Data"
        case .markdown: return "Markdown File"
        }
    }
    
    /// The description of the export format
    var description: String {
        switch self {
        case .pdf: return "Export as a formatted PDF document"
        case .csv: return "Export as a spreadsheet-compatible CSV file"
        case .json: return "Export as a structured JSON data file"
        case .markdown: return "Export as a readable markdown file"
        }
    }
    
    /// The file extension for the export format
    var fileExtension: String {
        switch self {
        case .pdf: return "pdf"
        case .csv: return "csv"
        case .json: return "json"
        case .markdown: return "md"
        }
    }
}

/// Represents a time range for filtering data
enum TimeRange: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .week: return "This Week"
        case .month: return "This Month"
        case .year: return "This Year"
        }
    }
}

/// Represents a single data point in the mood flow chart
struct MoodFlowData: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

/// Represents the distribution of moods across entries
struct MoodDistributionData: Identifiable {
    let id = UUID()
    let mood: String
    let count: Int
}

enum InsightType: String, CaseIterable {
    case moodFlow = "Mood Flow"
    case moodDistribution = "Mood Distribution"
    case timePatterns = "Time Patterns"
} 