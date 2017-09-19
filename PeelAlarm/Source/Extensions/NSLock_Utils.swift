//
//  NSLock_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension NSLock {

    // auto lock/unlock wrapper around closure
    public func synchronized(_ criticalSection: () -> ()) {

        self.lock()
        criticalSection()
        self.unlock()
    }
}
