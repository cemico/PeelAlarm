//
//  Array_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension Array where Element: AlarmItem {

    func convertAlarmItemsToNSArray() -> NSArray {

        let convertedItems = NSMutableArray()
        for item in self {

            convertedItems.add(item.toDict())
        }

        return convertedItems
    }
}
