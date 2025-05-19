//
//  WorkoutDetailView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 19.05.25.
//

import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Image(workout.imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)

                Text(workout.title)
                    .font(.largeTitle).bold()
                    .foregroundColor(Color("PrimaryGreen"))

                Text(workout.instructions)
                    .font(.body)
                    .padding(.top, 8)
            }
            .padding()
        }
        .navigationTitle(workout.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
