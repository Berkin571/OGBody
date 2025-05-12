//
//  PlanStore.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 11.05.25.
//

import Foundation
import Combine   // ← für ObservableObject & @Published

/// Singleton-Store, der SavedPlan-Objekte in UserDefaults hält
final class PlanStore: ObservableObject {
    static let shared = PlanStore()

    @Published private(set) var plans: [SavedPlan] = []

    private let key = "SAVED_PLANS"

    private init() {
        load()
    }

    func add(_ text: String) {
        let new = SavedPlan(
            id: UUID(),
            date: Date(),
            text: text
        )
        plans.insert(new, at: 0)
        save()
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
}
