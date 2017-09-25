//
//  Constants.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/22/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation
import UIKit

typealias NameValueStringTuple = (name: String, value: String)

struct K {

    struct BundleNamespaces {

        static let images           = "AlertImages"
    }

    struct KnownSounds {

        static let `default`        = "Default"
    }

    struct KnownImages {

        static let smileyHappy      = "Smiley-Happy"
        static let smileyMad        = "Smiley-Mad"
        static let smileySad        = "Smiley-Sad"
        static let smileySerious    = "Smiley-Serious"
        static let smileyCurious    = "Smiley-Curious"
        static let smileyFrustrated = "Smiley-Frustrated"

        struct Names {

            static let smileyHappy      = "Smiley Happy"
            static let smileyMad        = "Smiley Mad"
            static let smileySad        = "Smiley Sad"
            static let smileySerious    = "Smiley Serious"
            static let smileyCurious    = "Smiley Curious"
            static let smileyFrustrated = "Smiley Frustrated"
        }

        static let all = [

            NameValueStringTuple(name: Names.smileyHappy,       value: smileyHappy),
            NameValueStringTuple(name: Names.smileyMad,         value: smileyMad),
            NameValueStringTuple(name: Names.smileySad,         value: smileySad),
            NameValueStringTuple(name: Names.smileySerious,     value: smileySerious),
            NameValueStringTuple(name: Names.smileyCurious,     value: smileyCurious),
            NameValueStringTuple(name: Names.smileyFrustrated,  value: smileyFrustrated)
        ]
    }

    struct Defaults {

        static let noneDefault      = NameValueStringTuple(name: "none", value: "")
        static let soundDefault     = NameValueStringTuple(name: KnownSounds.default, value: "")
        static let imageDefault     = NameValueStringTuple(name: KnownImages.Names.smileyHappy, value: KnownImages.smileyHappy)
        static let videoDefault     = noneDefault
    }

    struct Colors {

        static let defaultTextName  = "defaultText"
        static let defaultTextColor = UIColor.black

        static let selectionName    = "selection"
        static let selectionColor   = UIColor.blue
    }

    struct CheckmarkImage {

        static let on               = "circle-checkmark-on"
        static let off              = "circle-checkmark-off"
    }

    struct AlarmItemKeys {

        static let id           = "id"
        static let version      = "version"
        static let date         = "date"
        static let name         = "name"
        static let isEnabled    = "isEnabled"
        static let soundName    = "soundName"
        static let soundValue   = "soundValue"
        static let imageName    = "imageName"
        static let imageValue   = "imageValue"
        static let videoName    = "videoName"
        static let videoValue   = "videoValue"
    }
}
