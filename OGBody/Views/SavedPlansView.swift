//
//  SavedPlansView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 10.05.25.
//

import SwiftUI

struct SavedPlansView: View {
    @StateObject private var store = PlanStore.shared

    var body: some View {
        ZStack {
            Color("White").ignoresSafeArea()
            List {
                if store.plans.isEmpty {
                    Text("Noch keine Pläne gespeichert.")
                        .foregroundColor(.secondary)
                } else {
                    ForEach(store.plans) { plan in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(plan.date, style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(plan.text)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete { indexSet in
                        store.delete(at: indexSet)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Gespeicherte Pläne")
            .toolbar {
                EditButton()
                    .tint(Color("PrimaryGreen"))
            }
        }
    }
}

// Einfacher Store mit UserDefaults (oder CoreData als nächster Schritt)
final class PlanStore: ObservableObject {
    static let shared = PlanStore()
    @Published private(set) var plans: [SavedPlan] = []

    private let key = "SAVED_PLANS"

    private init() {
        load()
    }

    func add(_ text: String) {
        let new = SavedPlan(id: UUID(), date: Date(), text: text)
        plans.insert(new, at: 0)
        save()
    }

    func delete(at offsets: IndexSet) {
        plans.remove(atOffsets: offsets)
        save()
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([SavedPlan].self, from: data) {
            plans = decoded
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(plans) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

struct SavedPlan: Identifiable, Codable {
    let id: UUID
    let date: Date
    let text: String
}
