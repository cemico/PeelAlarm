//
//  UIApplication_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension UIApplication {

    enum SettingsTargets {

        case allAppPermissions
    }

    static var rootVC = UIApplication.shared.keyWindow?.rootViewController

    func openSettings(in area: SettingsTargets) {

        var urlString = ""

        switch area {

            case .allAppPermissions:
                urlString = UIApplicationOpenSettingsURLString
        }

        if let url = URL(string: urlString) {

            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
