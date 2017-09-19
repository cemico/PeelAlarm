//
//  Date_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension Date {

    static func from(any: Any, default value: Date = Date()) -> Date {

        return any as? Date ?? value
    }

    var hourMinuteIn24Hour: (hour: Int, minute: Int) {

        //
        // note: this properly changes a UTC time into local time and returns localtime values
        //

        // break date hour and minute out, note: hour is in 24 hour time
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.hour, .minute], from: self)

        // ensure items
        guard let minute = comp.minute,
            let hour24 = comp.hour else { return (hour: 0, minute: 0) }

        return (hour: hour24, minute: minute)
    }

    var hourMinuteIn12Hour: (hour: Int, minute: Int, ampm: String, formatted: String) {

        let self24 = hourMinuteIn24Hour

        // simple threshold check
        let ampm = self24.hour < 12 ? "AM" : "PM"

        // hour adjusts for no "0" hour
        let hour12 = self24.hour % 12
        let hour = hour12 != 0 ? hour12 : 12

        // tuple of info
        let minute = self24.minute
        let formatted = String(format: "%d:%.2d %@", hour, minute, ampm)
        return (hour: hour, minute: minute, ampm: ampm, formatted: formatted)
    }
}
