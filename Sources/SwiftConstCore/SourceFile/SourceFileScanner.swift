//
//  SourceFileScanner.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/02/19.
//

import Foundation
import Files

public class SourceFileScanner {
    
    public let files: [File]
    
    public init(pathString: String) {
        if let file = try? File(path: pathString) {
            files = [file].filter { $0.isSwiftExtension }
        } else if let folder = try? Folder(path: pathString) {
            files = folder.makeFileSequence(recursive: true, includeHidden: false).filter { $0.isSwiftExtension }
        } else {
            files = []
        }
    }
}

extension FileSystem.Item {
    var isSwiftExtension: Bool {
        return self.extension == "swift"
    }
}
