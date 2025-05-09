//
//  OnboardingViewModel.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import Foundation

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var weight = ""
    @Published var height = ""
    @Published var age = ""
    @Published var gender = Gender.male
    @Published var activityLevel = ActivityLevel.moderate
    @Published var goal = FitnessGoal.weightLoss
    @Published var isLoading = false
    @Published var planText: String?

    func submit() async {
        guard let w = Double(weight),
              let h = Double(height),
              let a = Int(age) else { return }
        let profile = UserProfile(weight: w, height: h, age: a,
                                  gender: gender,
                                  activityLevel: activityLevel,
                                  goal: goal)
        isLoading = true
        do {
        //    planText = try await OpenAIService.shared.generatePlan(for: profile)
            planText = "Fehler:"
        } catch {
            planText = "Fehler: \(error.localizedDescription)"
        }
        isLoading = false
    }
}
