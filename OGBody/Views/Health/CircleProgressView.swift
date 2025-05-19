//
//  CircleProgressView.swift
//  OGBody
//
//  Created by You on 13.05.25.
//

import SwiftUI

struct CircleProgressView: View {
    let value: Double
    let total: Double
    let ringColor: Color
    let iconName: String
    let unit: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(lineWidth: 12)
                    .opacity(0.2)
                    .foregroundColor(ringColor)

                Circle()
                    .trim(from: 0, to: CGFloat(min(value / total, 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .foregroundColor(ringColor)
                    .rotationEffect(.degrees(-90))

                Image(systemName: iconName)
                    .font(.title2)
                    .foregroundColor(ringColor.opacity(0.8))
            }
            .frame(width: 100, height: 100)
            
            Text(displayValue())
                .font(.headline)
            + Text(" \(unit)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private func displayValue() -> String {
        if unit == "km" {
            return String(format: "%.2f", value)
        } else {
            return "\(Int(value))"
        }
    }
}
