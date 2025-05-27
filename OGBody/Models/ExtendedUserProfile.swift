//
//  ExtendedUserProfile.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 27.05.25.
//


struct ExtendedUserProfile: Codable {
    var weight, height: Double
    var age: Int
    var gender: Gender
    var activityLevel: ActivityLevel
    var goal: FitnessGoal
    
    // neu
    var diet: DietPreference
    var allergies: String
    var injuries: String
    var daysPerWeek: Int
    var sessionDuration: SessionDuration
    var equipment: EquipmentLevel
}
