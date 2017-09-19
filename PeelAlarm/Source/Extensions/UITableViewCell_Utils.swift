//
//  UITableViewCell_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension UITableViewCell {

    func hideSeparator() {

        // push right beyond view
        self.separatorInset = UIEdgeInsets(top: 0, left: self.frame.size.width, bottom: 0, right: 0)
    }

    func showSeparator() {

        // restore full
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
