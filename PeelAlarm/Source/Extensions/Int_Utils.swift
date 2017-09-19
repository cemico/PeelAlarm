//
//  Int_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension Int {

    static func from(any: Any, default value: Int = 0) -> Int {

        return any as? Int ?? value
    }
}
