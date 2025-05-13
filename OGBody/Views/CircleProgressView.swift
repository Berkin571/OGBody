//
//  CircleProgressView.swift
//  OGBody
//
//  Created by You on 13.05.25.
//

import SwiftUI

struct CircleProgressView: View {
    let value: Double       // aktueller Messwert
    let total: Double       // Ziel bzw. Maximalwert
    let ringColor: Color    // Farbe des Fortschritts
    let iconName: String    // SF Symbol im Ring
    let title: String       // Beschriftung unter dem Ring
    let unit: String        // Einheit des Werts

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Hintergrund-Ring
                Circle()
                    .stroke(lineWidth: 16)
                    .opacity(0.2)
                    .foregroundColor(ringColor)

                // Fortschritts-Ring
                Circle()
                    .trim(from: 0, to: CGFloat(min(value / total, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .foregroundColor(ringColor)
                    .rotationEffect(.degrees(-90))

                // Icon in der Mitte
                Image(systemName: iconName)
                    .font(.title)
                    .foregroundColor(ringColor.opacity(0.8))
            }
            .frame(width: 120, height: 120)

            // Wert + Einheit
            Text("\(Int(value)) \(unit)")
                .font(.headline)
                .foregroundColor(.primary)
                

            // Titel
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
}
