//
//  HealthDashboardView.swift
//  OGBody
//
//  Created by You on 16.05.25.
//

import SwiftUI

// MARK: – Deine Metrik-Definition
enum MetricType: CaseIterable, Identifiable {
    case steps, distance, calories, heartRate
    var id: Self { self }

    var unit: String {
        switch self {
        case .steps:     return "Schritte"
        case .distance:  return "Kilometer"
        case .calories:  return "Kalorien"
        case .heartRate: return "Herzfrequenz"
        }
    }

    var iconName: String {
        switch self {
        case .steps:     return "figure.walk"
        case .distance:  return "location.fill"
        case .calories:  return "flame.fill"
        case .heartRate: return "heart.fill"
        }
    }

    var goal: Double {
        switch self {
        case .steps:     return 10_000
        case .distance:  return 5    // 5 km
        case .calories:  return 500
        case .heartRate: return 200
        }
    }

    func value(from hs: HealthStore) -> Double {
        switch self {
        case .steps:     return hs.stepCount
        case .distance:  return hs.distance / 1000.0  // m ➝ km
        case .calories:  return hs.activeCalories
        case .heartRate: return hs.heartRate
        }
    }

    var color: Color {
        switch self {
        case .steps:     return Color.blue
        case .distance:  return Color.green.opacity(0.7)
        case .calories:  return Color.orange.opacity(0.7)
        case .heartRate: return Color.red.opacity(0.7)
        }
    }
}

// MARK: – Dashboard mit 4 Cards
struct HealthDashboardView: View {
    @StateObject private var health = HealthStore.shared
    @State private var selected: MetricType? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 30) {
                    Text("Dein Health-Dashboard")
                        .font(.title2).bold()
                        .foregroundColor(Color("PrimaryGreen"))
                        .padding(.top)

                    // 1. Reihe: Schritte & Kalorien
                    HStack(spacing: 20) {
                        MetricCard(type: .steps,     selected: $selected)
                        MetricCard(type: .distance,  selected: $selected)
                    }
                    .padding(.horizontal)

                    // 2. Reihe: Herzfrequenz & Distanz
                    HStack(spacing: 20) {
                        MetricCard(type: .calories, selected: $selected)
                        MetricCard(type: .heartRate,  selected: $selected)
                    }
                    .padding(.horizontal)

                    // Detail-Liste, wenn eine Metrik ausgewählt
                    if let sel = selected {
                        DetailList(selected: sel, health: health)
                            .padding(.horizontal)
                            .transition(.opacity)
                            .animation(.spring(), value: selected)
                    }

                    Spacer(minLength: 40)
                }
            }
            .onAppear { health.requestAuthorization() }
            .navigationTitle("Health")
        }
    }
}

// MARK: – Einzelne Card mit Kreisbalken
struct MetricCard: View {
    let type: MetricType
    @Binding var selected: MetricType?
    @ObservedObject private var health = HealthStore.shared

    var body: some View {
        let val = type.value(from: health)
        Button {
            withAnimation { selected = (selected == type ? nil : type) }
        } label: {
            VStack(spacing: 8) {
                // Circular Progress
                CircleProgressView(
                    value: val,
                    total: type.goal,
                    ringColor: type.color,
                    iconName: type.iconName,
                    unit: type.unit
                )
                .frame(height: 150)

                Text("Ziel: \(formattedGoal())")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 6)
                    .padding(.top, -8)
            }
            .frame(maxWidth: .infinity, minHeight: 160)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }

    private func formattedGoal() -> String {
        if type == .distance {
            return String(format: "%.1f %@", type.goal, type.unit)
        } else {
            return "\(Int(type.goal)) \(type.unit)"
        }
    }
}

// MARK: – Detail-Liste aller Werte
struct DetailList: View {
    let selected: MetricType
    let health: HealthStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Aktueller Wert: \(formattedValue(selected))")
                .font(.headline)
                .foregroundColor(Color("PrimaryGreen"))
            Divider()
            ForEach(MetricType.allCases) { type in
                HStack {
                    Text(type.unit)
                    Spacer()
                    Text(formattedValue(type))
                        .fontWeight(type == selected ? .bold : .regular)
                        .foregroundColor(type == selected ? Color("PrimaryGreen") : .primary)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    private func formattedValue(_ type: MetricType) -> String {
        let raw = type.value(from: health)
        if type == .distance {
            return String(format: "%.2f %@", raw, type.unit)
        } else {
            return "\(Int(raw)) \(type.unit)"
        }
    }
}
