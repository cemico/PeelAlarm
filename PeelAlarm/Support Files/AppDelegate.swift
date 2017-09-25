//
//  AppDelegate.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/16/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // flag to check once-per foregrounding
    var hasCheckedForUserNotificationPermission = false

    // permission to show notifications
    var hasUserNotificationPermission = false {

        didSet {

            if hasUserNotificationPermission {

                // user has permissions - restore previous data
                DispatchQueue.global(qos: .background).async {

                    // generic read based on settings for location and encryption
                    let alarms = ArchiveMgr.sharedInstance.read()
                    print("Alarms read:", alarms.count)

                    if alarms.count > 0 {

                        // we have data, need to pull the current scheduled alarms
                        // and sync them to the read alarms before updating display
                        UserNotificationMgr.sharedInstance.syncAlarmsToRegisteredNotificationStates(alarms: alarms, completion: { alarms in

                            // save and update display
                            AlarmDataController.sharedInstance.updateAlarms(alarms: alarms)
                        })
                    }
                }
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // will be displaying alerts via user notifications - check permissions to do so
        userNotificationCheck()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

        // be sure to check for permissions at every foregrounding ... reset flag
        hasCheckedForUserNotificationPermission = false

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {

        // check each foregrounding, unless first launch
        if !hasCheckedForUserNotificationPermission {

            userNotificationCheck()
        }

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    func userNotificationCheck() {

        // set off at run and on each backgrounding
        // which forces check on first launch / foreground, and each foregrounding thereafter
        hasCheckedForUserNotificationPermission = true

        // wire ourselves for button action notifications
        // note: must be set during didFinishLaunchingWithOptions
        UNUserNotificationCenter.current().delegate = self

        // request permission [badge, sound, alert, capPlay] (prompt once, cache response, update via settings)
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { [unowned self] granted, error in

            // save - keys off data loading if successful
            self.hasUserNotificationPermission = granted
            print("User Notifications granted:", granted)

            if !granted {

                // inform user off current run loop cycle (and use of rootViewController can only be done on main thread)
                DispatchQueue.main.async {

                    guard let vcRoot = self.window?.rootViewController else { return }

                    let settingsButton = UIAlertAction(title: "Settings", style: .default) { (action) in

                        // open settings direct to notifications
                        UIApplication.shared.openSettings(in: .allAppPermissions)
                    }

                    UIAlertController.showOK(vcHost: vcRoot, title: "Notification Persmission", message: "In order for the Alarms to alert you, Notification permission is needed.  Update Settings to allow permission", buttonAction: settingsButton, actionCallback: nil)
                }
            }
        }

        // create categories
        UserNotificationMgr.sharedInstance.registerCategories()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        // presenting - called when app in foreground, previous to iOS10
        // framework didn't allow chaining the notification to system, but now it does
        let alarmId = notification.request.identifier
        let content = notification.request.content
        let userInfo = content.userInfo
        let soundName = userInfo[AlarmItem.Keys.soundName.rawValue] as? String ?? ""
        let soundValue = userInfo[AlarmItem.Keys.soundValue.rawValue] as? String ?? ""
        let imageName = userInfo[AlarmItem.Keys.imageName.rawValue] as? String ?? ""
        let imageValue = userInfo[AlarmItem.Keys.imageValue.rawValue] as? String ?? ""
        let videoName = userInfo[AlarmItem.Keys.videoName.rawValue] as? String ?? ""
        let videoValue = userInfo[AlarmItem.Keys.videoValue.rawValue] as? String ?? ""
        print("Presenting User Alert \(alarmId): s: \(soundName) / \(soundValue), i: \(imageName) / \(imageValue), v:\(videoName) / \(videoValue)")

        // pass alert to system w/ presentation type(s) [alert, badge, sound]
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {

        // alert id
        let alarmId = response.actionIdentifier

        // get custom info
        let userInfo = response.notification.request.content.userInfo
        let soundName = userInfo[AlarmItem.Keys.soundName.rawValue] as? String ?? ""
        let soundValue = userInfo[AlarmItem.Keys.soundValue.rawValue] as? String ?? ""
        let imageName = userInfo[AlarmItem.Keys.imageName.rawValue] as? String ?? ""
        let imageValue = userInfo[AlarmItem.Keys.imageValue.rawValue] as? String ?? ""
        let videoName = userInfo[AlarmItem.Keys.videoName.rawValue] as? String ?? ""
        let videoValue = userInfo[AlarmItem.Keys.videoValue.rawValue] as? String ?? ""
        print("Received User Alert \(alarmId): s: \(soundName) / \(soundValue), i: \(imageName) / \(imageValue), v:\(videoName) / \(videoValue)")

        // receiving - check if user response matches any of our registered actions
        switch alarmId {

            // custom action: stop
            case UserNotificationMgr.ActionIdentifiers.stop.rawValue:
                UserNotificationMgr.sharedInstance.deleteAction(response: response)

            // custom action: snooze
            case UserNotificationMgr.ActionIdentifiers.snooze.rawValue:
                UserNotificationMgr.sharedInstance.snoozeAction(response: response)

            // standard: default action: app opened from notification
            // apple docs: lets you know that the user launched
            //             your app without selecting a custom action
            case UNNotificationDefaultActionIdentifier:
                UserNotificationMgr.sharedInstance.defaultAction(response: response)

            // standard: dismiss action: notification was dismissed by user
            // apple docs: lets you know that the user explicitly dismissed the
            //             notification interface without selecting a custom action
            case UNNotificationDismissActionIdentifier:
                UserNotificationMgr.sharedInstance.dismissAction(response: response)

            default:
                print("unknown action id: \(alarmId)")
        }

        // chain along
        completionHandler()
    }
}
