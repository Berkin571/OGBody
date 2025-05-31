//
//  TrainingDay.swift
//  OGBody
//

import Foundation
import FirebaseFirestore
 
struct TrainingDay: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var items: [String]
    var category: WorkoutCategory
}
