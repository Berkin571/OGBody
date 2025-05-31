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
        VStack(spacing: 20) {
            Picker("Ernährungsform", selection: $vm.diet) {
                ForEach(DietPreference.allCases, id: \.self) { Text($0.rawValue) }
            }
            .pickerStyle(.inline)
            .padding(.vertical, 6)
            
            TextField("Allergien / Unverträglichkeiten (optional)",
                      text: $vm.allergies)
            .cardField()
        }
        .padding()
    }
}
