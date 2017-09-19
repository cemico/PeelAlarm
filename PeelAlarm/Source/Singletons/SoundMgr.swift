//
//  SoundMgr.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/19/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation
import UIKit

class SoundMgr {
    
    ///////////////////////////////////////////////////////////
    // enums
    ///////////////////////////////////////////////////////////

    enum HapticFeedbackLevels {

        case light, medium, heavy
    }

    enum HapticNotificationLevels {

        case success, warning, failure
    }

    enum HapticSelectionLevels {

        case tick
    }

    enum HapticTypes {

        case feedback(HapticFeedbackLevels)
        case notification(HapticNotificationLevels)
        case selection(HapticSelectionLevels)
    }


    ///////////////////////////////////////////////////////////
    // data members
    ///////////////////////////////////////////////////////////

    // setup singleton
    static let sharedInstance = SoundMgr()

    ///////////////////////////////////////////////////////////
    // lifecycle
    ///////////////////////////////////////////////////////////

    private init() {

        // ensure one invoke by having initializer private
        print("SoundMgr Init")
    }

    ///////////////////////////////////////////////////////////
    // actions
    ///////////////////////////////////////////////////////////

    func hapticFeedback(type: HapticTypes) {

        if #available(iOS 10.0, *) {

            // iOS 10+ only
            let feedbackGenerator = UISelectionFeedbackGenerator()
            feedbackGenerator.selectionChanged()
        }

        switch type {

            case .feedback(let level):

                switch level {

                    case .light:            UIImpactFeedbackGenerator(style: .light).impactOccurred()

                    case .medium:           UIImpactFeedbackGenerator(style: .medium).impactOccurred()

                    case .heavy:            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                }

            case .notification(let level):

                switch level {

                    case .success:          UINotificationFeedbackGenerator().notificationOccurred(.success)

                    case .warning:          UINotificationFeedbackGenerator().notificationOccurred(.warning)

                    case .failure:          UINotificationFeedbackGenerator().notificationOccurred(.error)
                }

            case .selection(let level):

                switch level {

                    case .tick:             UISelectionFeedbackGenerator().selectionChanged()
                }
        }
    }
}
