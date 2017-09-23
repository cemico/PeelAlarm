//
//  AddSoundViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

class AddSoundViewController: UITableViewController {

    ///////////////////////////////////////////////////////////
    // MARK: - Outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet weak var saveButton: UIBarButtonItem!

    ///////////////////////////////////////////////////////////
    // MARK: - Variables
    ///////////////////////////////////////////////////////////

    // no retain cycles here on access to the parent from this child
    weak var delegate: AddSoundProtocol?

    // model
    var currentSound: String = "" {

        didSet {

            if originalSound == nil {

                // always have valid original image
                originalSound = currentSound
            }

            // update display

            // update save state
            saveButton?.isEnabled = (originalSound! != currentSound)
        }
    }

    // used for save enabling (used nil so can distinguish from empty string as valid current value)
    var originalSound: String? = nil

    var sounds: [String] = []

    ///////////////////////////////////////////////////////////
    // MARK: - System overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        // table customizations
        configureTable()

        // load the data
        sounds = updateData()

        // update the display
        tableView.reloadData()
    }
}
