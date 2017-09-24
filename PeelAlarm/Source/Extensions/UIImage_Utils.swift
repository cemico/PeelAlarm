//
//  UIImage_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/24/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension UIImage {

    class func alertImageFor(imageName: String) -> UIImage? {

        // use the image asset bundle namespace
        return UIImage(named: "\(K.BundleNamespaces.images)/\(imageName)")
    }
}
