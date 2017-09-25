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

    func updateData() -> [NameValueStringTuple] {

        // todo: iterate image assets, might have to convert to folder references
        return K.KnownImages.all
    }
}
