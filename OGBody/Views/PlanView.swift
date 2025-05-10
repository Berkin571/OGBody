//
//  PlanView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import SwiftUI

struct PlanView: View {
    @ObservedObject var planVM: PlanViewModel
    
    var body: some View {
        ZStack {
            Color("White").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Header
                    Text("Dein personalisierter Plan")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryGreen"))
                    
                    // Trainingsplan-Sektion
                    Text("🏋️ Trainingsplan")
                        .font(.headline)
                        .foregroundColor(Color("AccentDark"))
                    TextFormatted(
                      markdown: extractSection(
                        named: "Trainingsplan",
                        in: planVM.plan
                      )
                    )
                    
                    // Ernährungsplan-Sektion
                    Text("🥗 Ernährungsplan")
                        .font(.headline)
                        .foregroundColor(Color("AccentDark"))
                    TextFormatted(
                      markdown: extractSection(
                        named: "Ernährungsplan",
                        in: planVM.plan
                      )
                    )
                    
                    // Save Button
                    Button(action: {
                        PlanStore.shared.add(planVM.plan)
                    }) {
                        Label("Plan speichern", systemImage: "bookmark.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("PrimaryGreen"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.top, 24)
                }
                .padding()
                .background(Color.white)       // echtes Weiß
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                .padding()
            }
        }
        .navigationTitle("Dein Plan")
    }
    
    /// Schneidet den Text zwischen "**Name:**" und dem nächsten "**...**" (oder Ende) heraus
    private func extractSection(named name: String, in text: String) -> String {
        let startMarker = "**\(name):**"
        // Der Endmarker für den Trainingsplan ist immer **Ernährungsplan:**
        let endMarker = "**Ernährungsplan:**"
        
        // 1) Finde den Start
        guard let startRange = text.range(of: startMarker) else {
            return ""   // Starter nicht gefunden
        }
        let afterStart = text[startRange.upperBound...]
        
        // 2) Für Trainingsplan: bis zum Ernährungsplan abschneiden
        let slice: Substring
        if name == "Trainingsplan",
           let endRange = afterStart.range(of: endMarker) {
            slice = afterStart[..<endRange.lowerBound]
        } else {
            // Für Ernährungsplan nimm alles bis zum Ende
            slice = afterStart
        }
        
        // 3) Trim und zurückgeben
        return slice
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

/// Dein bewährter Markdown-Parser
struct TextFormatted: View {
    let markdown: String

    var body: some View {
        let lines = markdown.components(separatedBy: "\n")
        return ForEach(lines.indices, id: \.self) { i in
            let line = lines[i]
            if line.hasPrefix("**") && line.hasSuffix("**") {
                Text(line.replacingOccurrences(of: "**", with: ""))
                    .font(.headline)
                    .foregroundColor(Color("AccentDark"))
            } else if line.hasPrefix("- ") {
                Text(line.replacingOccurrences(of: "- ", with: "• "))
                    .padding(.leading, 8)
                    .foregroundColor(.primary)
            } else {
                Text(line)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.primary)
            }
        }
    }
}
