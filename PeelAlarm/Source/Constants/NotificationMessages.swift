//
//  NotificationMessages.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

struct NotificationMessages {

    // good practice using reverse dns notation
    private static let baseMessage  = "com.cemico.messages."

    static let alarmsUpdated        = NotificationMessages.baseMessage + "alarmsUpdated"
}
