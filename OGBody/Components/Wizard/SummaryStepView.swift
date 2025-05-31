//
//  SummaryStepView.swift
//  OGBody
//

import SwiftUI

/// 5 • Zusammenfassung – nur Lesemodus, aber im schicken Card-Design
struct SummaryStepView: View {
    @ObservedObject var vm: OnboardingViewModel
    
    // Ein kleiner Helper für Zeilen
    private func row(_ label: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(label)
                .fontWeight(.semibold)
            Spacer(minLength: 8)
            Text(value)
                .foregroundColor(.secondary)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // ---------- Körper & Lifestyle ----------
                card(title: "🩺 Körper & Lifestyle") {
                    row("Gewicht",  "\(vm.weight) kg")
                    row("Größe",    "\(vm.height) cm")
                    row("Alter",    "\(vm.age) J.")
                    row("Geschlecht", vm.gender.rawValue)
                    row("Aktivität",  vm.activityLevel.rawValue)
                    if !vm.injuries.isEmpty {
                        row("Einschränkungen", vm.injuries)
                    }
                }
                
                // ---------- Ernährung ----------
                card(title: "🥦 Ernährung") {
                    row("Präferenz", vm.diet.rawValue)
                    if !vm.allergies.isEmpty {
                        row("Allergien", vm.allergies)
                    }
                }
                
                // ---------- Training ----------
                card(title: "🏋️‍♂️ Training") {
                    row("Tage / Woche", "\(vm.daysPerWeek)")
                    row("Dauer",        vm.sessionDuration.label)
                    row("Equipment",    vm.equipment.rawValue)
                    row("Ziel",         vm.goal.rawValue)
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: – Card-Builder
    @ViewBuilder
    private func card<Content: View>(title: String,
                                     @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text(title)
                .font(.headline)
                .foregroundColor(Color("PrimaryGreen"))
            
            Divider()
            
            content()
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.08), radius: 6, y: 3)
        )
    }
}
