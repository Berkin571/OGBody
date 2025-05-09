//
//  ReminderService.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 09.05.25.
//

import UserNotifications

final class ReminderService {
    static func scheduleWorkoutReminder(in seconds: TimeInterval) async {
        let center = UNUserNotificationCenter.current()
        let granted = try? await center.requestAuthorization(options: [.alert, .badge, .sound])
        guard granted == true else { return }
        let content = UNMutableNotificationContent()
        content.title = "OG Body Erinnerung"
        content.body  = "Zeit für dein Workout!"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let req = UNNotificationRequest(identifier: UUID().uuidString,
                                        content: content, trigger: trigger)
        try? await center.add(req)         // Async/Await für Notifications :contentReference[oaicite:8]{index=8}
    }
}
