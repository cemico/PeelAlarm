//
//  AddSoundData.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/22/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension AddSoundViewController {

    func updateData() -> [NameValueStringTuple] {

        // pull all the bundled sounds for *.caf
        let ext = "caf"
        let sounds = Bundle.main.resourceFiles(ofType: ext).sorted()

        // sounds have simple rule of value is same as name, simple map
        var soundTuples = sounds.map({ return (name: $0, value: $0 + ".caf") })

        // add default
        let defaultSound = NameValueStringTuple(name: K.KnownSounds.default, value: "")
        soundTuples.insert(defaultSound, at: 0)

        return soundTuples
    }
}
