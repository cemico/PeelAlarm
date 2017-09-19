//
//  AddVideoViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

class AddVideoViewController: UITableViewController {

    ///////////////////////////////////////////////////////////
    // MARK: - Outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet weak var saveButton: UIBarButtonItem!

    ///////////////////////////////////////////////////////////
    // MARK: - Variables
    ///////////////////////////////////////////////////////////

    // no retain cycles here on access to the parent from this child
    weak var delegate: AddVideoProtocol?

    // model
    var currentVideo: String = "" {

        didSet {

            if originalVideo == nil {

                // always have valid original image
                originalVideo = currentVideo
            }

            // update display

            // update save state
            saveButton?.isEnabled = (originalVideo! != currentVideo)
        }
    }

    // used for save enabling (used nil so can distinguish from empty string as valid current value)
    var originalVideo: String? = nil

    ///////////////////////////////////////////////////////////
    // MARK: - System overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        // simulate new selection
//        currentVideo = "Ocean"
    }
}

