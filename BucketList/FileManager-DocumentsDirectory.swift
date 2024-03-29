//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by enesozmus on 29.03.2024.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
