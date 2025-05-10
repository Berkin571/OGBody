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
        ZStack {
            Color("White").ignoresSafeArea()
            Form {
                Section(header: Text("Körperdaten").foregroundColor(Color("AccentDark"))) {
                    TextField("Gewicht (kg)", text: $vm.weight)
                        .keyboardType(.decimalPad)
                    TextField("Größe (cm)", text: $vm.height)
                        .keyboardType(.decimalPad)
                    TextField("Alter", text: $vm.age)
                        .keyboardType(.numberPad)
                }
                Section(header: Text("Geschlecht").foregroundColor(Color("AccentDark"))) {
                    Picker("Geschlecht", selection: $vm.gender) {
                        ForEach(Gender.allCases, id: \.self) { g in
                            Text(g.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section(header: Text("Aktivitätslevel").foregroundColor(Color("AccentDark"))) {
                    Picker("Aktivitätslevel", selection: $vm.activityLevel) {
                        ForEach(ActivityLevel.allCases, id: \.self) { level in
                            Text(level.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section(header: Text("Ziel").foregroundColor(Color("AccentDark"))) {
                    Picker("Ziel", selection: $vm.goal) {
                        ForEach(FitnessGoal.allCases, id: \.self) { goal in
                            Text(goal.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    if vm.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    } else {
                        Button {
                            Task { await vm.submit() }
                        } label: {
                            Text("Plan generieren")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("PrimaryGreen"))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .background(Color.clear)
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Deine Daten")
        .navigationDestination(isPresented:
            Binding(get: { vm.planText != nil }, set: { if !$0 { vm.planText = nil } })
        ) {
            PlanView(planVM: planVM)
                .onAppear { planVM.update(with: vm.planText ?? "") }
        }
    }
}
