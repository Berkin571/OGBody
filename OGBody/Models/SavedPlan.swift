//
//  SavedPlan.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 11.05.25.
//

import Foundation

/// Ein einzelner gespeicherter Plan
struct SavedPlan: Identifiable, Codable, Hashable {
    let id: UUID
    let date: Date
    let text: String
    var reminderDate: Date?
}
