//
//  AddSoundData.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/22/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension AddSoundViewController {

    func updateData() -> [String] {

        // pull all the bundled sounds for *.caf
        let ext = "caf"
        var sounds = Bundle.main.resourceFiles(ofType: ext).sorted()

        // add default
        sounds.insert(K.KnownSounds.default, at: 0)

        return sounds
    }
}
