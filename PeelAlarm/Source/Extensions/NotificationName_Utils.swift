//
//  NotificationName_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension Notification.Name {

    struct Keys {

        static let alarms = "alarms"
    }

    static let drAlarmsUpdated = Notification.Name(NotificationMessages.alarmsUpdated)
}
