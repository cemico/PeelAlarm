//
//  AlarmButtonController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/16/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension AlarmViewController {

    ///////////////////////////////////////////////////////////
    // MARK: - Action handlers
    ///////////////////////////////////////////////////////////

    @IBAction func tapSetup(_ sender: Any) {

        // todo: add as testing area, dynamically set storage location and type
        print(#function)

        // test - clear all current data
        UserNotificationMgr.sharedInstance.clearAll(includeDataController: true)

        // set location/type archive methods (typically set in settings / config)
        UserDefaults.standard.storageLocation = .documentsDir
//        UserDefaults.standard.storageLocation = .userPreferences
        UserDefaults.standard.storageType = .unencrypted
//        UserDefaults.standard.storageType = .encrypted

//            // add test data
//            var alarms: [AlarmItem] = []
//
//            let calendar = Calendar.current
//            let dateNow = Date()
//
//            var testDate = calendar.date(bySettingHour: 1, minute: 11, second: 0, of: dateNow)!
//            alarms.append(AlarmItem(date: testDate, name: "Test 1"))
//            testDate = calendar.date(bySettingHour: 2, minute: 2, second: 0, of: dateNow)!
//            alarms.append(AlarmItem(date: testDate, name: "Test 2 ", isEnabled: false))
//            testDate = calendar.date(bySettingHour: 3, minute: 57, second: 0, of: dateNow)!
//            alarms.append(AlarmItem(date: testDate, name: "Test 3"))
//            testDate = calendar.date(bySettingHour: 4, minute: 4, second: 0, of: dateNow)!
//            alarms.append(AlarmItem(date: testDate, name: "Test 4", isEnabled: false))
//            testDate = calendar.date(bySettingHour: 5, minute: 37, second: 0, of: dateNow)!
//            alarms.append(AlarmItem(date: testDate, name: "Test 5"))
//            testDate = calendar.date(bySettingHour: 15, minute: 22, second: 0, of: dateNow)!
//            alarms.append(AlarmItem(date: testDate, name: "Test 6"))
//
//            dc.updateAlarms(alarms: alarms)
//
//            // save
//            let success = ArchiveMgr.sharedInstance.save()
//            print("saved:", success)
//
//            reload()
    }

    @IBAction func tapEdit(_ sender: Any) {

        print(#function)

        // toggle edit mode
        tableView.isEditing = !tableView.isEditing
    }
}
