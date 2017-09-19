//
//  AlarmDataController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

class AlarmDataController {

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // setup singleton
    static let sharedInstance = AlarmDataController()

    // conditional to broadcast change
    var broadcastAlarmsUpdate = true

    // alarm data
    var _alarms: [AlarmItem] = [] {

        didSet {

            if broadcastAlarmsUpdate {

                broadcastUpdate()
            }
        }
    }

    var alarms: [AlarmItem] {

        // public interface: read-only / no setter
        return _alarms
    }

    ///////////////////////////////////////////////////////////
    // lifecycle
    ///////////////////////////////////////////////////////////

    private init() {

        // ensure one invoke by having initializer private
        print("AlarmDataController Init")

        // retrieve current alarms
    }

    ///////////////////////////////////////////////////////////
    // actions
    ///////////////////////////////////////////////////////////

    func broadcastUpdate() {

        // inform others that data has changed
        let userInfo = [ Notification.Name.Keys.alarms : _alarms ]
        DispatchQueue.main.async {

            // updates on background - notification on main as display updates will fillow
            NotificationCenter.default.post(name: .drAlarmsUpdated, object: nil, userInfo: userInfo)
        }
    }

    func alarmsFiltered(by isEnabled: Bool) -> [AlarmItem] {

        return alarms.filter({ $0.isEnabled == isEnabled })
    }

    func addAlarm(alarm: AlarmItem) {

        // copy, add, order, update
        var alarms = _alarms
        alarms.append(alarm)
        alarms.sort(by: { $0.date < $1.date })
        updateAlarms(alarms: alarms)
    }

    func updateAlarm(by id: String, isEnabled: Bool) {

        if let intId = Int(id), let alarm = alarms.filter({ $0.id == intId }).first {

            if alarm.isEnabled != isEnabled {

                alarm.isEnabled = isEnabled

                // broadcast
                broadcastUpdate()
            }
        }
    }

    func updateAlarms(alarms: [AlarmItem]) {

        // safe update
        NSLock().synchronized { [unowned self] in

            self._alarms = alarms
        }
    }

    func removeAlarm(at index: Int, broadcastChange: Bool = false) {

        guard index < alarms.count else { return }

        // safe update
        NSLock().synchronized { [unowned self] in

            // thread-safe closure, conditionally broadcast udpate
            // could also create our own dispatch serial queue and sync execute to maintain thread safety
            let oldValue = self.broadcastAlarmsUpdate
            self.broadcastAlarmsUpdate = broadcastChange

            // remove item, will call didSet
            self._alarms.remove(at: index)

            // restore original value
            self.broadcastAlarmsUpdate = oldValue

            // save changes
            _ = ArchiveMgr.sharedInstance.save(alarms: alarms)
        }
    }

    ///////////////////////////////////////////////////////////
    // helpers
    ///////////////////////////////////////////////////////////

    private func clear() {

        NSLock().synchronized { [unowned self] in

            self._alarms = []
        }
    }
}
