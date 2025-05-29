//
//  WorkoutRepository.swift
//  OGBody
//

import FirebaseFirestore
import FirebaseAuth

@MainActor
final class WorkoutRepository: ObservableObject {
    static let shared = WorkoutRepository()
    
    @Published private(set) var days: [TrainingDay] = []
    private var listener: ListenerRegistration?
    
    private init() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        listener = Firestore.firestore()
            .collection("users").document(uid)
            .collection("workouts")
            .addSnapshotListener { [weak self] snap, _ in
                self?.days = (try? snap?.documents.compactMap {
                    try $0.data(as: TrainingDay.self)
                }) ?? []
            }
    }
    
    /// Überschreibt alle Tage des Users mit dem neuen Plan
    func save(_ days: [TrainingDay]) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let col = Firestore.firestore()
            .collection("users").document(uid)
            .collection("workouts")
        
        // Alte Dokumente löschen
        for doc in try await col.getDocuments().documents {
            try await doc.reference.delete()
        }
        // Neue speichern
        for day in days {
            _ = try col.addDocument(from: day)
        }
    }
}
