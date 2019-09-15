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
    
    public init(paths: [String], ignorePaths: [String]) {
        
        var allFiles: [File] = []
        
        for path in paths {
            if let file = try? File(path: path) {
                allFiles.append(file)
            } else if let folder = try? Folder(path: path) {
                let filesInFolder = folder.makeFileSequence(recursive: true, includeHidden: false)
                    .filter { file in
                        return file.isSwiftExtension &&
                            !ignorePaths.contains(where: { file.path.contains($0) })
                    }
                    .map { $0 }
                allFiles.append(contentsOf: filesInFolder)
            }
        }
        
        files = allFiles
    }
}

private extension FileSystem.Item {
    var isSwiftExtension: Bool {
        return self.extension == "swift"
    }
}
