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
        VStack(spacing: 20) {
            Stepper(value: $vm.daysPerWeek, in: 1...7) {
                Text("Trainingstage: \(vm.daysPerWeek) / Woche")
            }
            .padding(.vertical, 6)
            
            Picker("Dauer je Einheit", selection: $vm.sessionDuration) {
                ForEach(SessionDuration.allCases, id: \.self) { Text($0.label) }
            }
            .pickerStyle(.segmented)
            
            Picker("Equipment", selection: $vm.equipment) {
                ForEach(EquipmentLevel.allCases, id: \.self) { Text($0.rawValue) }
            }
            .pickerStyle(.inline)
            .padding(.vertical, 6)
        }
        .padding()
    }
}
