//
//  AlarmTableViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/16/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

///////////////////////////////////////////////////////////
// MARK: - Table Data Source
///////////////////////////////////////////////////////////

extension AlarmViewController: UITableViewDataSource {

    var isEmptyTable: Bool {

        return alarms.count <= 0
    }

    func configureTable() {

        // remove the dead lines when the display doesn't fill the screen
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
    }

    func reloadTable() {

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return max(1, alarms.count)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        // all rows can edit
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {

        // delete
        if editingStyle == .delete {

            // strong ref data point in question
            let alarm = alarms[indexPath.row]

            // action closure
            let deleteAction = { [unowned self] in

                // remove data item
                self.alarms.remove(at: indexPath.row)
                AlarmDataController.sharedInstance.removeAlarm(at: indexPath.row, broadcastChange: false)

                // update display
                tableView.deleteRows(at: [indexPath], with: .right)

                // remove from system notifications
                if alarm.isEnabled {

                    UserNotificationMgr.sharedInstance.deleteAction(requestId: "\(alarm.id)")
                }
            }

            if alarm.isEnabled {

                // enabled alarm - prompt user
                UIAlertController.showYesNo(vcHost: self, title: "Active Alarm", message: "This alarm will not fire if deleted, continue?", actionCallback: { (isYes: Bool) in

                    if isYes {

                        // delete alarm
                        deleteAction()
                    }
                })
            }
            else {

                // disabled - silent delete
                deleteAction()
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // no data cell
        if alarms.count <= 0 {

            return tableView.dequeueReusableCell(withIdentifier: AlarmNoDataTableViewCell.className, for: indexPath)
        }

        // valid data cell
        let cell = tableView.dequeueReusableCell(withIdentifier: AlarmTableViewCell.className, for: indexPath)

        if let cell = cell as? AlarmTableViewCell {

            // self update
            let alarm = alarms[indexPath.row]
            cell.updateAlarm(alarm)

            cell.onEnableDisble = { [unowned cell, unowned self] isEnabled in

                // track name color to enable state to match switch
                cell.updateEnabled(isEnabled)
                print("enable row:", indexPath.row, isEnabled)

                // udpate alarm state, locally and persistently
                let alarm = self.alarms[indexPath.row]
                alarm.isEnabled = isEnabled
                AlarmDataController.sharedInstance.alarms[indexPath.row].isEnabled = isEnabled
                _ = ArchiveMgr.sharedInstance.save()

                if isEnabled {

                    // state flopped - activate this alarm
                    UserNotificationMgr.sharedInstance.create(from: alarm, updateLocalCache: false, completion: nil)
                }
                else {

                    // deactivate alarm
                    UserNotificationMgr.sharedInstance.deleteAction(requestId: "\(alarm.id)")
                }
            }
        }

        return cell
    }
}

///////////////////////////////////////////////////////////
// MARK: - Table Delegate
///////////////////////////////////////////////////////////

extension AlarmViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if isEmptyTable {

            // no rows message
            var headerHeight = UIApplication.shared.statusBarFrame.size.height
            if let navVC = navigationController {

                headerHeight += navVC.navigationBar.frame.size.height
            }

            return tableView.frame.size.height - headerHeight
        }

        // default height
        return tableView.rowHeight
    }
}

///////////////////////////////////////////////////////////
// MARK: - Table Cells
///////////////////////////////////////////////////////////

class AlarmTableViewCell: UITableViewCell {

    // outlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var amPmLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var enableSwitch: UISwitch!

    // properties
    var time: String = "" {

        didSet {

            // trigger logic to auto-size the time/ampm to fit snug
            if let tl = timeLabel {

                // size width down to fit
                tl.text = time
                let size = CGSize(width: bounds.size.width, height: tl.frame.size.height)
                let newSize = tl.sizeThatFits(size)

                // update width so AM/PM snughs up next to it
                timeLabelWidthConstraint.constant = newSize.width
            }
        }
    }

    var amPm: String = "" {

        didSet {

            // convience pass-through
            amPmLabel?.text = amPm
        }
    }

    var name: String = "" {

        didSet {

            // convience pass-through
            nameLabel?.text = name
        }
    }

    // hook for closure callback
    var onEnableDisble: ((Bool) -> Void)?

    // overrides
    override func prepareForReuse() {
        super.prepareForReuse()

        onEnableDisble = nil
    }

    // actions
    @IBAction func switchValueChange(_ sender: UISwitch) {

        onEnableDisble?(sender.isOn)
    }

    // helpers
    func updateAlarm(_ alarm: AlarmItem) {

        time = String.format12HourTime(hour: alarm.hour12, minute: alarm.minute)
        amPm = alarm.isAM ? "AM" : "PM"
        if alarm.name.length <= 0 {

            // default name
            name = LocalizedStringKeys.AlertViewController().tableCellAlarmTitle
        }
        else {

            name = alarm.name
        }

        // enabled
        updateEnabled(alarm.isEnabled)
    }

    func updateEnabled(_ enabled: Bool) {

        // set switch state
        enableSwitch.isOn = enabled

        // update dynamic color
        let color = enabled ? enableSwitch.onTintColor : enableSwitch.backgroundColor
        nameLabel.textColor = color
    }
}

class AlarmNoDataTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        // hide line
        hideSeparator()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // restore - really no need, but good practice to restore state before reuse
        showSeparator()
    }
}
