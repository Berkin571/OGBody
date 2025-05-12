//
//  SavedPlansView.swift
//  OGBody
//
//  Created by You on 12.05.25.
//

import SwiftUI

struct SavedPlansView: View {
    @StateObject private var store = PlanStore.shared

    @State private var showingDatePicker = false
    @State private var planForReminder: SavedPlan?
    @State private var selectedDate = Date()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                if store.plans.isEmpty {
                    Text("Noch keine Pläne gespeichert.")
                        .foregroundColor(.secondary)
                        .italic()
                } else {
                    List {
                        ForEach(store.plans) { plan in
                            HStack(alignment: .top, spacing: 12) {
                                // NavigationLink to detail view
                                NavigationLink(destination: PlanDetailView(plan: plan)) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(plan.date, style: .date)
                                            .font(.caption)
                                            .foregroundColor(.secondary)

                                        Text(plan.text)
                                            .font(.body)
                                            .foregroundColor(.primary)
                                            .lineLimit(2)
                                            .fixedSize(horizontal: false, vertical: true)
                                    }
                                }
                                Spacer()
                                // Reminder button
                                Button {
                                    planForReminder = plan
                                    // set default date to existing reminder or tomorrow at 9
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
                                    Image(systemName: plan.reminderDate == nil ? "bell" : "bell.fill")
                                        .foregroundColor(Color("PrimaryGreen"))
                                        .font(.title3)
                                }
                                .buttonStyle(.plain)
                            }
                            .padding(.vertical, 8)
                        }
                        .onDelete { indices in
                            store.delete(at: indices)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Gespeicherte Pläne")
            .toolbar {
                EditButton()
                    .tint(Color("PrimaryGreen"))
            }
            .sheet(isPresented: $showingDatePicker) {
                if let plan = planForReminder {
                    NavigationStack {
                        VStack(spacing: 24) {
                            ScrollView {
                                Text(plan.text)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding()
                            }

                            DatePicker(
                                "Wann erinnern?",
                                selection: $selectedDate,
                                in: Date()...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                            .datePickerStyle(.graphical)
                            .padding()

                            Button("Erinnerung speichern") {
                                ReminderManager.shared.requestAccess { granted, _ in
                                    guard granted else { return }
                                    ReminderManager.shared.createReminder(
                                        title: "Workout-Erinnerung",
                                        notes: String(plan.text.prefix(50)) + "...",
                                        at: selectedDate
                                    ) { _ in }
                                    store.setReminderDate(selectedDate, for: plan.id)
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
                                Button("Abbrechen") { showingDatePicker = false }
                            }
                        }
                    }
                } else {
                    Text("Fehler: Kein Plan ausgewählt.")
                        .padding()
                }
            }
        }
    }
}
