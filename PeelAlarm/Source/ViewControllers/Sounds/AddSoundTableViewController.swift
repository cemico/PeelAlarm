//
//  AddSoundTableViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

///////////////////////////////////////////////////////////
// MARK: - Table Delegate
///////////////////////////////////////////////////////////

extension AddSoundViewController {

    func configureTable() {

        // remove the dead lines when the display doesn't fill the screen
        tableView.removeUnusedBottomRowsWithTableFooter()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return sounds.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if sounds.count <= 0 {

            // no rows message
            var headerHeight = UIApplication.shared.statusBarFrame.size.height
            if let navVC = navigationController {

                headerHeight += navVC.navigationBar.frame.size.height
            }

            return tableView.frame.size.height - headerHeight
        }

        // normal height
        return tableView.rowHeight
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // no data cell
        if sounds.count <= 0 {

            return tableView.dequeueReusableCell(withIdentifier: SoundsNoDataTableViewCell.className, for: indexPath)
        }

        // valid data cell
        let cell = tableView.dequeueReusableCell(withIdentifier: SoundsTableViewCell.className, for: indexPath)

        if let cell = cell as? SoundsTableViewCell {

            // self update
            let sound = sounds[indexPath.row]
            cell.update(sound: sound, selectedSound: currentSound)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // deselect
        super.tableView.deselectRow(at: indexPath, animated: false)

        // udpate data
        currentSound = sounds[indexPath.row]
        tableView.reloadData()
    }
}

///////////////////////////////////////////////////////////
// MARK: - Table Cells
///////////////////////////////////////////////////////////

class SoundsTableViewCell: UITableViewCell {

    struct Constants {

        static let selectedImage   = "circle-checkmark-on"
        static let deselectedImage = "circle-checkmark-off"
    }

    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func update(sound: String, selectedSound: String) {

        soundLabel.text = sound

        let isSelected = (sound == selectedSound)
        let image = (isSelected ? K.CheckmarkImage.on : K.CheckmarkImage.off)
        checkmarkImageView.image = UIImage(named: image)

        if #available(iOS 11.0, *) {

            let colorName = (isSelected ? K.Colors.selectionName : K.Colors.defaultTextName)
            soundLabel.textColor = UIColor.init(named: colorName)
        }
        else {

            soundLabel.textColor = (isSelected ? K.Colors.selectionColor : K.Colors.defaultTextColor)
        }

        // on image is setup as templated image, so can track selection color
        checkmarkImageView.tintColor = soundLabel.textColor
    }
}

class SoundsNoDataTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()

        // hide line
        hideSeparator()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        // restore - really no need, but good practice to restore state before reuse
        showSeparator()
    }
}
