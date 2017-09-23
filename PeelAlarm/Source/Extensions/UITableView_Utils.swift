//
//  UITableView_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/22/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension UITableView {

    func removeUnusedBottomRowsWithTableFooter() {
        
        // remove the dead lines when the display doesn't fill the screen
        self.tableFooterView = UIView.init(frame: CGRect.zero)
    }
}
