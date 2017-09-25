//
//  AddImageTableViewController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

import UIKit

///////////////////////////////////////////////////////////
// MARK: - Table Delegate
///////////////////////////////////////////////////////////

extension AddImageViewController {

    struct Sections {

        static let one = "Local Images"
        static let two = "Online Images"
    }

    func configureTable() {

        // remove the dead lines when the display doesn't fill the screen
        tableView.removeUnusedBottomRowsWithTableFooter()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {

        // first section for locally bunded images
        // second section for online search image query urls
//        return 2
        return 1
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        switch section {

            case 0:     return Sections.one
            default:    return nil
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return images.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if images.count <= 0 {

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
        if images.count <= 0 {

            return tableView.dequeueReusableCell(withIdentifier: ImagesNoDataTableViewCell.className, for: indexPath)
        }

        // valid data cell
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesTableViewCell.className, for: indexPath)

        if let cell = cell as? ImagesTableViewCell {

            // self update
            let image = images[indexPath.row]
            cell.update(imageData: image, selectedImage: currentImage.name)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // deselect
        super.tableView.deselectRow(at: indexPath, animated: false)

        // udpate data
        currentImage = images[indexPath.row]
        tableView.reloadData()
    }
}

///////////////////////////////////////////////////////////
// MARK: - Table Cells
///////////////////////////////////////////////////////////

class ImagesTableViewCell: UITableViewCell {

    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var checkmarkImageView: UIImageView!
    @IBOutlet weak var pictureImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        pictureImageView.image = nil
    }

    func update(imageData: NameValueStringTuple, selectedImage: String) {

        imageLabel.text = imageData.name

        let isSelected = (imageData.name == selectedImage)
        let image = (isSelected ? K.CheckmarkImage.on : K.CheckmarkImage.off)
        checkmarkImageView.image = UIImage(named: image)

        if #available(iOS 11.0, *) {

            let colorName = (isSelected ? K.Colors.selectionName : K.Colors.defaultTextName)
            imageLabel.textColor = UIColor.init(named: colorName)
        }
        else {

            imageLabel.textColor = (isSelected ? K.Colors.selectionColor : K.Colors.defaultTextColor)
        }

        let imageName = imageData.value
        pictureImageView.image = UIImage.alertImageFor(imageName: imageName)
    }
}

class ImagesNoDataTableViewCell: UITableViewCell {

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
