//
//  AddImageData.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/24/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation
import UIKit

extension AddImageViewController {

    func updateData() -> [String] {

        return [

            // todo: iterate image assets, might have to convert to folder references
            "Smiley-Happy",
            "Smiley-Mad",
            "Smiley-Sad",
            "Smiley-Serious",
            "Smiley-Curious",
            "Smiley-Frustrated"
        ]
    }
}
