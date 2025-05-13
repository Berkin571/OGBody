//
//  PlanDetailView.swift
//  OGBody
//
//  Created by You on 12.05.25.
//

import SwiftUI

struct PlanDetailView: View {
    let plan: SavedPlan

    @State private var showingDatePicker = false
    @State private var selectedDate = Date()

    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var store = PlanStore.shared

    var body: some View {
        VStack(spacing: 24) {
            ScrollView {
                Text(plan.text.removingStars())
                    .font(.body)
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
            }

            Button {
                // Voreinstellung: vorhandenes Datum oder morgen um 9 Uhr
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                selectedDate = plan.reminderDate
                    ?? Calendar.current.date(
                        bySettingHour: 9,
                        minute: 0,
                        second: 0,
                        of: tomorrow
                    )!
                showingDatePicker = true
            } label: {
                HStack {
                    Image(systemName: plan.reminderDate == nil ? "bell" : "bell.fill")
                    Text(plan.reminderDate == nil ? "Erinnerung setzen" : "Erinnerung ändern")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal)

            Spacer()
        }
        .navigationTitle("Dein Plan")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingDatePicker) {
            if let planID = plan.id as UUID? {
                NavigationStack {
                    VStack(spacing: 16) {
                        DatePicker(
                            "Wann erinnern?",
                            selection: $selectedDate,
                            in: Date()...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        .padding()

                        Button("Speichern") {
                            ReminderManager.shared.requestAccess { granted, _ in
                                guard granted else { return }
                                ReminderManager.shared.createReminder(
                                    title: "Workout-Erinnerung",
                                    notes: String(plan.text.prefix(50)) + "...",
                                    at: selectedDate
                                ) { _ in }
                                store.setReminderDate(selectedDate, for: planID)
                            }
                            showingDatePicker = false
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)

                        Button("Abbrechen") {
                            showingDatePicker = false
                        }
                        .padding(.bottom)
                    }
                    .navigationTitle("Erinnerung")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Abbrechen") {
                                showingDatePicker = false
                            }
                        }
                    }
                }
            }
        }
    }
}

extension String {
  /// Entfernt alle Sternchen (*) aus dem String
  func removingStars() -> String {
    self.replacingOccurrences(of: "*", with: "")
  }
}
