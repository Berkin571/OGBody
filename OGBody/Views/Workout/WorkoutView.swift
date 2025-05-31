//
//  WorkoutView.swift
//  OGBody
//

import SwiftUI

struct WorkoutView: View {
    @StateObject private var vm = WorkoutViewModel()
    private let cols = [GridItem(.flexible()), GridItem(.flexible())]
    
    /// Reihenfolge der Wochentage für die Sortierung
    private let weekdayOrder = [
        "montag", "dienstag", "mittwoch",
        "donnerstag", "freitag", "samstag", "sonntag"
    ]
    
    var body: some View {
        NavigationStack {
            Group {
                switch (vm.isLoading, vm.days.isEmpty) {
                    
                case (true, _):
                    ProgressView("Lade Plan …")
                    
                case (false, true):
                    EmptyStateView()          // Fallback, wenn kein Plan existiert
                    
                default:
                    ScrollView {
                        LazyVGrid(columns: cols, spacing: 16) {
                            ForEach(sortedDays) { day in      // sortierte Liste
                                NavigationLink {
                                    WorkoutDetailView(day: day)
                                } label: {
                                    WorkoutCardView(day: day)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity,
                   alignment: .top)
            .navigationTitle("Workout")
        }
    }
    
    // MARK: – Sortier-Logik --------------------------------------------------
    
    /// sortiert Tage erst nach Wochentags-Reihenfolge, dann alphabetisch
    private var sortedDays: [TrainingDay] {
        vm.days.sorted { a, b in
            let ia = weekdayIndex(in: a.name)
            let ib = weekdayIndex(in: b.name)
            return ia == ib ? a.name < b.name : ia < ib
        }
    }
    
    /// liefert Index (0–6) des ersten gefundenen Wochentags, sonst 99
    private func weekdayIndex(in text: String) -> Int {
        let lower = text.lowercased()
        return weekdayOrder.firstIndex(where: { lower.contains($0) }) ?? 99
    }
}

/// Fallback-Kachel, wenn noch kein Plan generiert wurde
private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "figure.strengthtraining.traditional")
                .font(.system(size: 60))
                .foregroundColor(Color("PrimaryGreen"))
            
            Text("Kein Trainingsplan vorhanden")
                .font(.title3)
                .multilineTextAlignment(.center)
            
            NavigationLink("Auf dich abgestimmten Plan generieren") {
                OnboardingView()
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("PrimaryGreen"))
        }
        .padding()
    }
}
