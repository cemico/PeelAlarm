//
//  AddAlarmProtocol.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

//
// define protocol to interact witih host
//

//
// note: class bound protocols are able to be declared as weak variables
//       since they will be assigned to reference / class objects, versus
//       structs and enums which are value based and do not allow weak
//       since they are copied versus referenced counted
//

///////////////////////////////////////////////////////////
// MARK: - Protocols
///////////////////////////////////////////////////////////

protocol AddAlarmProtocol: class {

    // optional
    func cancelClicked()

    // required
    func saveClicked(with alarm: AlarmItem, completionHandler: ((Bool) -> Void)?)
}

//
// unlike in ObjC, Optional functions are not an option, to overcome this, we define
// those "optional" functions as extension functions
//

///////////////////////////////////////////////////////////
// MARK: - Define Extensions
///////////////////////////////////////////////////////////

extension AddAlarmProtocol {

    // optional functions
    func cancelClicked() {

        // no-op
    }
}

///////////////////////////////////////////////////////////
// MARK: - Conform to Extensions
///////////////////////////////////////////////////////////

extension AddAlarmViewController: AddSoundProtocol {

    func saveSound(with value: String) {

        // save new selectioin
        currentSound = value
    }
}

extension AddAlarmViewController: AddImageProtocol {

    func saveImage(with value: String) {

        // save new selectioin
        currentImage = value
    }
}

extension AddAlarmViewController: AddVideoProtocol {

    func saveVideo(with value: String) {

        // save new selectioin
        currentVideo = value
    }
}
