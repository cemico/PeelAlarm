//
//  AddImageProtocol.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

///////////////////////////////////////////////////////////
// MARK: - Protocols
///////////////////////////////////////////////////////////

protocol AddImageProtocol: class {

    // required
    func saveImage(with value: NameValueStringTuple)
}
