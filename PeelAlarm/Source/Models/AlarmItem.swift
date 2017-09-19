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
        case id, version, date, name, isEnabled, sound, image, video

        static var all: [Keys] = [.id, .version, .date, .name, .isEnabled, .sound, .image, .video]

        func value(for alarm: AlarmItem) -> Any {

                // getter
            switch self {

                case .id:           return alarm.id
                case .version:      return alarm.version
                case .date:         return alarm.date
                case .name:         return alarm.name
                case .isEnabled:    return alarm.isEnabled
                case .sound:        return alarm.sound
                case .image:        return alarm.image
                case .video:        return alarm.video
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
    var sound = ""
    var image = ""
    var video = ""

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
                case .version, .name, .sound, .image, .video:
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
        sound       = aDecoder.decodeObject(forKey: Keys.sound.rawValue) as? String ?? ""
        image       = aDecoder.decodeObject(forKey: Keys.image.rawValue) as? String ?? ""
        video       = aDecoder.decodeObject(forKey: Keys.video.rawValue) as? String ?? ""

        // bools
        isEnabled   = aDecoder.decodeBool(forKey: Keys.isEnabled.rawValue)

        // dates
        date        = aDecoder.decodeObject(forKey: Keys.date.rawValue) as? Date ?? Date()

        super.init()

        // check for upgrade
        updateToCurrent()
    }

    convenience init(date: Date, name: String, isEnabled: Bool = true, sound: String = "", image: String = "", video: String = "") {
        self.init()

        //
        // used to create a new alarm, need to set unique id
        //

        self.id = UserDefaults.standard.nextAlarmID
        self.date = date
        self.name = name
        self.isEnabled = isEnabled
        self.sound = sound
        self.image = image
        self.video = video

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

                case Keys.sound.rawValue:
                    sound = String.from(any: value)

                case Keys.image.rawValue:
                    image = String.from(any: value)

                case Keys.video.rawValue:
                    video = String.from(any: value)

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
