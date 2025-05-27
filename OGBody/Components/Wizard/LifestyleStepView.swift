//
//  LifestyleStepView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 27.05.25.
//

import SwiftUI

// 2 • Lebensstil
struct LifestyleStepView: View {
    @ObservedObject var vm: OnboardingViewModel
    var body: some View {
        Form {
            Section("Aktivitätslevel") {
                Picker("Level", selection: $vm.activityLevel) {
                    ForEach(ActivityLevel.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.inline)
            }
            Section("Gesundheit") {
                TextField("Verletzungen / Einschränkungen (optional)",
                          text: $vm.injuries)
            }
        }.scrollContentBackground(.hidden)
    }
}
