//
//  ReminderManager.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 12.05.25.
//

import Foundation
import EventKit

final class ReminderManager {
    static let shared = ReminderManager()
    private let store = EKEventStore()

    private init() {}

    func requestAccess(completion: @escaping (Bool, Error?) -> Void) {
        store.requestAccess(to: .reminder, completion: completion)
    }

    func createReminder(
        title: String,
        notes: String? = nil,
        at date: Date,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let status = EKEventStore.authorizationStatus(for: .reminder)
        guard status == .authorized else {
            completion(.failure(ReminderError.notAuthorized))
            return
        }

        let reminder = EKReminder(eventStore: store)
        reminder.title = title
        reminder.notes = notes
        reminder.calendar = store.defaultCalendarForNewReminders()
        reminder.addAlarm(EKAlarm(absoluteDate: date))

        do {
            try store.save(reminder, commit: true)
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

    enum ReminderError: Error {
        case notAuthorized
    }
}
