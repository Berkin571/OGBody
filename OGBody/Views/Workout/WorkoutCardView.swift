//
//  WorkoutCardView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 19.05.25.
//

import SwiftUI

struct WorkoutCardView: View {
    let workout: Workout

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(workout.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 180)
                .clipped()
                .cornerRadius(16)

            // Overlay-Gradient für Lesbarkeit
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.0), .black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(16)

            VStack(alignment: .leading, spacing: 4) {
                Text(workout.title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(workout.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding()
        }
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
    }
}
