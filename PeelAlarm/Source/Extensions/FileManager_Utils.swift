//
//  FileManager_Utils.swift
//  PeelAlarm
//
//  Created by Dave Rogers on 9/17/17.
//  Copyright © 2017 Cemico. All rights reserved.
//

import Foundation

extension FileManager {

    var docsDir: String? {

        return url(for: .documentDirectory)?.path
    }

    func fullDocsPath(for filename: String) -> String? {

        guard let docsDir = self.docsDir else { return nil }
        return docsDir.stringByAppendingPathComponent(path: filename)
    }

    func deleteFile(atPath: String) -> Bool {

        // no data, clear
        if self.fileExists(atPath: atPath) {

            if self.isDeletableFile(atPath: atPath) {

                // try to delete
                do {

                    try self.removeItem(atPath: atPath)

                    // successful
                    return true
                }
                catch {

                    // error
                    print(error.localizedDescription)
                    return false
                }
            }
            else {

                // file unable to delete
                return false
            }
        }

        // file doesn't exist
        return true
    }

    private func url(for directory: FileManager.SearchPathDirectory) -> URL? {

        // typical use: docs dir, cache dir, etc
        let fm = FileManager.default
        guard let searchURL = fm.urls(for: directory, in: .userDomainMask).first else { return nil }
//        print("sandbox url: ", searchURL.path)
        return searchURL
    }
}
