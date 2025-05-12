//
//  OnboardingViewModel.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import Foundation

@MainActor
class OnboardingViewModel: ObservableObject {
    // Nutzereingaben
    @Published var weight = ""
    @Published var height = ""
    @Published var age = ""
    @Published var gender: Gender = .male
    @Published var activityLevel: ActivityLevel = .sedentary
    @Published var goal: FitnessGoal = .generalFitness

    // Status & Ergebnis
    @Published var isLoading = false
    @Published var planText: String? = nil

    /// Ruft die AI auf und schreibt das Ergebnis in `planText`
    func submit() async {
        isLoading = true
        defer { isLoading = false }

        // Eingaben validieren
        guard
            let w = Double(weight),
            let h = Double(height),
            let a = Int(age)
        else {
            planText = "❌ Bitte gültige Körperdaten eingeben!"
            return
        }

        let profile = UserProfile(
            weight: w,
            height: h,
            age: a,
            gender: gender,
            activityLevel: activityLevel,
            goal: goal
        )

        do {
            let result = try await OpenAIService.shared.generatePlan(for: profile)
            planText = result   // <-- hier setzen wir den AI-Text
        } catch {
            planText = "❌ Fehler: \(error.localizedDescription)"
        }
    }
}
