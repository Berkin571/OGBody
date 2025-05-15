//
//  WorkoutView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 15.05.25.
//


import SwiftUI

struct WorkoutView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Workout")
                .font(.largeTitle).bold()
                .foregroundColor(Color("PrimaryGreen"))
            Text("Hier findest du deine täglichen Trainingspläne.")
                .multilineTextAlignment(.center)
                .padding()
            // z.B. Liste der TrainingDays oder NavigationLink zu PlanView
        }
        .padding()
        .navigationTitle("Workout")
    }
}
