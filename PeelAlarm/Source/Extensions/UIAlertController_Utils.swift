//
//  UIAlertController_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension UIAlertController {

    class func showOK(vcHost: UIViewController, title: String, message: String, buttonAction: UIAlertAction?, actionCallback: (() -> Void)?) {

        let okAction = UIAlertAction(title: "OK", style: .default) { action in

            // ok
            actionCallback?()
        }

        var actions = [okAction]

        // optional action (front button)
        if let action = buttonAction {

            actions.insert(action, at: 0)
        }

        // show
        UIAlertController.showAlert(vcHost: vcHost, title: title, message: message, buttonActions: actions)
    }

    class func showYesNo(vcHost: UIViewController, title: String, message: String, actionCallback: @escaping ((Bool) -> Void)) {

        let yesAction = UIAlertAction(title: "Yes", style: .default) { action in

            // yes
            actionCallback(true)
        }

        let noAction = UIAlertAction(title: "No", style: .default) { action in

            // no
            actionCallback(false)
        }

        // show
        UIAlertController.showAlert(vcHost: vcHost, title: title, message: message, buttonActions: [yesAction, noAction])
    }

    private class func showAlert(vcHost: UIViewController, title: String, message: String, buttonActions: [UIAlertAction]) {

        // main controller
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        // add each action / handler
        for action in buttonActions {

            alert.addAction(action)
        }

        // show
        vcHost.present(alert, animated: true, completion: nil)
    }
}
