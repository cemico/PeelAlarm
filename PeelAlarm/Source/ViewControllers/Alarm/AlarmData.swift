//
//  AlarmData.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension AlarmViewController: AddAlarmProtocol {

    ///////////////////////////////////////////////////////////
    // MARK: - Data routines
    ///////////////////////////////////////////////////////////

    func reload(alarms: [AlarmItem]? = nil) {

        // clear out the old
        self.alarms = []

        // udpate data
        NSLock().synchronized { [unowned self] in

            if let argAlarms = alarms {

                // used argument alarms
                self.alarms = argAlarms
            }
            else {

                // pull from data controller
                self.alarms = AlarmDataController.sharedInstance.alarms
            }
        }

        // update display
        reloadTable()
    }

    func startListening() {

        // listen for data changes
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(alarmsUpdated(notification:)),
                                               name: .drAlarmsUpdated,
                                               object: nil)
    }

    func stopListening() {

        // stop listening
        NotificationCenter.default.removeObserver(self)
    }

    ///////////////////////////////////////////////////////////
    // MARK: - Notifications
    ///////////////////////////////////////////////////////////

    @objc func alarmsUpdated(notification: Notification) {

        // extract alarms
        guard let alarms = notification.userInfo?[Notification.Name.Keys.alarms] as? [AlarmItem] else { reload(); return }

        // refresh local data
        reload(alarms: alarms)
    }

    ///////////////////////////////////////////////////////////
    // MARK: - AddAlarmProtocol
    ///////////////////////////////////////////////////////////

    func saveClicked(with alarm: AlarmItem, completionHandler: ((Bool) -> Void)?) {

        print("\(#function)\n\(alarm.description)")

        // schedule this new alarm
        UserNotificationMgr.sharedInstance.create(from: alarm) { (success: Bool) in

            print("created new alarm:", success)
            if success {

            }

            // inform listener
            completionHandler?(success)
        }
    }
}
