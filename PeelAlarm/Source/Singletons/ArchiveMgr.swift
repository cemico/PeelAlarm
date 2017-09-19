//
//  ArchiveMgr.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

class ArchiveMgr {

    ///////////////////////////////////////////////////////////
    // constants
    ///////////////////////////////////////////////////////////

    struct Constants {

        static let archivePlistFileName  = "alarms.plist"
    }

    ///////////////////////////////////////////////////////////
    // enums
    ///////////////////////////////////////////////////////////

    enum StorageLocation: String {

        // user preferences, sandbox/Library/Preferences/com.cemico.PeelAlarm.plist
        case userPreferences

        // sandbox docs dir, sandbox/Documents/alarms.plist
        case documentsDir

        static func fromString(location: String) -> StorageLocation {

            switch location {

                case StorageLocation.userPreferences.rawValue:
                    return .userPreferences

                // default
                case StorageLocation.documentsDir.rawValue:     fallthrough
                default:
                    return .documentsDir
            }
        }
    }

    enum StorageType: String {

        // use nscoding to encrypt
        case encrypted

        // save as dictionary
        case unencrypted

        static func fromString(type: String) -> StorageType {

            switch type {

                case StorageType.encrypted.rawValue:
                    return .encrypted

                // default
                case StorageType.unencrypted.rawValue:      fallthrough
                default:
                    return .unencrypted
            }
        }
    }

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // setup singleton
    static let sharedInstance = ArchiveMgr()

    ///////////////////////////////////////////////////////////
    // lifecycle
    ///////////////////////////////////////////////////////////

    private init() {

        // ensure one invoke by having initializer private
        print("ArchiveMgr Init")
    }

    ///////////////////////////////////////////////////////////
    // actions
    ///////////////////////////////////////////////////////////

    func read(at location: StorageLocation = UserDefaults.standard.storageLocation,
              with type: StorageType = UserDefaults.standard.storageType) -> [AlarmItem] {

        // get archiver
        let archiver = getArchiver(at: location, with: type)

        // save
        return archiver.read()
    }

    func save(alarms: [AlarmItem] = AlarmDataController.sharedInstance.alarms,
              at location: StorageLocation = UserDefaults.standard.storageLocation,
              with type: StorageType = UserDefaults.standard.storageType) -> Bool {

        // get archiver
        let archiver = getArchiver(at: location, with: type)

        // save
        return archiver.save(alarms: alarms)
    }

    ///////////////////////////////////////////////////////////
    // helpers
    ///////////////////////////////////////////////////////////

    private func getArchiver(at location: StorageLocation, with type: StorageType) -> AlarmArchiver {

        // virtual class hierarchy allowing multiple types of archive types
        switch location {

            // supported archiving means
            case .documentsDir:

                switch type {

                case .encrypted:
                    // docs encrypted archiver
                    return DocsDirEncryptedArchiver()

                case .unencrypted:
                    // docs unencrypted archiver
                    return DocsDirUnencryptedArchiver()
                }

            case .userPreferences:

                switch type {

                case .encrypted:
                    // prefs encrypted archiver
                    return PrefsEncryptedArchiver()

                case .unencrypted:
                    // prefs unencrypted archiver
                    return PrefsUnencryptedArchiver()
                }
        }
    }
}

///////////////////////////////////////////////////////////
// MARK: - Archive vehicles
///////////////////////////////////////////////////////////

// base class
class AlarmArchiver {

    func read() -> [AlarmItem] { return [] }
    func save(alarms: [AlarmItem]) -> Bool { return true }
}

///////////////////////////////////////////////////////////
// MARK: - User Preference archives
///////////////////////////////////////////////////////////

// prefs unencrypted
class PrefsUnencryptedArchiver: AlarmArchiver {

    override func read() -> [AlarmItem] {

        // read data
        return UserDefaults.standard.alarms
    }

    override func save(alarms: [AlarmItem]) -> Bool {

        // save
        UserDefaults.standard.alarms = alarms
        return (UserDefaults.standard.alarms.count == alarms.count)
    }
}

