//
//  AlertItem.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

// note: NSObject used for NSKeyedArchiver
class AlarmItem: NSObject, NSCoding {

    //
    // in swift 4, enum is slightly cleaner than struct containing static string constants
    //

    enum Keys: String {

        // swift 4 nice, will auto-rawValue a String to match enum case
        // note: enums do not allow you to assign value from struct, only literals
        //       be sure to keep these enum names in sync with the constants K.AlarmItemKeys.*
        case id
        case version
        case date
        case name
        case isEnabled
        case soundName
        case soundValue
        case imageName
        case imageValue
        case videoName
        case videoValue

        static var all: [Keys] = [

            .id, .version, .date, .name, .isEnabled, .soundName, .soundValue, .imageName, .imageValue, .videoName, .videoValue
        ]

        func value(for alarm: AlarmItem) -> Any {

                // getter
            switch self {

                case .id:               return alarm.id
                case .version:          return alarm.version
                case .date:             return alarm.date
                case .name:             return alarm.name
                case .isEnabled:        return alarm.isEnabled
                case .soundName:        return alarm.soundName
                case .soundValue:       return alarm.soundValue
                case .imageName:        return alarm.imageName
                case .imageValue:       return alarm.imageValue
                case .videoName:        return alarm.videoName
                case .videoValue:       return alarm.videoValue
            }
        }
    }

    private enum Versions: String {

        struct Constants {

            // number of fractional digits supported
            static let versionPrecision = 2
        }

        // version the model to allow upgrade path if model changes in future
        case v1_00 = "1.00"

        // latest version
        static var currentVersion = Versions.v1_00
    }

    //
    // variables
    //

    var id: Int = 0
    var version = ""
    var date = Date()
    var isEnabled = false
    var name = ""
    var soundName = ""
    var soundValue = ""
    var imageName = ""
    var imageValue = ""
    var videoName = ""
    var videoValue = ""

    // computed properties
    var hour24: Int {

        var hour = hour12

        if !isAM {

            hour += 12
        }

        return hour
    }

    var hour12: Int {

        return date.hourMinuteIn12Hour.hour
    }

    var minute: Int {

        return date.hourMinuteIn12Hour.minute
    }

    var isAM: Bool {

        return date.hourMinuteIn12Hour.ampm == "AM"
    }

    //
    // NSCoding protocol
    //

    func encode(with aCoder: NSCoder) {

        //
        // used to encode / archive this alarm
        //

        // save
        for key in Keys.all {

            // coerce from Any into native types
            switch key {

                // int types
                case .id:
                    let value = Int.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)

                // string types
                case .version, .name, .soundName, .soundValue, .imageName, .imageValue, .videoName, .videoValue:
                    let value = String.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)

                // bool types
                case .isEnabled:
                    let value = Bool.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)

                // date types
                case .date:
                    let value = Date.from(any: key.value(for: self))
                    aCoder.encode(value, forKey: key.rawValue)
            }
        }
    }

    override init() {
        super.init()

        // used for convience inits
    }

    required init?(coder aDecoder: NSCoder) {

        //
        // used to restore / unarchive a previous alarm value which was archived / encoded
        //

        // ints
        id          = aDecoder.decodeInteger(forKey: Keys.id.rawValue)

        // strings
        version     = aDecoder.decodeObject(forKey: Keys.version.rawValue) as? String ?? ""
        name        = aDecoder.decodeObject(forKey: Keys.name.rawValue) as? String ?? ""
        soundName   = aDecoder.decodeObject(forKey: Keys.soundName.rawValue) as? String ?? ""
        soundValue  = aDecoder.decodeObject(forKey: Keys.soundValue.rawValue) as? String ?? ""
        imageName   = aDecoder.decodeObject(forKey: Keys.imageName.rawValue) as? String ?? ""
        imageValue  = aDecoder.decodeObject(forKey: Keys.imageValue.rawValue) as? String ?? ""
        videoName   = aDecoder.decodeObject(forKey: Keys.videoName.rawValue) as? String ?? ""
        videoValue  = aDecoder.decodeObject(forKey: Keys.videoValue.rawValue) as? String ?? ""

        // bools
        isEnabled   = aDecoder.decodeBool(forKey: Keys.isEnabled.rawValue)

        // dates
        date        = aDecoder.decodeObject(forKey: Keys.date.rawValue) as? Date ?? Date()

        super.init()

        // check for upgrade
        updateToCurrent()
    }

    convenience init(date: Date,
                     name: String,
                     isEnabled: Bool = true,
                     soundName: String = "",
                     soundValue: String = "",
                     imageName: String = "",
                     imageValue: String = "",
                     videoName: String = "",
                     videoValue: String = "") {
        self.init()

        //
        // used to create a new alarm, need to set unique id
        //

        self.id = UserDefaults.standard.nextAlarmID
        self.date = date
        self.name = name
        self.isEnabled = isEnabled
        self.soundName = soundName
        self.soundValue = soundValue
        self.imageName = imageName
        self.imageValue = imageValue
        self.videoName = videoName
        self.videoValue = videoValue

        // always use latest
        self.version = Versions.currentVersion.rawValue
    }

    convenience init(from dict: [String : Any]) {
        self.init()

        //
        // used to restore a previous alarm value stored in dictionary form
        //

        for (key, value) in dict {

            // set variables from dictionary values strongly typed
            switch key {

                // ints
                case Keys.id.rawValue:
                    id = Int.from(any: value)

                // strings
                case Keys.version.rawValue:
                    version = String.from(any: value, default: Versions.currentVersion.rawValue)

                case Keys.name.rawValue:
                    name = String.from(any: value)

                case Keys.soundName.rawValue:
                    soundName = String.from(any: value)
                case Keys.soundValue.rawValue:
                    soundValue = String.from(any: value)

                case Keys.imageName.rawValue:
                    imageName = String.from(any: value)

                case Keys.imageValue.rawValue:
                    imageValue = String.from(any: value)

                case Keys.videoName.rawValue:
                    videoName = String.from(any: value)

                case Keys.videoValue.rawValue:
                    videoValue = String.from(any: value)

                // bools
                case Keys.isEnabled.rawValue:
                    isEnabled = Bool.from(any: value)

                // dates
                case Keys.date.rawValue:
                    date = Date.from(any: value)

                default:
                    print("Unkown key: \(key)")
            }
        }
    }

    func toDict() -> [String : Any] {

        //
        // used to represent this alarm in dictionary format
        //

        var dict: [String : Any] = [:]

        // we have no nested classes - simple property iteration
        let selfMirror: Mirror = Mirror(reflecting: self)
        for child in selfMirror.children {

            if let propertyName = child.label {

                dict[propertyName] = child.value
            }
        }

        return dict
    }

    private func updateToCurrent() {

        // example versioning logic
        guard version != Versions.currentVersion.rawValue else {

            // same version - no upgrade
            return
        }

        // upgrade older version to current, could be actions at each version change
        if version == Versions.v1_00.rawValue {

            // upgrade from 1.00 to current

            // udpate version
            version = Versions.v1_00.rawValue
        }
    }
}
