//
//  NSArray_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension NSArray {

    func convertDictsToAlarmItems() -> [AlarmItem] {
        
        var items: [AlarmItem] = []
        for anyItem in self {

            // free bridging from NSDictionary to Dictionary
            if let dict = anyItem as? [String : Any] {

                let newItem = AlarmItem.init(from: dict)
                items.append(newItem)
            }
        }

        return items
    }
}
