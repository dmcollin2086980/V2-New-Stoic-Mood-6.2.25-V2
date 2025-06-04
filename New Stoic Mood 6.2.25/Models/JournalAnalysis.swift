import Foundation

struct JournalAnalysis {
    let topWords: [String]
    let averageLength: Int
    let writingStyle: String
    let emotionalTone: String
    let commonThemes: [String]
    let wordCount: Int
    
    static func analyze(entries: [MoodEntry]) -> JournalAnalysis {
        let allText = entries.map { $0.content }.joined(separator: " ")
        let words = allText.split { !$0.isLetter }.map { String($0).lowercased() }
        let wordCounts = words.reduce(into: [:]) { counts, word in counts[word, default: 0] += 1 }
        
        // Filter out common stop words
        let stopWords: Set<String> = ["a", "an", "the", "in", "on", "at", "to", "for", "of", "i", "you", "he", "she", "it", "we", "they", "is", "am", "are", "was", "were", "be", "been", "being", "have", "has", "had", "do", "does", "did", "and", "but", "or", "so", "if", "not", "my", "your", "his", "her", "its", "our", "their", "what", "which", "who", "when", "where", "why", "how", "with", "this", "that", "these", "those"]
        
        let filteredWordCounts = wordCounts.filter { !stopWords.contains($0.key) && $0.key.count > 2 }
        let sortedWords = filteredWordCounts.sorted { $0.value > $1.value }.map { $0.key }
        let topWords = Array(sortedWords.prefix(10))
        
        // Calculate average length
        let totalWords = entries.reduce(0) { $0 + $1.wordCount }
        let averageLength = entries.isEmpty ? 0 : totalWords / entries.count
        
        // Determine writing style
        let writingStyle = determineWritingStyle(entries: entries)
        
        // Analyze emotional tone
        let emotionalTone = analyzeEmotionalTone(entries: entries)
        
        // Identify common themes
        let commonThemes = identifyCommonThemes(entries: entries)
        
        return JournalAnalysis(
            topWords: topWords,
            averageLength: averageLength,
            writingStyle: writingStyle,
            emotionalTone: emotionalTone,
            commonThemes: commonThemes,
            wordCount: totalWords
        )
    }
    
    private static func determineWritingStyle(entries: [MoodEntry]) -> String {
        guard !entries.isEmpty else { return "Not enough data" }
        
        let avgLength = entries.reduce(0) { $0 + $1.wordCount } / entries.count
        let hasQuestions = entries.contains { $0.content.contains("?") }
        let hasExclamations = entries.contains { $0.content.contains("!") }
        
        switch (avgLength, hasQuestions, hasExclamations) {
        case (..<50, _, _):
            return "Concise and direct"
        case (50..<100, true, _):
            return "Reflective and questioning"
        case (50..<100, _, true):
            return "Expressive and emotional"
        case (100..., _, _):
            return "Detailed and thorough"
        default:
            return "Balanced and clear"
        }
    }
    
    private static func analyzeEmotionalTone(entries: [MoodEntry]) -> String {
        guard !entries.isEmpty else { return "Not enough data" }
        
        let positiveWords = ["happy", "joy", "grateful", "peace", "love", "hope", "good", "great", "wonderful"]
        let negativeWords = ["sad", "angry", "frustrated", "anxious", "worried", "bad", "terrible", "awful"]
        
        var positiveCount = 0
        var negativeCount = 0
        
        for entry in entries {
            let words = entry.content.lowercased().split { !$0.isLetter }.map { String($0) }
            positiveCount += words.filter { positiveWords.contains($0) }.count
            negativeCount += words.filter { negativeWords.contains($0) }.count
        }
        
        if positiveCount > negativeCount * 2 {
            return "Predominantly positive"
        } else if negativeCount > positiveCount * 2 {
            return "Predominantly negative"
        } else {
            return "Balanced emotional tone"
        }
    }
    
    private static func identifyCommonThemes(entries: [MoodEntry]) -> [String] {
        let themes = [
            "Work": ["work", "job", "career", "project", "meeting", "deadline"],
            "Relationships": ["friend", "family", "relationship", "love", "partner"],
            "Health": ["health", "exercise", "fitness", "diet", "sleep", "energy"],
            "Personal Growth": ["learn", "grow", "improve", "develop", "skill", "knowledge"],
            "Stress": ["stress", "anxiety", "pressure", "overwhelm", "tired"]
        ]
        
        var themeCounts: [String: Int] = [:]
        
        for entry in entries {
            let words = entry.content.lowercased().split { !$0.isLetter }.map { String($0) }
            
            for (theme, keywords) in themes {
                let count = words.filter { keywords.contains($0) }.count
                if count > 0 {
                    themeCounts[theme, default: 0] += count
                }
            }
        }
        
        return themeCounts.sorted { $0.value > $1.value }
            .prefix(3)
            .map { $0.key }
    }
} 