//
//  Date.swift
//  OGBody
//
//  Created by Berkin Koray Bilgin on 12.05.25.
//

import Foundation

// Helper extension for setting hour/minute/second
extension Calendar {
    func date(bySettingHour hour: Int, minute: Int, second: Int, of date: Date) -> Date? {
        self.date(
            bySettingHour: hour,
            minute: minute,
            second: second,
            of: date
        )
    }
}

extension SavedPlan: Hashable { }

