//
//  PlanParser.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 29.05.25.
//


import Foundation

enum PlanParser {
    /// Extrahiert nur den Trainings-Teil aus dem KI-Plan-Text
    static func trainingDays(from raw: String) -> [TrainingDay] {
        var days: [TrainingDay] = []
        var current: TrainingDay?
        
        for line in raw.components(separatedBy: .newlines) {
            let t = line.trimmingCharacters(in: .whitespaces)
            guard !t.isEmpty else { continue }
            
            if t.hasPrefix("**") && t.hasSuffix("**") {
                // Neuer Tag-Header
                if let d = current { days.append(d) }
                let name = t.trimmingCharacters(in: CharacterSet(charactersIn: "*"))
                current = TrainingDay(id: nil, name: name, items: [])
            } else if var d = current {
                d.items.append(t.replacingOccurrences(of: "•", with: "").trimmingCharacters(in: .whitespaces))
                current = d
            }
        }
        if let d = current { days.append(d) }
        return days
    }
}
