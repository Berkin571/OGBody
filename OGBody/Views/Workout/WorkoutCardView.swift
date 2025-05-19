//
//  WorkoutCardView.swift
//  OGBody
//
//  Created by You on 19.05.25.
//

import SwiftUI

struct WorkoutCardView: View {
    let workout: Workout

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(workout.imageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, minHeight: 180, maxHeight: 180)
                .clipped()                              
                .cornerRadius(16)

            // Overlay-Gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.6)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .cornerRadius(16)

            // Text oben drauf
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
        .frame(maxWidth: .infinity)        // nimmt eine halbe Bildschirmbreite im Grid ein
        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
    }
}
