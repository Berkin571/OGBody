//
//  PlanView.swift
//  OGBody
//
//  Created by You on 12.05.25.
//

import SwiftUI

/// Ernährungs-Sektion mit Mahlzeiten
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
                            // MARK: Trainingsplan
                            VStack(alignment: .leading, spacing: 16) {
                                Text("🏋️ Trainingsplan")
                                    .font(.title2).bold()
                                    .foregroundColor(Color("AccentDark"))

                                ForEach(trainingDays) { day in
                                    VStack(alignment: .leading, spacing: 8) {
                                        // name ist bereits ohne Sterne
                                        Text(day.name)
                                            .font(.headline)
                                            .foregroundColor(Color("PrimaryGreen"))
                                        // items sind ebenfalls ohne Sterne
                                        ForEach(day.items, id: \.self) { item in
                                            Text("• \(item)")
                                                .foregroundColor(.primary)
                                        }
                                    }
                                }
                            }

                            // MARK: Ernährungsplan
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

                    // MARK: Buttons
                    HStack {
                        Button(isEditing ? "Fertig" : "Bearbeiten") {
                            withAnimation {
                                if isEditing {
                                    // Wenn ich aus dem Edit-Modus rausgehe: parsePlan aufrufen
                                    parsePlan()
                                } else {
                                    // Wenn ich in den Edit-Modus gehe: Sterne aus draftPlan entfernen
                                    draftPlan = draftPlan.removingStars()
                                }
                                isEditing.toggle()
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
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
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
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

    /// Parst den Rohtext in Trainings- und Ernährungs-Sektionen
    private func parsePlan() {
        trainingDays = []
        meals = []

        enum Section { case none, training, nutrition }
        var currentSection: Section = .none

        for raw in draftPlan.components(separatedBy: .newlines) {
            let line = raw.trimmingCharacters(in: .whitespaces)
            guard !line.isEmpty else { continue }

            // Abschnittswechsel
            if line.contains("Trainingsplan") {
                currentSection = .training
                continue
            }
            if line.contains("Ernährungsplan") {
                currentSection = .nutrition
                continue
            }

            switch currentSection {
            case .training:
                if line.hasPrefix("**") && line.hasSuffix("**") {
                    // Neuer Tag
                    let cleanName = line
                        .trimmingCharacters(in: CharacterSet(charactersIn: "*"))
                        .removingStars()
                    trainingDays.append(TrainingDay(name: cleanName, items: []))
                } else if let last = trainingDays.last,
                          (line.hasPrefix("-") || line.range(of: #"^\d+\.\s"#, options: .regularExpression) != nil)
                {
                    // Liste an bestehender Sektion ergänzen
                    var text = line
                    if text.hasPrefix("-") { text = String(text.dropFirst()) }
                    else if let r = text.range(of: #"^\d+\.\s"#, options: .regularExpression) {
                        text = String(text[r.upperBound...])
                    }
                    let itemClean = text.trimmingCharacters(in: .whitespaces)
                        .removingStars()
                    trainingDays[trainingDays.count - 1].items.append(itemClean)
                }

            case .nutrition:
                if line.hasPrefix("**") && line.hasSuffix("**") {
                    let cleanName = line
                        .trimmingCharacters(in: CharacterSet(charactersIn: "*"))
                        .removingStars()
                    meals.append(MealSection(name: cleanName, items: []))
                } else if let _ = meals.last,
                          (line.hasPrefix("-") || line.range(of: #"^\d+\.\s"#, options: .regularExpression) != nil)
                {
                    var text = line
                    if text.hasPrefix("-") { text = String(text.dropFirst()) }
                    else if let r = text.range(of: #"^\d+\.\s"#, options: .regularExpression) {
                        text = String(text[r.upperBound...])
                    }
                    let itemClean = text.trimmingCharacters(in: .whitespaces)
                        .removingStars()
                    meals[meals.count - 1].items.append(itemClean)
                }

            case .none:
                continue
            }
        }
    }
}
