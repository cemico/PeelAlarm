//
//  NSObject_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/16/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import UIKit

extension NSObject {

    public var className: String {

        return type(of: self).className
    }

    public static var className: String {
        
        return String(describing: self)
    }
}

