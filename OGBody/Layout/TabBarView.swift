//
//  TabBarView.swift
//  OGBody
//
//  Created by You on 15.05.25.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView {
                NavigationStack { HomeView() }
                    .tabItem { Label("Home",    systemImage: "house.fill") }
                NavigationStack { WorkoutView() }
                    .tabItem { Label("Workout", systemImage: "figure.walk") }
                NavigationStack { AIFitnessCoachView() }
                    .tabItem { Label("Coach",   systemImage: "brain.head.profile") }
            }

            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
                .padding(.bottom, 60)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}
