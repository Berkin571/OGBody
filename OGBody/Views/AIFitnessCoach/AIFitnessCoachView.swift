//
//  AIFitnessCoachView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 15.05.25.
//


import SwiftUI

struct AIFitnessCoachView: View {
    @State private var showingOnboarding = false

    var body: some View {
        VStack(spacing: 16) {
            Text("AI Fitness Coach")
                .font(.largeTitle).bold()
                .foregroundColor(Color("PrimaryGreen"))
            Text("Dein persönlicher Coach")
                .multilineTextAlignment(.center)
                .padding()

            Button("Jetzt starten") {
                showingOnboarding = true
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("PrimaryGreen"))
            .padding()
            .navigationDestination(isPresented: $showingOnboarding) {
                OnboardingView()
            }
        }
        .padding()
        .navigationTitle("AI Coach")
    }
}
