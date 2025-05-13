//
//  HealthService.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 13.05.25.
//

import Foundation
import HealthKit

final class HealthStore: ObservableObject {
    static let shared = HealthStore()
    private let store = HKHealthStore()

    @Published var stepCount: Double = 0
    @Published var activeCalories: Double = 0
    @Published var heartRate: Double = 0

    private init() {}

    /// Legt fest, welche Datentypen wir lesen wollen
    private var readTypes: Set<HKObjectType> {
        [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]
    }

    /// Fordert HealthKit-Berechtigung an
    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        store.requestAuthorization(toShare: [], read: readTypes) { ok, error in
            if ok {
                self.loadTodayData()
            } else {
                print("HealthKit Authorization failed: \(error?.localizedDescription ?? "")")
            }
        }
    }

    /// Lädt alle Werte für heute
    func loadTodayData() {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: Date(),
            options: .strictStartDate
        )

        // Schrittzahl
        let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let stepsQuery = HKStatisticsQuery(
            quantityType: stepsType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            DispatchQueue.main.async {
                self.stepCount = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            }
        }
        store.execute(stepsQuery)

        // Aktive Kalorien
        let calType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
        let calQuery = HKStatisticsQuery(
            quantityType: calType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            DispatchQueue.main.async {
                self.activeCalories = result?.sumQuantity()?.doubleValue(for: .kilocalorie()) ?? 0
            }
        }
        store.execute(calQuery)

        // Herzfrequenz (Durchschnitt)
        let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let hrQuery = HKStatisticsQuery(
            quantityType: hrType,
            quantitySamplePredicate: predicate,
            options: .discreteAverage
        ) { _, result, _ in
            DispatchQueue.main.async {
                // Herzfrequenz in Schläge pro Minute
                self.heartRate = result?.averageQuantity()?.doubleValue(for: HKUnit(from: "count/min")) ?? 0
            }
        }
        store.execute(hrQuery)
    }
}
