//
//  UserDefaults_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension UserDefaults {

    struct Constants {

        struct Keys {

            static let archiveLocation      = "archiveLocation"
            static let archiveType          = "archiveType"
            static let currentAlarmID       = "currentAlarmID"
            static let alarmsEncrypted      = "alarmsEncrypted"
            static let alarmsUnencrypted    = "alarmsUnencrypted"
        }

        struct Defaults {

            static let alarmIDSeed          = 100
            static let archiveLocation      = ArchiveMgr.StorageLocation.documentsDir.rawValue
            static let archiveType          = ArchiveMgr.StorageType.unencrypted.rawValue
        }
    }

    var storageLocation: ArchiveMgr.StorageLocation {

        get {

            if let locationString = self.object(forKey: Constants.Keys.archiveLocation) as? String {

                return ArchiveMgr.StorageLocation.fromString(location: locationString)
            }

            // default
            return ArchiveMgr.StorageLocation.fromString(location: "default")
        }

        set {

            let locationString = newValue.rawValue
            self.set(locationString, forKey: Constants.Keys.archiveLocation)
            self.synchronize()
        }
    }

    var storageType: ArchiveMgr.StorageType {

        get {

            if let typeString = self.object(forKey: Constants.Keys.archiveType) as? String {

                return ArchiveMgr.StorageType.fromString(type: typeString)
            }

            // default
            return ArchiveMgr.StorageType.fromString(type: "default")
        }

        set {

            let typeString = newValue.rawValue
            self.set(typeString, forKey: Constants.Keys.archiveType)
            self.synchronize()
        }
    }

    var nextAlarmID: Int {

        // default
        var nextID = Constants.Defaults.alarmIDSeed

        // check if saved value exists
        let key = Constants.Keys.currentAlarmID

        // return 0 if not found
        let currentValue = self.integer(forKey: key)
        if currentValue > 0 {

            // bump to next id value
            nextID = currentValue + 1
        }

        // save
        self.set(nextID, forKey: key)
        self.synchronize()

        return nextID
    }

    var alarms: [AlarmItem] {

        get {

            // load
            let key = Constants.Keys.alarmsUnencrypted
            guard let savedItems = self.array(forKey: key) as NSArray? else { return [] }
            return savedItems.convertDictsToAlarmItems()
        }

        set {

            let key = Constants.Keys.alarmsUnencrypted
            if newValue.count <= 0 {

                // remove
                self.removeObject(forKey: key)
            }
            else {

                // convert to NSArray
                let saveItems = newValue.convertAlarmItemsToNSArray()

                // save
                // note: verified in simulator at sandbox/Library/Preferences/com.cemico.PeelAlarm.plist
                self.set(saveItems, forKey: key)
            }

            // flush
            self.synchronize()
        }
    }

    var alarmsViaEncryption: [AlarmItem] {

        get {

            // load
            let key = Constants.Keys.alarmsEncrypted
            guard let encryptedData = self.data(forKey: key) else { return [] }
            guard let savedItems = NSKeyedUnarchiver.unarchiveObject(with: encryptedData) as? [AlarmItem] else { return [] }

            return savedItems
        }

        set {

            let key = Constants.Keys.alarmsEncrypted
            if newValue.count <= 0 {

                // remove
                self.removeObject(forKey: key)
            }
            else {

                // convert to encrypted data
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: newValue)

                // save
                // note: verified in simulator at sandbox/Library/Preferences/com.cemico.PeelAlarm.plist
                self.set(encodedData, forKey: key)
            }

            // flush
            self.synchronize()
        }
    }
}
