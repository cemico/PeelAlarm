//
//  NotificationViewController.swift
//  PeelAlarmContentExtension
//
//  Created by Dave Rogers on 9/19/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var detailsContainerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func didReceive(_ notification: UNNotification) {

        //
        // pre-processing before alert is shown
        //

        let alarmId = notification.request.identifier
        let content = notification.request.content
        let userInfo = content.userInfo
        let sound = userInfo["sound"] as? String ?? ""
        let image = userInfo["image"] as? String ?? ""
        let video = userInfo["video"] as? String ?? ""

        let msg = "Presenting User Alert \(alarmId): s: \(sound), i: \(image), v:\(video)"
        print(msg)

        // common gradient background
        let backColor = UIColor.black.withAlphaComponent(0.2)

        // crude random choice
        let fetchImageOnline = Int(Date().timeIntervalSince1970) % 2 == 0

        // image source
        let imageSource = fetchImageOnline ? "(Online)" : image

        // details
        var maxSize = CGFloat(0)
        [(idLabel,      "ID",       alarmId),
         (soundLabel,   "Sound",    sound),
         (imageLabel,   "Image",    imageSource),
         (videoLabel,   "Video",    video)].forEach({ (label, prefix, value) in

            label.text = "  \(prefix): \(value)  "
            label.sizeToFit()

            maxSize = max(maxSize, label.frame.size.width)
        })
        detailsContainerView.frame.size.width = maxSize
        detailsContainerView.backgroundColor = backColor

        // title
        titleLabel?.text = notification.request.content.title
        titleLabel?.backgroundColor = backColor

        // body
        bodyLabel?.text = notification.request.content.body
        bodyLabel.backgroundColor = backColor

        // image (local and online)
        if !fetchImageOnline {

            // use notification payload image name
            backgroundImageView.image = UIImage.init(named: image)
        }
        else {

            // test online image
            let imageURLs = [

                "https://i.ytimg.com/vi/qHej4ZqZDwo/hqdefault.jpg",
                "https://i.pinimg.com/originals/a4/be/bd/a4bebd8c782789bc1b631180004c7974.jpg"
            ]

            // example of pulling online
            let randomIndex = Int(Date().timeIntervalSince1970) % imageURLs.count
            let imageURL = imageURLs[randomIndex]
            if let url = URL(string: imageURL) {

                DispatchQueue.global().async {

                    if let data = try? Data(contentsOf: url) {

                        DispatchQueue.main.async { [unowned self] in

                            self.backgroundImageView.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
    }

#if FALSE
    func didReceive(_ response: UNNotificationResponse,
                    completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {

        // intercept the alert, potentially do the action w/o launching the app, directed by flag passed to completion
        // handler, .dismiss closes, .doNotDismiss leaves on screen, and .dismissAndForwardAction launches the app

        // handle custom actions from custom category(s) defined in info.plist which match the main app's custom categories
        if response.actionIdentifier == "Snooze 5m" {

            let oldRequest = response.notification.request
            let alarmId = oldRequest.identifier
            let identifiers = [alarmId]

            // remove current alert and any previously delivered alerts
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)

            // reschedule w/ snooze (note - just copied code over as a test from main app, should create
            // common modules, like my inclusion of Date_Utils into this target as shared module)
            let snoozeMinutes = 5 // Constants.snoozeMinutes

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
            let request = UNNotificationRequest(identifier: identifier, content: oldRequest.content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { (error: Error?) in

                if let error = error {

                    // inform caller
                    print("Unable to add schedule alert \(request.identifier): \(error.localizedDescription)")

                    DispatchQueue.main.async {

                        completion(.dismissAndForwardAction)
                    }
                }
                else {

                    // successful - no action
                    print("Scheduled alert \(request.identifier)")

                    // feedback
                    SoundMgr.sharedInstance.hapticFeedback(type: .notification(.success))

                    // end processing
                    DispatchQueue.main.async {

                        completion(.dismiss)
                    }
                }
            }
        }
        else {

            completion(.dismissAndForwardAction)
        }
    }
#endif
}
