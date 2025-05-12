//
//  OnboardingView.swift
//  OGBody
//
//  Created by You on 12.05.25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var vm = OnboardingViewModel()
    @State private var showPlanSheet = false
    @State private var planToShow = ""

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()

                Form {
                    Section(header: Text("Körperdaten")
                                .foregroundColor(Color("AccentDark"))) {
                        TextField("Gewicht (kg)", text: $vm.weight)
                            .keyboardType(.decimalPad)
                        TextField("Größe (cm)", text:  $vm.height)
                            .keyboardType(.decimalPad)
                        TextField("Alter", text:    $vm.age)
                            .keyboardType(.numberPad)
                    }
                    Section(header: Text("Geschlecht")
                                .foregroundColor(Color("AccentDark"))) {
                        Picker("Geschlecht", selection: $vm.gender) {
                            ForEach(Gender.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    Section(header: Text("Aktivitätslevel")
                                .foregroundColor(Color("AccentDark"))) {
                        Picker("Aktivitätslevel", selection: $vm.activityLevel) {
                            ForEach(ActivityLevel.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    Section(header: Text("Ziel")
                                .foregroundColor(Color("AccentDark"))) {
                        Picker("Ziel", selection: $vm.goal) {
                            ForEach(FitnessGoal.allCases, id: \.self) {
                                Text($0.rawValue)
                            }
                        }
                        .pickerStyle(.segmented)
                    }

                    Section {
                        if vm.isLoading {
                            HStack {
                                Spacer()
                                ProgressView("Erzeuge Plan…")
                                Spacer()
                            }
                        } else {
                            Button {
                                Task {
                                    await vm.submit()
                                    // Nur wenn wir wirklich einen non-empty Plan haben:
                                    if let text = vm.planText?
                                        .trimmingCharacters(in: .whitespacesAndNewlines),
                                       !text.isEmpty
                                    {
                                        planToShow = text
                                        showPlanSheet = true
                                    }
                                }
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
            // Sheet öffnet PlanView – kein Optional-Unwrapping in NavigationLink nötig
            .sheet(isPresented: $showPlanSheet) {
                NavigationStack {
                    PlanView(fullPlan: planToShow)
                }
            }
        }
    }
}
