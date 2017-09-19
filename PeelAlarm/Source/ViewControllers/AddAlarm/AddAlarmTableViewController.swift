//
//  AddAlarmTableViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

///////////////////////////////////////////////////////////
// MARK: - Table Data Source / Delegate
///////////////////////////////////////////////////////////

extension AddAlarmViewController: UITableViewDataSource {

    enum TableRows: Int {

        // provide table row order
        case title  = 0
        case sound, image, video

        static var all = [TableRows.title, .sound, .image, .video]

        static func fromInt(row: Int) -> TableRows {

            switch (row) {

                case TableRows.video.rawValue:      return .video
                case TableRows.image.rawValue:      return .image
                case TableRows.sound.rawValue:      return .sound

                case TableRows.title.rawValue:      fallthrough
                default:                            return .title
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return TableRows.all.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == TableRows.title.rawValue {

            // name/title row
            let cell = tableView.dequeueReusableCell(withIdentifier: AddAlarmTitleTableViewCell.className, for: indexPath)
            if let cell = cell as? AddAlarmTitleTableViewCell {

                // color the full background
                cell.contentView.superview?.backgroundColor = cell.bkgndView.backgroundColor
            }
            return cell
        }
        else if indexPath.row == TableRows.sound.rawValue {

            // sound
            let cell = tableView.dequeueReusableCell(withIdentifier: AddAlarmSoundTableViewCell.className, for: indexPath)
            if let cell = cell as? AddAlarmSoundTableViewCell {

                // color the full background
                cell.soundLabel.text = currentSound
                cell.contentView.superview?.backgroundColor = cell.bkgndView.backgroundColor
            }
            return cell
        }
        else if indexPath.row == TableRows.image.rawValue {

            // image
            let cell = tableView.dequeueReusableCell(withIdentifier: AddAlarmImageTableViewCell.className, for: indexPath)
            if let cell = cell as? AddAlarmImageTableViewCell {

                // color the full background
                cell.imageLabel.text = currentImage
                cell.contentView.superview?.backgroundColor = cell.bkgndView.backgroundColor
            }
            return cell
        }
        else if indexPath.row == TableRows.video.rawValue {

            // video
            let cell = tableView.dequeueReusableCell(withIdentifier: AddAlarmVideoTableViewCell.className, for: indexPath)
            if let cell = cell as? AddAlarmVideoTableViewCell {

                // color the full background
                cell.videoLabel.text = currentVideo
                cell.contentView.superview?.backgroundColor = cell.bkgndView.backgroundColor
            }
            return cell
        }

        assert(false, "unhandled row #\(indexPath.row)")
    }
}

extension AddAlarmViewController: UITableViewDelegate {

    private struct SegueIdentifiers {

        static let showSounds   = "showSounds"
        static let showImages   = "showImages"
        static let showVideos   = "showVideos"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // make sure keyboard dismisses if up
        self.view.endEditing(true)
//        if let cell = tableView.cellForRow(at: IndexPath(row: TableRows.title.rawValue, section: 0)) as? AddAlarmTitleTableViewCell {
//
//            cell.dismissKeyboard()
//        }
        print("selected row", indexPath.row)

        // want entire row to trigger segue - programmatically
        if indexPath.row == TableRows.sound.rawValue {

            // sounds
            performSegue(withIdentifier: SegueIdentifiers.showSounds, sender: nil)
        }
        else if indexPath.row == TableRows.image.rawValue {

            // images
            performSegue(withIdentifier: SegueIdentifiers.showImages, sender: nil)
        }
        else if indexPath.row == TableRows.video.rawValue {

            // videos
            performSegue(withIdentifier: SegueIdentifiers.showVideos, sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let id = segue.identifier else { return }

        if id == SegueIdentifiers.showSounds {

            // sounds
            if let vc = segue.destination as? AddSoundViewController {

                // set model for vc
                vc.currentSound = currentSound

                // wire for listening
                vc.delegate = self
            }
        }
        else if id == SegueIdentifiers.showImages {

            // images
            if let vc = segue.destination as? AddImageViewController {

                // set model for vc
                vc.currentImage = currentImage

                // wire for listening
                vc.delegate = self
            }
        }
        else if id == SegueIdentifiers.showVideos {

            // videos
            if let vc = segue.destination as? AddVideoViewController {

                // set model for vc
                vc.currentVideo = currentVideo

                // wire for listening
                vc.delegate = self
            }
        }
    }
}

///////////////////////////////////////////////////////////
// MARK: - Table Helpers
///////////////////////////////////////////////////////////

extension AddAlarmViewController {

    func update(at row: TableRows) {

        let indexPath = IndexPath(row: row.rawValue, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

///////////////////////////////////////////////////////////
// MARK: - Table Cells
///////////////////////////////////////////////////////////

class AddAlarmTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bkgndView: UIView!

    func dismissKeyboard() {

        titleTextField.resignFirstResponder()
    }
}

class AddAlarmSoundTableViewCell: UITableViewCell {

    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var bkgndView: UIView!

}

class AddAlarmImageTableViewCell: UITableViewCell {

    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var bkgndView: UIView!

}

class AddAlarmVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var bkgndView: UIView!

}
