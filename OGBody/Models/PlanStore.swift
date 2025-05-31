//
//  PlanStore.swift
//  OGBody
//

import Foundation
import Combine

final class PlanStore: ObservableObject {
    static let shared = PlanStore()
    
    @Published private(set) var plans: [SavedPlan] = []
    private let key = "SAVED_PLANS"
    
    private init() { load() }
    
    func add(_ text: String) {
        let new = SavedPlan(id: UUID(), date: Date(), text: text, reminderDate: nil)
        plans.insert(new, at: 0)
        save()
        
        // Trainings-Tage parsen & in Firestore speichern
        let days = PlanParser.trainingDays(from: text)
        Task { try? await WorkoutRepository.shared.save(days) }
    }
    
    func delete(at offsets: IndexSet) {
        plans.remove(atOffsets: offsets)
        save()
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let decoded = try? JSONDecoder().decode([SavedPlan].self, from: data)
        else { return }
        plans = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(plans) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func setReminderDate(_ date: Date, for planID: UUID) {
        guard let idx = plans.firstIndex(where: { $0.id == planID }) else { return }
        plans[idx].reminderDate = date
        save()
    }
}

