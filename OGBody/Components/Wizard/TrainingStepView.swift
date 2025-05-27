//
//  TrainingStepView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 27.05.25.
//

import SwiftUI

// 4 • Training
struct TrainingStepView: View {
    @ObservedObject var vm: OnboardingViewModel
    var body: some View {
        Form {
            Section("Trainingstage pro Woche") {
                Stepper(value: $vm.daysPerWeek, in: 1...7) {
                    Text("\(vm.daysPerWeek) Tag(e)")
                }
            }
            Section("Dauer je Einheit") {
                Picker("Dauer", selection: $vm.sessionDuration) {
                    ForEach(SessionDuration.allCases, id: \.self) { Text($0.label) }
                }.pickerStyle(.segmented)
            }
            Section("Equipment") {
                Picker("Verfügbar", selection: $vm.equipment) {
                    ForEach(EquipmentLevel.allCases, id: \.self) { Text($0.rawValue) }
                }.pickerStyle(.inline)
            }
        }.scrollContentBackground(.hidden)
    }
}
