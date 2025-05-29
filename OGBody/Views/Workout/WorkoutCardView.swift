//
//  WorkoutCardView.swift
//  OGBody
//

import SwiftUI

struct WorkoutCardView: View {
    let day: TrainingDay                        // 🔄 jetzt TrainingDay
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Placeholder-Gradient (später ggf. Bild je Muskelgruppe)
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color("PrimaryGreen").opacity(0.85),
                            Color("PrimaryGreen").opacity(0.50)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 180)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(day.name)
                    .font(.headline).bold()
                    .foregroundColor(.white)
                Text("\(day.items.count) Übungen")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
    }
}
