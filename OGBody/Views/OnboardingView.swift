//
//  OnboardingView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var vm = OnboardingViewModel()
    @StateObject private var planVM = PlanViewModel()

    var body: some View {
        Form {                                     // Form für Nutzerinput :contentReference[oaicite:6]{index=6}
            Section("Körperdaten") {
                TextField("Gewicht (kg)", text: $vm.weight).keyboardType(.decimalPad)
                TextField("Größe (cm)", text: $vm.height).keyboardType(.decimalPad)
                TextField("Alter", text: $vm.age).keyboardType(.numberPad)
            }
            Section("Geschlecht") {
                Picker("Geschlecht", selection: $vm.gender) {
                    ForEach(Gender.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.navigationLink)
            }
            Section("Aktivität") {
                Picker("Aktivitätslevel", selection: $vm.activityLevel) {
                    ForEach(ActivityLevel.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.navigationLink)
            }
            Section("Ziel") {
                Picker("Ziel", selection: $vm.goal) {
                    ForEach(FitnessGoal.allCases, id: \.self) { Text($0.rawValue) }
                }
                .pickerStyle(.navigationLink)
            }
            Section {
                if vm.isLoading {
                    ProgressView("Erzeuge Plan…")
                } else {
                    Button("Plan generieren") {
                        Task { await vm.submit() }    // Async/Await Aufruf
                    }
                }
            }
        }
        .navigationTitle("Deine Daten")
        .navigationDestination(isPresented:
            Binding(get: { vm.planText != nil }, set: { if !$0 { vm.planText = nil } })
        ) {                                   // Dynamische Navigation :contentReference[oaicite:7]{index=7}
            if let text = vm.planText {
                PlanView(planVM: planVM)
                    .onAppear { planVM.update(with: text) }
            }
        }
    }
}
