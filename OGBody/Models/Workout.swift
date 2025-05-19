//
//  Workout.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 19.05.25.
//

import Foundation

struct Workout: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let instructions: String
}
