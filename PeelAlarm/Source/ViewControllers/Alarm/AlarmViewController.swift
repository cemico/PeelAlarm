//
//  AlarmViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/16/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

class AlarmViewController: UIViewController {

    private struct Constants {

        static let segueAddAlarm    = "showAddAlarm"
        static let segueSaveAdd     = "saveAdd"
        static let segueCancelAdd   = "cancelAdd"
    }

    ///////////////////////////////////////////////////////////
    // MARK: - Outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var settingsBarButton: UIBarButtonItem!

    ///////////////////////////////////////////////////////////
    // MARK: - Variables
    ///////////////////////////////////////////////////////////

    lazy var alarms: [AlarmItem] = {

        // always init with the latest
        return AlarmDataController.sharedInstance.alarms
    }()

    ///////////////////////////////////////////////////////////
    // MARK: - System overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        // table customizations
        configureTable()

        // todo - implement settings
//        settingsBarButton.isEnabled = false

        // start listening for changes - keep data in sync even when modal is above us
        startListening()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // update table
        reloadTable()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // stop any editing
        tableView.isEditing = false
    }

    deinit {

        // stop listening for changes
        stopListening()
    }

    ///////////////////////////////////////////////////////////
    // MARK: - Segues
    ///////////////////////////////////////////////////////////

    @IBAction func unwindToHome(segue: UIStoryboardSegue) {

        guard let id = segue.identifier else { return }
        print(id)

        if id == Constants.segueSaveAdd {

            if let destVC = segue.source.vc as? AddAlarmViewController {

                // note: if unwind segue was wired as action,
                // could extract the data from the add view controller,
                // but we have delegate setup - use that.  if unwind
                // is set, tap action doesn't occur
                
                print(destVC.description)
            }
        }
        else if id == Constants.segueCancelAdd {

            if let destVC = segue.source.vc as? AddAlarmViewController {

                // cancelled out of adding an alarm, perform any tidy work
                print("cancelled from add: \(destVC)")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let id = segue.identifier else { return }
//        print(id)

        if id == Constants.segueAddAlarm {

            // wire in ourselves as delegate
            if let destVC = segue.destination.vc as? AddAlarmViewController {

                // add alarm vc
                destVC.delegate = self
            }
        }
    }
}

