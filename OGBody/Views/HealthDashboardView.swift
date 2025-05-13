//
//  HealthDashboardView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 13.05.25.
//

import SwiftUI

struct HealthDashboardView: View {
    @StateObject private var health = HealthStore.shared

    // Deine Tagesziele
    private let stepGoal: Double = 10_000
    private let calorieGoal: Double = 500
    private let maxHeartRate: Double = 200

    var body: some View {
        ZStack {
            Color("White").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    Text("Dein Health-Dashboard")
                        .font(.title2).bold()
                        .foregroundColor(Color("PrimaryGreen"))
                        .padding(.top)

                    // Schritte
                    VStack(spacing: 12) {
                        CircleProgressView(
                            value: health.stepCount,
                            total: stepGoal,
                            ringColor: .green,
                            iconName: "figure.walk",
                            title: "Schritte",
                            unit: "Steps"
                        )
                        Text("Ziel: \(Int(stepGoal)) Steps")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Kalorien
                    VStack(spacing: 12) {
                        CircleProgressView(
                            value: health.activeCalories,
                            total: calorieGoal,
                            ringColor: .orange,
                            iconName: "flame.fill",
                            title: "Kalorien",
                            unit: "kcal"
                        )
                        Text("Ziel: \(Int(calorieGoal)) kcal")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    // Herzfrequenz
                    VStack(spacing: 12) {
                        CircleProgressView(
                            value: health.heartRate,
                            total: maxHeartRate,
                            ringColor: .red,
                            iconName: "heart.fill",
                            title: "Herzfrequenz",
                            unit: "bpm"
                        )
                        Text("Maximal-Skala: \(Int(maxHeartRate)) bpm")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            health.requestAuthorization()
        }
        .navigationTitle("Health")
    }
}
