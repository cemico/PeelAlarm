//
//  AddAlarmTextFieldController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension AddAlarmViewController: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {

        guard let text = textField.text else { return }

        if text != currentName {

            // udpate
            currentName = text
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        // kill the keyboard on return
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        // close keyboard when click around
        self.view.endEditing(true)
    }
}
