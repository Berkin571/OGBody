//
//  OnboardingViewModel.swift
//

import Foundation

enum DietPreference: String, CaseIterable, Codable {
    case omnivore = "Omnivor"
    case vegetarian = "Vegetarisch"
    case vegan = "Vegan"
    case pescatarian = "Pescetarisch"
}

enum EquipmentLevel: String, CaseIterable, Codable {
    case none  = "Kein Equipment"
    case basic = "Kurzhanteln / Bänder"
    case full  = "Fitness-Studio"
}

enum SessionDuration: Int, CaseIterable, Codable {
    case twenty = 20, thirty = 30, fortyFive = 45, sixty = 60
    var label: String { "\(rawValue) Min" }
}

@MainActor
class OnboardingViewModel: ObservableObject {
    
    // -------- Step 1
    @Published var weight = ""
    @Published var height = ""
    @Published var age    = ""
    @Published var gender: Gender = .male
    
    // -------- Step 2
    @Published var activityLevel: ActivityLevel = .sedentary
    @Published var injuries: String = ""
    
    // -------- Step 3
    @Published var diet: DietPreference = .omnivore
    @Published var allergies: String = ""
    
    // -------- Step 4
    @Published var daysPerWeek: Int = 3
    @Published var sessionDuration: SessionDuration = .thirty
    @Published var equipment: EquipmentLevel = .basic
    
    // -------- Ziel
    @Published var goal: FitnessGoal = .generalFitness
    
    // -------- Ergebnis
    @Published var isLoading = false
    @Published var planText: String?
    
    // ------------------------------------------------- Validation je Step
    func isStepValid(_ step: OnboardingView.Step) -> Bool {
        switch step {
        case .body:
            return Double(weight) != nil && Double(height) != nil && Int(age) != nil
        case .lifestyle:
            return true
        case .diet:
            return true
        case .training:
            return daysPerWeek >= 1
        case .summary:
            return true
        }
    }
    
    // ------------------------------------------------- API-Call
    func submit() async {
        isLoading = true
        defer { isLoading = false }
        
        guard
            let w = Double(weight),
            let h = Double(height),
            let a = Int(age)
        else { planText = "❌ Ungültige Zahlenangaben"; return }
        
        let profile = ExtendedUserProfile(
            weight: w, height: h, age: a, gender: gender,
            activityLevel: activityLevel, goal: goal,
            diet: diet, allergies: allergies,
            injuries: injuries, daysPerWeek: daysPerWeek,
            sessionDuration: sessionDuration, equipment: equipment
        )
        
        do {
            planText = try await OpenAIService.shared.generatePlan(for: profile)
        } catch {
            planText = "❌ Fehler: \(error.localizedDescription)"
        }
    }
}
