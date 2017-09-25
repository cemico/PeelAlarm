//
//  AddAlarmButtonController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension AddAlarmViewController {
    
    ///////////////////////////////////////////////////////////
    // MARK: - Action handlers
    ///////////////////////////////////////////////////////////

    @IBAction func tapSave(_ sender: Any) {

        // be sure to close keyboard so that any input changes are saved
        self.view.endEditing(true)

        // notify listener
        let alarm = AlarmItem(date: currentTime,
                              name: currentName,
                              isEnabled: true,
                              soundName: currentSound.name,
                              soundValue: currentSound.value,
                              imageName: currentImage.name,
                              imageValue: currentImage.value,
                              videoName: currentVideo.name,
                              videoValue: currentVideo.value)
        print("alarm being scheduled:", alarm.description)
        delegate?.saveClicked(with: alarm) { [unowned self] (success: Bool) in

            if !success {

                UIAlertController.showOK(vcHost: self,
                                         title: "Alarm Scheduling",
                                         message: "Unable to schedule alarm",
                                         buttonAction: nil,
                                         actionCallback: nil)
            }
            else {

                // success - close modal
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
