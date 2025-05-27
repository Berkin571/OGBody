//
//  SummaryStepView.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 27.05.25.
//

import SwiftUI

// 5 • Zusammenfassung (nur Lesemodus)
struct SummaryStepView: View {
    @ObservedObject var vm: OnboardingViewModel
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Text("✅ Körper:  \(vm.weight) kg • \(vm.height) cm • \(vm.age) J")
                    Text("✅ Geschlecht:  \(vm.gender.rawValue)")
                    Text("✅ Aktivität:  \(vm.activityLevel.rawValue)")
                    if !vm.injuries.isEmpty {
                        Text("✅ Einschränkungen:  \(vm.injuries)")
                    }
                }
                Divider()
                Group {
                    Text("✅ Ernährung:  \(vm.diet.rawValue)")
                    if !vm.allergies.isEmpty {
                        Text("✅ Allergien:  \(vm.allergies)")
                    }
                }
                Divider()
                Group {
                    Text("✅ Training:  \(vm.daysPerWeek)× pro Woche, " +
                         "\(vm.sessionDuration.label.lowercased()) • \(vm.equipment.rawValue)")
                    Text("✅ Ziel:  \(vm.goal.rawValue)")
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}
