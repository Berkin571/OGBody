import Foundation

struct UserProfile: Codable {
    var weight: Double      // kg
    var height: Double      // cm
    var age: Int
    var gender: Gender
    var activityLevel: ActivityLevel
    var goal: FitnessGoal
}

enum Gender: String, CaseIterable, Codable {
    case male = "Männlich", female = "Weiblich", other = "Andere"
}

enum ActivityLevel: String, CaseIterable, Codable {
    case sedentary = "Wenig aktiv"
    case light     = "Leicht aktiv"
    case moderate  = "Mäßig aktiv"
    case active    = "Sehr aktiv"
}

enum FitnessGoal: String, CaseIterable, Codable {
    case weightLoss      = "Gewichtsreduktion"
    case muscleGain      = "Muskelaufbau"
    case generalFitness  = "Allgemeine Fitness"
}
