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
        VStack(spacing: 20) {
            Group {
                TextField("Gewicht (kg)", text: $vm.weight)
                    .keyboardType(.decimalPad)
                TextField("Größe (cm)",  text: $vm.height)
                    .keyboardType(.decimalPad)
                TextField("Alter",       text: $vm.age)
                    .keyboardType(.numberPad)
            }
            .cardField()                                  //  << neu
                        
            Picker("Geschlecht", selection: $vm.gender) {
                ForEach(Gender.allCases, id: \.self) { Text($0.rawValue) }
            }
            .pickerStyle(.segmented)
        }
        .padding()
    }
}
