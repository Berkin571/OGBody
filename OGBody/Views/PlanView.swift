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

                    // Hier parsen wir Markdown-ähnliche Überschriften fett
                    TextFormatted(markdown: planVM.plan)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                .padding()
            }
        }
        .navigationTitle("Dein Plan")
    }
}

/// Hilfs-View, um einfache Markdown-**fett**- und Listen-Zeilen darzustellen
struct TextFormatted: View {
    let markdown: String

    var body: some View {
        // Splitte Zeilen und style Überschriften und Listeneinträge
        let lines = markdown.components(separatedBy: "\n")
        return ForEach(lines.indices, id: \.self) { i in
            let line = lines[i]
            if line.hasPrefix("**") && line.hasSuffix("**") {
                Text(line
                    .replacingOccurrences(of: "**", with: "")
                )
                .font(.headline)
                .foregroundColor(Color("AccentDark"))
            } else if line.hasPrefix("- ") {
                Text(line.replacingOccurrences(of: "- ", with: "• "))
                    .padding(.leading, 8)
            } else {
                Text(line)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
