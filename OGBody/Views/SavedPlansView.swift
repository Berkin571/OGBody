//
//  SavedPlansView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 10.05.25.
//

import SwiftUI

struct SavedPlansView: View {
    // explizite Typannotation hier, damit Swift weiß, um welchen Store es sich handelt
    @StateObject private var store: PlanStore = PlanStore.shared

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
                                .foregroundColor(.primary)
                        }
                        .padding(.vertical, 8)
                    }
                    .onDelete { store.delete(at: $0) }
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
