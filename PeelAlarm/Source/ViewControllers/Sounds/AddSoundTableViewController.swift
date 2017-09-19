//
//  AddSoundTableViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

///////////////////////////////////////////////////////////
// MARK: - Table Delegate
///////////////////////////////////////////////////////////

extension AddSoundViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        // no rows message
        var headerHeight = UIApplication.shared.statusBarFrame.size.height
        if let navVC = navigationController {

            headerHeight += navVC.navigationBar.frame.size.height
        }

        return tableView.frame.size.height - headerHeight
    }
}

