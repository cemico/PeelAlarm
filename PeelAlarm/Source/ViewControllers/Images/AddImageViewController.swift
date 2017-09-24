//
//  AddImageViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

class AddImageViewController: UITableViewController {

    ///////////////////////////////////////////////////////////
    // MARK: - Outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet weak var saveButton: UIBarButtonItem!

    ///////////////////////////////////////////////////////////
    // MARK: - Variables
    ///////////////////////////////////////////////////////////

    // no retain cycles here on access to the parent from this child
    weak var delegate: AddImageProtocol?

    // model
    var currentImage: String = "" {

        didSet {

            if originalImage == nil {

                // always have valid original image
                originalImage = currentImage
            }

            // update display

            // update save state
            saveButton?.isEnabled = (originalImage! != currentImage)
        }
    }

    // used for save enabling (used nil so can distinguish from empty string as valid current value)
    var originalImage: String? = nil

    // data source
    var images: [String] = []

    ///////////////////////////////////////////////////////////
    // MARK: - System overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()

        // table customizations
        configureTable()

        // load the data
        images = updateData()

        // update the display
        tableView.reloadData()
    }
}
