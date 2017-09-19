//
//  AddAlarmPickerController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension AddAlarmViewController {

    @IBAction func pickerValueChanged(_ sender: UIDatePicker) {

        // save
        currentTime = sender.date

        // display
        let hma = sender.date.hourMinuteIn12Hour
        print(hma.formatted)
    }
}
