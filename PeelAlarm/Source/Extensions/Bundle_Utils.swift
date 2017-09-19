//
//  Bundle_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/18/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension Bundle {

    func resourceFiles(ofType ext: String) -> [String] {

        let fm = FileManager.default
        let url = Bundle.main.bundleURL
        if let resources = try? fm.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: [.skipsHiddenFiles]) {

            // filter on *.ext files, map url array to string filenames
            return resources.filter({ $0.pathExtension == ext }).map({ return $0.deletingPathExtension().lastPathComponent })
        }

        return []
    }
}
