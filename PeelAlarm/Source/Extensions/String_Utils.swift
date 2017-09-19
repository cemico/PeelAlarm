//
//  String_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension String {

    var length: Int {

        return self.characters.count
    }

    func stringByAppendingPathComponent(path: String) -> String {

        let nsSelf = self as NSString
        return nsSelf.appendingPathComponent(path)
    }

    static func from(any: Any, default value: String = "") -> String {

        return any as? String ?? value
    }

    static func format12HourTime(hour: Int, minute: Int) -> String {

        // validation and range check
        let hour = abs(hour) % 12
        let minute = abs(minute) % 60
        return "\(hour):\(String(format: "%02d", minute))"
    }
}
