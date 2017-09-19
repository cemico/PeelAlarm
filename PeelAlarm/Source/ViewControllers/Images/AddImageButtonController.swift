//
//  AddImageButtonController.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension AddImageViewController {

    ///////////////////////////////////////////////////////////
    // MARK: - Action handlers
    ///////////////////////////////////////////////////////////

    @IBAction func tapSave(_ sender: Any) {

        // inform listener of save request
        delegate?.saveImage(with: currentImage)

        // close with typical nav transition
        navigationController?.popViewController(animated:true)
    }
}

