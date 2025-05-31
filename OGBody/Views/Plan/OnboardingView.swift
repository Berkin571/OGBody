//
//  OnboardingView.swift
//  OGBody
//

import SwiftUI

struct OnboardingView: View {
    
    enum Step: Int, CaseIterable {
        case body, lifestyle, diet, training, summary
    }
    
    // MARK: – State
    @StateObject private var vm = OnboardingViewModel()
    @State private var step: Step = .body
    @State private var showPlanSheet = false
    
    // MARK: – View
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                // Progress-Indicator -------------------------------------------------
                ProgressView(value: Double(step.rawValue),
                             total: Double(Step.allCases.count - 1))
                    .tint(Color("PrimaryGreen"))
                    .padding(.horizontal)
                
                // Step-Content -------------------------------------------------------
                Group {
                    switch step {
                    case .body:      BodyStepView(vm: vm)
                    case .lifestyle: LifestyleStepView(vm: vm)
                    case .diet:      DietStepView(vm: vm)
                    case .training:  TrainingStepView(vm: vm)
                    case .summary:   SummaryStepView(vm: vm)
                    }
                }
                .transition(.slide)
                .animation(.easeInOut, value: step)
                
                // Button-Leiste ------------------------------------------------------
                HStack(spacing: 12) {
                    if step != .body {
                        Button("Zurück") { withAnimation { prev() } }
                            .buttonStyle(LinkButtonStyle())
                    }
                    
                    Button(step == .summary ? "Plan generieren" : "Weiter") {
                        Task { await nextOrSubmit() }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!vm.isStepValid(step))
                }
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Schritt \(step.rawValue + 1) / \(Step.allCases.count)")
            .sheet(isPresented: $showPlanSheet) {
                NavigationStack {
                    PlanView(fullPlan: vm.planText ?? "")
                }
            }
        }
    }
    
    // MARK: – Flow-Helpers
    private func nextOrSubmit() async {
        if step == .summary {
            await vm.submit()
            if vm.planText?.isEmpty == false { showPlanSheet = true }
        } else {
            withAnimation { step = Step(rawValue: step.rawValue + 1)! }
        }
    }
    private func prev() {
        step = Step(rawValue: step.rawValue - 1)!
    }
}
