//
//  UserNotificationMgr.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

class UserNotificationMgr {

    ///////////////////////////////////////////////////////////
    // enums / structs
    ///////////////////////////////////////////////////////////

    struct Constants {

        static let snoozeMinutes = 5
    }

    enum ActionIdentifiers: String {

        case snooze = "Snooze 5m"
        case stop   = "Stop"
    }

    enum CategoryIdentifiers: String {

        case alarm = "Alarm"
    }

    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // setup singleton
    static let sharedInstance = UserNotificationMgr()

    ///////////////////////////////////////////////////////////
    // lifecycle
    ///////////////////////////////////////////////////////////

    private init() {

        // ensure one invoke by having initializer private
        print("UserNotificationMgr Init")

        // retrieve current alarms
    }

    ///////////////////////////////////////////////////////////
    // actions
    ///////////////////////////////////////////////////////////

    func registerCategories() {

        // actions
        let snoozeAction = UNNotificationAction(identifier: ActionIdentifiers.snooze.rawValue,
                                                title: ActionIdentifiers.snooze.rawValue,
                                                options: [.foreground])
        let stopAction = UNNotificationAction(identifier: ActionIdentifiers.stop.rawValue,
                                              title: ActionIdentifiers.stop.rawValue,
                                              options: [.foreground])

        // alarm category - associate our actions for this category
        let alarmCategory = UNNotificationCategory(identifier: CategoryIdentifiers.alarm.rawValue,
                                                   actions: [snoozeAction, stopAction],
                                                   intentIdentifiers: [],
                                                   options: [])

        // register - allows custom options for our alerts
        UNUserNotificationCenter.current().setNotificationCategories([alarmCategory])
    }

    func create(from alarm: AlarmItem, updateLocalCache: Bool = true, completion: ((Bool) -> Void)?) {

        // setup notification appearance
        let content = UNMutableNotificationContent()

        // content
        content.title = "Peel Alarm"
        if alarm.name.isEmpty {

            // use default
            content.body = LocalizedStringKeys.AlertViewController().tableCellAlarmTitle
        }
        else {

            // user defined name
            content.body = alarm.name
        }

        if alarm.soundName == K.KnownSounds.default {

            content.sound = UNNotificationSound.default()
        }
        else {

            content.sound = UNNotificationSound(named: alarm.soundValue)
        }
        content.categoryIdentifier = CategoryIdentifiers.alarm.rawValue

        // note: one more value for sound/image/video, switch from simple string to item specific dictionaries
        content.userInfo = [

            // user enhancements
            AlarmItem.Keys.soundName.rawValue : alarm.soundName,
            AlarmItem.Keys.soundValue.rawValue : alarm.soundValue,
            AlarmItem.Keys.imageName.rawValue : alarm.imageName,
            AlarmItem.Keys.imageValue.rawValue : alarm.imageValue,
            AlarmItem.Keys.videoName.rawValue : alarm.videoName,
            AlarmItem.Keys.videoValue.rawValue : alarm.videoValue
        ]

        // trigger
        var dateComponents = DateComponents()
        dateComponents.hour = alarm.hour24
        dateComponents.minute = alarm.minute

        // repeats == false, schedule once, == true, auto-reschedule repeatedly (daily repeat)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // use our unique alarm id as the request id
        let identifier = "\(alarm.id)"

        // create and add request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // add to system notifications
        addRequest(request: request, updateLocalCache: updateLocalCache, alarm: alarm, completion: completion)
    }

