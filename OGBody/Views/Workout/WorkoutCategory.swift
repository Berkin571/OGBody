//
//  WorkoutCategory.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 31.05.25.
//


import SwiftUI

enum WorkoutCategory: String, Codable {
    case strength
    case cardio
    case mobility
    case hiit
    case other
    
    var icon: String {
        switch self {
        case .strength: "dumbbell.fill"
        case .cardio:   "figure.run"
        case .mobility: "figure.cooldown"
        case .hiit:     "bolt.fill"
        case .other:    "figure.strengthtraining.traditional"
        }
    }
    
    var gradient: LinearGradient {
        switch self {
        case .strength:
            .init(colors: [Color("PrimaryGreen"), .mint],
                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .cardio:
            .init(colors: [.pink, .orange],
                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .mobility:
            .init(colors: [.teal, .cyan],
                  startPoint: .topLeading, endPoint: .bottomTrailing)
        case .hiit:
            .init(colors: [.red, .orange], startPoint: .top, endPoint: .bottom)
        case .other:
            .init(colors: [.purple, .red.opacity(0.6)],
                  startPoint: .top, endPoint: .bottom)
        }
    }
}
