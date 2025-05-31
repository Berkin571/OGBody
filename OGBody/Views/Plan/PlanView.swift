//
//  PlanView.swift
//  OGBody
//

import SwiftUI

// MARK: – Helper-Model für die Food-Sektion
struct MealSection: Identifiable {
    let id = UUID()
    var name: String
    var items: [String]
}

struct PlanView: View {
    // Roh-Text aus der KI
    let fullPlan: String
    
    @State private var trainingDays: [TrainingDay] = []
    @State private var meals:        [MealSection] = []
    @State private var isEditing     = false
    @State private var draftPlan:    String
    
    @Environment(\.presentationMode) private var presentation
    
    // --------------------------------------------------------------
    init(fullPlan: String) {
        self.fullPlan  = fullPlan
        _draftPlan     = State(initialValue: fullPlan)
    }
    
    // --------------------------------------------------------------
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            ScrollView { content }.padding()
        }
        .navigationTitle("Dein Plan")
        .onAppear { parseAll() }
    }
    
    // MARK: – Haupt-Content
    @ViewBuilder
    private var content: some View {
        VStack(spacing: 24) {
            if isEditing {
                TextEditor(text: $draftPlan)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .frame(minHeight: 300)
                    .onChange(of: draftPlan) { _ in parseAll() }
            } else {
                displayMode
            }
            buttonBar
        }
    }
    
    // MARK: – Anzeige-Block
    private var displayMode: some View {
        VStack(alignment: .leading, spacing: 32) {
            // ------- Trainingsplan -------
            VStack(alignment: .leading, spacing: 16) {
                Text("🏋️ Trainingsplan")
                    .font(.title2).bold()
                    .foregroundColor(Color("AccentDark"))
                
                ForEach(trainingDays) { day in
                    VStack(alignment: .leading, spacing: 8) {
                        Label {
                            Text(day.name).font(.headline)
                        } icon: {
                            Image(systemName: day.category.icon)
                        }
                        .foregroundColor(Color("PrimaryGreen"))
                        
                        ForEach(day.items, id: \.self) { Text("• \($0)") }
                    }
                }
            }
            // ------- Ernährungsplan -------
            VStack(alignment: .leading, spacing: 16) {
                Text("🥗 Ernährungsplan")
                    .font(.title2).bold()
                    .foregroundColor(Color("AccentDark"))
                
                ForEach(meals) { meal in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(meal.name)
                            .font(.headline)
                            .foregroundColor(Color("PrimaryGreen"))
                        ForEach(meal.items, id: \.self) { Text("• \($0)") }
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
    
    // MARK: – Button-Leiste
    private var buttonBar: some View {
        HStack {
            Button(isEditing ? "Fertig" : "Bearbeiten") {
                withAnimation {
                    if isEditing { parseAll() }
                    isEditing.toggle()
                }
            }
            .buttonStyle(.bordered)
            .tint(Color("PrimaryGreen").opacity(0.2))
            
            Spacer()
            
            if !isEditing {
                Button {
                    PlanStore.shared.add(draftPlan)
                    presentation.wrappedValue.dismiss()
                } label: {
                    Label("Speichern", systemImage: "bookmark.fill")
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("PrimaryGreen"))
            }
        }
    }
    
    // MARK: – Parser (Train / Food sauber trennen)
    private func parseAll() {
        // 1) Ersten „Ernährungsplan“-Header suchen
        guard let mealHeader = draftPlan.range(
                of: "Ernährungsplan",
                options: .caseInsensitive)
        else {
            // nur Training vorhanden
            trainingDays = PlanParser.trainingDays(from: draftPlan)
            meals = []
            return
        }
        
        // 2) Texte schneiden
        let trainText = String(draftPlan[..<mealHeader.lowerBound])
        let mealText  = String(draftPlan[mealHeader.upperBound...])
        
        // 3) Trainingstage via Helper
        trainingDays = PlanParser.trainingDays(from: trainText)
        
        // 4) Mahlzeiten
        meals = parseMeals(from: mealText)
    }
    
    // MARK: – Food-Parser
    private func parseMeals(from raw: String) -> [MealSection] {
        var sections: [MealSection] = []
        var current:  MealSection?
        
        for line in raw.components(separatedBy: .newlines) {
            let t = line.trimmingCharacters(in: .whitespaces)
            guard !t.isEmpty else { continue }
            
            // Trainings-Header im Food-Block ignorieren
            if t.localizedCaseInsensitiveContains("trainingsplan") { continue }
            
            if t.hasPrefix("**") && t.hasSuffix("**") {
                if let m = current { sections.append(m) }
                let name = t.trimmingCharacters(in: CharacterSet(charactersIn: "*"))
                current  = MealSection(name: name, items: [])
            } else if var m = current,
                      t.hasPrefix("-") || t.range(of: #"^\d+\.\s"#,
                                                  options: .regularExpression) != nil {
                var txt = t
                if txt.hasPrefix("-") { txt.removeFirst() }
                else if let r = txt.range(of: #"^\d+\.\s"#,
                                          options: .regularExpression) {
                    txt = String(txt[r.upperBound...])
                }
                m.items.append(txt.trimmingCharacters(in: .whitespaces))
                current = m
            }
        }
        if let m = current { sections.append(m) }
        return sections
    }
}
