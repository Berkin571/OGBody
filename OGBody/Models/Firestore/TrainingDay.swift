//
//  TrainingDay.swift
//  OGBody
//

import Foundation
import FirebaseFirestore
 
struct TrainingDay: Identifiable, Codable {
    @DocumentID var id: String?          // Firestore-ID
    var name: String                     // z. B. „Montag – Push“
    var items: [String]                  // Übungen
}
