//
//  LocalizedStringKeys.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

struct LocalizedStringKeys {

    // strings specific to alert view controller
    struct AlertViewController {

        static let tableName = "alertTable"

        // table cell strings
        struct TableCells {

            static let alarmTitle = "table.cell.alarm"
        }

        //
        // accessor properties local to this struct
        //

        var tableCellAlarmTitle: String {

            // computed property getter
            return value(for: LocalizedStringKeys.AlertViewController.TableCells.alarmTitle)
        }

        //
        // helper functions
        //
        
        private func value(for key: String) -> String {

            let tableName = LocalizedStringKeys.AlertViewController.tableName
            return LocalizedStringKeys().value(for: key, tableName: tableName)
        }
    }

    private func value(for key: String, tableName: String) -> String {

        return NSLocalizedString(key, tableName: tableName, comment: "")
    }
}
