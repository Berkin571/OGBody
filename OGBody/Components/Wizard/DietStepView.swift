//
//  DietStepView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 27.05.25.
//

import SwiftUI

// 3 • Ernährung
struct DietStepView: View {
    @ObservedObject var vm: OnboardingViewModel
    var body: some View {
        Form {
            Section("Präferenz") {
                Picker("Ernährungsform", selection: $vm.diet) {
                    ForEach(DietPreference.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.inline)
            }
            Section("Allergien") {
                TextField("Allergien / Unverträglichkeiten (optional)",
                          text: $vm.allergies)
            }
        }.scrollContentBackground(.hidden)
    }
}
