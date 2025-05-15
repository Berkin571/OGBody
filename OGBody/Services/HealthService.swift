//
//  HealthStore.swift
//  OGBody
//
//  Created by You on 16.05.25.
//

import Foundation
import HealthKit

final class HealthStore: ObservableObject {
    static let shared = HealthStore()
    private let store = HKHealthStore()

    @Published var stepCount: Double = 0
    @Published var activeCalories: Double = 0
    @Published var heartRate: Double = 0
    @Published var distance: Double = 0   

    private init() {}

    private var readTypes: Set<HKObjectType> {
        var set: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        ]
        return set
    }

    func requestAuthorization() {
        guard HKHealthStore.isHealthDataAvailable() else { return }
        store.requestAuthorization(toShare: [], read: readTypes) { ok, error in
            if ok { self.loadTodayData() }
            else  { print("HealthKit Authorization failed:", error?.localizedDescription ?? "") }
        }
    }

    private func loadTodayData() {
        let cal       = Calendar.current
        let startOfDay = cal.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: Date(),
            options: .strictStartDate
        )

        // Helper:
        func runStatsQuery(for identifier: HKQuantityTypeIdentifier,
                           unit: HKUnit,
                           options: HKStatisticsOptions,
                           assign: @escaping (Double) -> Void)
        {
            let type = HKQuantityType.quantityType(forIdentifier: identifier)!
            let q    = HKStatisticsQuery(
                quantityType: type,
                quantitySamplePredicate: predicate,
                options: options
            ) { _, result, _ in
                let val = result?
                    .sumQuantity()?
                    .doubleValue(for: unit)
                    ?? 0
                DispatchQueue.main.async { assign(val) }
            }
            store.execute(q)
        }

        // Schritte
        runStatsQuery(
            for: .stepCount,
            unit: .count(),
            options: .cumulativeSum
        ) { self.stepCount = $0 }

        // Aktive Kalorien
        runStatsQuery(
            for: .activeEnergyBurned,
            unit: .kilocalorie(),
            options: .cumulativeSum
        ) { self.activeCalories = $0 }

        // Distanz (Walking + Running)
        runStatsQuery(
            for: .distanceWalkingRunning,
            unit: HKUnit.meter(),
            options: .cumulativeSum
        ) { self.distance = $0 }

        // Herzfrequenz (Durchschnitt)
        let hrType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
        let hrQuery = HKStatisticsQuery(
            quantityType: hrType,
            quantitySamplePredicate: predicate,
            options: .discreteAverage
        ) { _, result, _ in
            let bpm = result?
                .averageQuantity()?
                .doubleValue(for: HKUnit(from: "count/min"))
                ?? 0
            DispatchQueue.main.async { self.heartRate = bpm }
        }
        store.execute(hrQuery)
    }
}
