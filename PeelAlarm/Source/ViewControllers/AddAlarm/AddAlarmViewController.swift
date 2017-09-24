//
//  AddAlarmViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

class AddAlarmViewController: UIViewController {

    ///////////////////////////////////////////////////////////
    // MARK: - Outlets
    ///////////////////////////////////////////////////////////

    @IBOutlet weak var tableView: UITableView!

    ///////////////////////////////////////////////////////////
    // MARK: - Variables
    ///////////////////////////////////////////////////////////

    // no retain cycles here on access to the parent from this child
    weak var delegate: AddAlarmProtocol?

    // current selections - set outside current vc, thus udpate to table
    var currentSound = K.KnownSounds.default    { didSet { update(at: .sound) } }
    var currentImage = "Smiley-Happy"           { didSet { update(at: .image) } }
    var currentVideo = "Rooster"                { didSet { update(at: .video) } }

    // current selections - set on this vc
    var currentName = LocalizedStringKeys.AlertViewController().tableCellAlarmTitle
    var currentTime = Date()
    
    ///////////////////////////////////////////////////////////
    // MARK: - System overrides
    ///////////////////////////////////////////////////////////

    override func viewDidLoad() {
        super.viewDidLoad()


//        // pull random sound
//        let randomIndex = Int(Date().timeIntervalSince1970) % sounds.count
//        currentSound = sounds[randomIndex]
    }
}
