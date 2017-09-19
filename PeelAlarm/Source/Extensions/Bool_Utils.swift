//
//  Bool_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension Bool {

    static func from(any: Any, default value: Bool = false) -> Bool {

        return any as? Bool ?? value
    }
}
