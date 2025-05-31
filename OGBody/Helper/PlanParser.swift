//
//  PlanParser.swift
//  OGBody
//

import Foundation

enum PlanParser {

    // MARK: – Öffentliche API
    /// Liefert ausschließlich den Trainings-Teil des KI-Plans als Array
    /// von `TrainingDay`-Objekten, komplett mit Kategorie & eindeutiger ID.
    static func trainingDays(from raw: String) -> [TrainingDay] {
        var days: [TrainingDay] = []
        
        var inTraining = false
        var curName    = ""
        var curItems:  [String] = []
        
        func flush() {
            guard !curName.isEmpty else { return }
            let cat = detectCategory(for: curName, items: curItems)
            days.append(
                TrainingDay(id: UUID().uuidString,
                            name: curName,
                            items: curItems,
                            category: cat)
            )
            curName  = ""
            curItems = []
        }
        
        for line in raw.components(separatedBy: .newlines) {
            let t = line.trimmingCharacters(in: .whitespaces)
            guard !t.isEmpty else { continue }
            
            if t.localizedCaseInsensitiveContains("trainingsplan") {
                inTraining = true; continue
            }
            if t.localizedCaseInsensitiveContains("ernährungsplan") {
                inTraining = false; flush(); break
            }
            guard inTraining else { continue }
            
            if t.hasPrefix("**") && t.hasSuffix("**") {
                flush()
                curName = t.trimmingCharacters(in: CharacterSet(charactersIn: "*"))
            } else {
                let clean = t.replacingOccurrences(of: "•", with: "")
                             .trimmingCharacters(in: .whitespaces)
                curItems.append(clean)
            }
        }
        flush()
        return days
    }
    
    // MARK: – Kategorie-Heuristik
    static func detectCategory(for name: String,
                               items: [String]) -> WorkoutCategory {
        let s = (name + items.joined(separator: " ")).lowercased()
        if s.contains("push") || s.contains("pull") || s.contains("kraft")
           || s.contains("beine") || s.contains("kniebeuge") {
            return .strength
        }
        if s.contains("hiit") || s.contains("burpee") || s.contains("intervall") {
            return .hiit
        }
        if s.contains("lauf") || s.contains("joggen") || s.contains("cardio") {
            return .cardio
        }
        if s.contains("yoga") || s.contains("stretch") || s.contains("mobility") {
            return .mobility
        }
        return .other
    }
}
