//
//  PlanView.swift
//  OGBody
//
//  Created by You on 12.05.25.
//

import SwiftUI

/// Ein Trainings-Tag mit Liste von Übungen/Cardio
struct TrainingDay: Identifiable {
    let id = UUID()
    let name: String
    var items: [String]
}

/// Eine Mahlzeit mit Liste von Gerichten/Snacks
struct MealSection: Identifiable {
    let id = UUID()
    let name: String
    var items: [String]
}

struct PlanView: View {
    let fullPlan: String

    @State private var trainingDays: [TrainingDay] = []
    @State private var meals: [MealSection] = []

    @State private var isEditing = false
    @State private var draftPlan: String

    @Environment(\.presentationMode) private var presentationMode

    init(fullPlan: String) {
        self.fullPlan = fullPlan
        _draftPlan = State(initialValue: fullPlan)
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    if isEditing {
                        TextEditor(text: $draftPlan)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .frame(minHeight: 300)
                            .onChange(of: draftPlan) { _ in parsePlan() }
                    } else {
                        VStack(alignment: .leading, spacing: 32) {
                            // Trainingsplan
                            VStack(alignment: .leading, spacing: 16) {
                                Text("🏋️ Trainingsplan")
                                    .font(.title2).bold()
                                    .foregroundColor(Color("AccentDark"))

                                ForEach(trainingDays) { day in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(day.name)
                                            .font(.headline)
                                            .foregroundColor(Color("PrimaryGreen"))
                                        ForEach(day.items, id: \.self) { item in
                                            Text("• \(item)")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                            }

                            // Ernährungsplan
                            VStack(alignment: .leading, spacing: 16) {
                                Text("🥗 Ernährungsplan")
                                    .font(.title2).bold()
                                    .foregroundColor(Color("AccentDark"))

                                ForEach(meals) { meal in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(meal.name)
                                            .font(.headline)
                                            .foregroundColor(Color("PrimaryGreen"))
                                        ForEach(meal.items, id: \.self) { item in
                                            Text("• \(item)")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(radius: 4)
                    }

                    // Buttons
                    HStack {
                        Button(isEditing ? "Fertig" : "Bearbeiten") {
                            withAnimation {
                                if !isEditing { parsePlan() }
                                isEditing.toggle()
                            }
                        }
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(Color("PrimaryGreen").opacity(0.2))
                        .foregroundColor(Color("PrimaryGreen"))
                        .cornerRadius(8)

                        Spacer()

                        if !isEditing {
                            Button {
                                PlanStore.shared.add(draftPlan)
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Label("Speichern", systemImage: "bookmark.fill")
                                    .padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(Color("PrimaryGreen"))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Dein Plan")
        .onAppear { parsePlan() }
    }

    /// Parst den Rohtext in TrainingsDays und MealSections,
    /// erkennt jetzt auch nummerierte Listen (1., 2., …)
    private func parsePlan() {
        trainingDays = []
        meals = []

        enum State { case none, training, nutrition }
        var state: State = .none

        for rawLine in draftPlan.components(separatedBy: .newlines) {
            let line = rawLine.trimmingCharacters(in: .whitespaces)
            if line.isEmpty { continue }

            // Abschnittswechsel
            if line.contains("Trainingsplan") {
                state = .training
                continue
            }
            if line.contains("Ernährungsplan") {
                state = .nutrition
                continue
            }

            switch state {
            case .training:
                if line.hasPrefix("**") && line.hasSuffix("**") {
                    // Neuer Tag, z.B. **Montag (Beine und Po):**
                    let name = line.trimmingCharacters(in: CharacterSet(charactersIn: "*"))
                    trainingDays.append(TrainingDay(name: name, items: []))
                } else {
                    // Bullet ( - … ) oder nummerierte Liste (1. …)
                    guard !trainingDays.isEmpty else { break }
                    let itemText: String
                    if line.hasPrefix("-") {
                        itemText = String(line.dropFirst()).trimmingCharacters(in: .whitespaces)
                    } else if let match = line.range(of: #"^\d+\.\s"#, options: .regularExpression) {
                        itemText = String(line[match.upperBound...]).trimmingCharacters(in: .whitespaces)
                    } else {
                        // Sonstige Zeilen einfach als Punkt übernehmen
                        itemText = line
                    }
                    trainingDays[trainingDays.count - 1].items.append(itemText)
                }

            case .nutrition:
                if line.hasPrefix("**") && line.hasSuffix("**") {
                    // Neue Mahlzeit, z.B. **Frühstück:**
                    let name = line.trimmingCharacters(in: CharacterSet(charactersIn: "*"))
                    meals.append(MealSection(name: name, items: []))
                } else {
                    guard !meals.isEmpty else { break }
                    let itemText: String
                    if line.hasPrefix("-") {
                        itemText = String(line.dropFirst()).trimmingCharacters(in: .whitespaces)
                    } else if let match = line.range(of: #"^\d+\.\s"#, options: .regularExpression) {
                        itemText = String(line[match.upperBound...]).trimmingCharacters(in: .whitespaces)
                    } else {
                        itemText = line
                    }
                    meals[meals.count - 1].items.append(itemText)
                }

            case .none:
                continue
            }
        }
    }
}
