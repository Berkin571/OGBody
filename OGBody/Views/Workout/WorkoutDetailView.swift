//
//  WorkoutDetailView.swift
//  OGBody
//

import SwiftUI

struct WorkoutDetailView: View {
    let day: TrainingDay
    
    var body: some View {
        List(day.items, id: \.self) { exercise in
            Text(exercise)
        }
        .navigationTitle(day.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
