//
//  WorkoutData.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 19.05.25.
//

import Foundation

struct WorkoutData {
    static let all: [Workout] = [
        Workout(
            title: "Ganzkörper-Kickstart",
            subtitle: "30 Min, Anfänger",
            imageName: "workout_fullbody",
            instructions: """
1. Aufwärmen (5 Min): leichtes Cardio  
2. Kniebeugen: 3×12  
3. Liegestütze (Knie): 3×10  
4. Ausfallschritte: 3×12 pro Seite  
5. Plank: 3×30 Sekunden  
6. Cool-Down: Dehnen, 5 Min  
"""
        ),
        Workout(
            title: "Cardio-Blitz",
            subtitle: "20 Min, Fortgeschritten",
            imageName: "workout_cardio",
            instructions: """
1. High Knees: 1 Min  
2. Burpees: 3×10  
3. Jumping Jacks: 1 Min  
4. Mountain Climbers: 3×20  
5. Seilspringen (optional): 5 Min  
"""
        ),
        Workout(
            title: "Kern & Rumpf",
            subtitle: "15 Min, Mittelstufe",
            imageName: "workout_core",
            instructions: """
1. Sit-Ups: 3×15  
2. Russian Twists: 3×20  
3. Leg Raises: 3×12  
4. Side Plank: 2×30 Sekunden pro Seite  
5. Rückenstrecker: 3×15  
"""
        )
    ]
}
