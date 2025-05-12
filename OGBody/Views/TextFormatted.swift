//
//  TextFormatted.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 11.05.25.
//

import SwiftUI

/// Zerlegt einen Markdown-ähnlichen String in Zeilen und stylt Überschriften, Listen etc.
struct TextFormatted: View {
    let markdown: String

    var body: some View {
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
                    .foregroundColor(.primary)
            } else {
                Text(line)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.primary)
            }
        }
    }
}
