//
//  UIViewController_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension UIViewController {

    // helper to return either the visible vc of a nav, or if not a nav, the vc itself
    var vc: UIViewController {

        if let nav = self as? UINavigationController,
            let visibleVC = nav.visibleViewController {

            return visibleVC
        }

        return self
    }
}