// prefs encrypted
class PrefsEncryptedArchiver: AlarmArchiver {

    override func read() -> [AlarmItem] {

        // read data
        return UserDefaults.standard.alarmsViaEncryption
    }

    override func save(alarms: [AlarmItem]) -> Bool {

        // save
        UserDefaults.standard.alarmsViaEncryption = alarms
        return (UserDefaults.standard.alarmsViaEncryption.count == alarms.count)
    }
}

///////////////////////////////////////////////////////////
// MARK: - Docs dir archives
///////////////////////////////////////////////////////////

class DocsDirArchiver: AlarmArchiver {

    var filePath: String? {

        // get target path
        let fm = FileManager.default
        let fileName = ArchiveMgr.Constants.archivePlistFileName
        return fm.fullDocsPath(for: fileName)
    }
}

// docs unencrypted
class DocsDirUnencryptedArchiver: DocsDirArchiver {

    override func read() -> [AlarmItem] {

        // get target path
        let fm = FileManager.default
        guard let filePath = filePath else { return [] }
//        print(filePath)

        // read data
        guard fm.fileExists(atPath: filePath) else { return [] }

        // NSArray
        guard let savedItems = NSArray.init(contentsOfFile: filePath) else { return [] }

        // convert to alarm item array
        return savedItems.convertDictsToAlarmItems()
    }

    override func save(alarms: [AlarmItem]) -> Bool {

        // get target path
        let fm = FileManager.default
        guard let filePath = filePath else { return false }
//        print(filePath)

        // check data
        if alarms.count <= 0 {

            // no data, clear
            return fm.deleteFile(atPath: filePath)
        }

        // gather data in unencrypted dict format
        let saveItems = alarms.convertAlarmItemsToNSArray()

        // save
        print("saving \(saveItems.count) items")
        return saveItems.write(toFile: filePath, atomically: true)
    }
}

// docs encrypted
class DocsDirEncryptedArchiver: DocsDirArchiver {

    override func read() -> [AlarmItem] {

        // get target path
        let fm = FileManager.default
        guard let filePath = filePath else { return [] }
//        print(filePath)

        // read data
        guard fm.fileExists(atPath: filePath) else { return [] }

        // decrypt
        if let savedItems = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [AlarmItem] {

            // success
            return savedItems
        }

        // no items stored
        return []


#if WRITE_TO_KEY_INSTEAD_OF_ROOT
        let url = URL(fileURLWithPath: filePath)
        let data = try! Data(contentsOf: url)

        // decrypt the data
        let key = UserDefaults.Constants.Keys.alarmsEncrypted
        let unarchiver = NSKeyedUnarchiver(forReadingWith: data)

        // multiple exits - be sure to close unarchiver
        defer {

            unarchiver.finishDecoding()
        }

        if let savedItems = unarchiver.decodeObject(forKey: key) as? [AlarmItem] {

            // success
            return savedItems
        }

        // no items stored
        return []
#endif
    }

    override func save(alarms: [AlarmItem]) -> Bool {

        // get target path
        let fm = FileManager.default
        guard let filePath = filePath else { return false }
//        print(filePath)

        // check data
        if alarms.count <= 0 {

            // no data, clear
            return fm.deleteFile(atPath: filePath)
        }

        let data = NSKeyedArchiver.archivedData(withRootObject: alarms)
        do {

            let url = URL(fileURLWithPath: filePath)
            try data.write(to: url, options: .atomic)
            return true
        }
        catch {

            return false
        }

#if WRITE_TO_KEY_INSTEAD_OF_ROOT
        // convert to encrypted data
        let key = UserDefaults.Constants.Keys.alarmsEncrypted
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)

        // could store in own file wil .archiveRootObject(alarms, toFile: filePath),
        // but to mirror the user defaults, store as key in plist, nearly no overhead
        archiver.encode(alarms, forKey: key)
        archiver.finishEncoding()
        return data.write(toFile: filePath, atomically: true)
#endif
    }
}
