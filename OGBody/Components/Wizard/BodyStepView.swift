//
//  BodyStepView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 27.05.25.
//

import SwiftUI

// 1 • Körperdaten
struct BodyStepView: View {
    @ObservedObject var vm: OnboardingViewModel
    var body: some View {
        Form {
            Section("Körperdaten") {
                TextField("Gewicht (kg)", text: $vm.weight)
                    .keyboardType(.decimalPad)
                TextField("Größe (cm)",  text: $vm.height)
                    .keyboardType(.decimalPad)
                TextField("Alter",       text: $vm.age)
                    .keyboardType(.numberPad)
                Picker("Geschlecht", selection: $vm.gender) {
                    ForEach(Gender.allCases, id: \.self) { Text($0.rawValue) }
                }.pickerStyle(.segmented)
            }
        }.scrollContentBackground(.hidden)
    }
}