    func getAllRegisteredNotifications(completion: @escaping ([UNNotificationRequest]) -> ()) {

        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in

            requests.forEach({ print("registered:", $0.identifier) })

            completion(requests)
        }
    }

    func getRegisteredNotification(for identifier: String, completion: @escaping (UNNotificationRequest?) -> ()) {

        // get all registered requests
        getAllRegisteredNotifications() { (requests: [UNNotificationRequest]) in

            DispatchQueue.main.async {

                let request = requests.filter { $0.identifier == identifier }.first
                completion(request)
            }
        }
    }

    func deleteAction(response: UNNotificationResponse) {

        print("stop action")

        // stop action
        let request = response.notification.request
        let alarmId = request.identifier

        // remove from both system and local list
        deleteAction(requestId: alarmId)
    }

    func deleteAction(requestId: String, updateLocalCache: Bool = true) {

        // common delete routine from app->notification and notification->app

        // remove from registered notifications
        // options are removeAllDelivered, removeAllPending, removeSetDelivered, removeSetPending
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [requestId])

        if updateLocalCache {

            // disable this alarm id our saved list
            AlarmDataController.sharedInstance.updateAlarm(by: requestId, isEnabled: false)

            // save
            _ = ArchiveMgr.sharedInstance.save()
        }

        // feedback
        SoundMgr.sharedInstance.hapticFeedback(type: .notification(.success))
    }

    func snoozeAction(response: UNNotificationResponse) {

        print("snooze action")

        // end the current alarm, set new one for x min
        let oldRequest = response.notification.request
        let alarmId = oldRequest.identifier

        // remove from *only* system
        deleteAction(requestId: alarmId, updateLocalCache: false)

        // use same content
        let content = oldRequest.content

        // could setup in creation and saved in userInfo and used here
        let snoozeMinutes = Constants.snoozeMinutes

        // trigger
        let nowDate = Date()
        let now = nowDate.hourMinuteIn24Hour
        var dateComponents = DateComponents()
        dateComponents.hour = now.hour
        dateComponents.minute = now.minute + snoozeMinutes

        // repeats == false, schedule once, == true, auto-reschedule repeatedly (daily repeat)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // use our unique alarm id as the request id
        let identifier = "\(alarmId)"

        // create and add request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // add to system notifications
        addRequest(request: request, updateLocalCache: false) { success in

            DispatchQueue.main.async {

                // rootViewController always accessed on main thread
                if success, let vcHost = UIApplication.rootVC {

                    let newTime = nowDate.addingTimeInterval(TimeInterval(60 * Constants.snoozeMinutes)).hourMinuteIn12Hour.formatted
                    let message = "Snoozed \(Constants.snoozeMinutes)m until \(newTime)"
                    print(message)
                    UIAlertController.showOK(vcHost: vcHost,
                                             title: "Alarm Rescheduled",
                                             message: message,
                                             buttonAction: nil,
                                             actionCallback: nil)
                }
            }
        }
    }

    private func addRequest(request: UNNotificationRequest, updateLocalCache: Bool, alarm: AlarmItem? = nil, completion: ((Bool) -> Void)? = nil) {

        UNUserNotificationCenter.current().add(request) { (error: Error?) in

            if let error = error {

                // inform caller
                print("Unable to add schedule alert \(request.identifier): \(error.localizedDescription)")
                completion?(false)
            }
            else {

                // successful - no action
                print("Scheduled alert \(request.identifier)")

                if updateLocalCache, let alarm = alarm {

                    // update list
                    AlarmDataController.sharedInstance.addAlarm(alarm: alarm)

                    // save
                    _ = ArchiveMgr.sharedInstance.save()
                }

                // inform caller
                completion?(true)

                // feedback
                SoundMgr.sharedInstance.hapticFeedback(type: .notification(.success))
            }
        }
    }

    func defaultAction(response: UNNotificationResponse) {

        print("default action - user right swiped all way or enough to click open, or clicked on the alert, or swiped left and hit view")
    }

    func dismissAction(response: UNNotificationResponse) {

        print("dismiss action - user swiped to dismiss")
    }

    func syncAlarmsToRegisteredNotificationStates(alarms: [AlarmItem], completion: @escaping ([AlarmItem]) -> Void) {

        print("sync'n registered notifications with stored local alarms")
        
        // get all registered notifications
        getAllRegisteredNotifications() { (requests: [UNNotificationRequest]) in

            // disable all items, then enable any matching items
            alarms.forEach({ $0.isEnabled = false })

            // spin through registered items and enable
            for request in requests {

                if let id = Int(request.identifier),
                    let alarm = alarms.filter({ $0.id == id }).first{

                    // enable
                    alarm.isEnabled = true
                }
                else {

                    print("stranded active alarm: \(request.identifier)")
                }
            }

            // save accurate state
            _ = ArchiveMgr.sharedInstance.save(alarms: alarms)

            // all done
            completion(alarms)
        }
    }

    func clearAll(includeDataController: Bool) {

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("removed all pending notifications")
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("removed all delivered notifications")

        if includeDataController {

            AlarmDataController.sharedInstance.updateAlarms(alarms: [])
            print("cleared local cache")
            _ = ArchiveMgr.sharedInstance.save()
            print("saved local cache")
        }
    }
}
