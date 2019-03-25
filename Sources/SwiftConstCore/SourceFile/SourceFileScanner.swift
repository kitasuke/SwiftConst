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
    
    public init(pathString: String, ignorePaths: [String]) {
        let allFiles: [File]
        if let file = try? File(path: pathString) {
            allFiles = [file]
        } else if let folder = try? Folder(path: pathString) {
            allFiles = folder.makeFileSequence(recursive: true, includeHidden: false).map { $0 }
        } else {
            allFiles = []
        }
        
        files = allFiles.filter { file in
            return file.isSwiftExtension &&
                !ignorePaths.contains(where: { file.path.contains($0) })
        }
    }
}

private extension FileSystem.Item {
    var isSwiftExtension: Bool {
        return self.extension == "swift"
    }
}
