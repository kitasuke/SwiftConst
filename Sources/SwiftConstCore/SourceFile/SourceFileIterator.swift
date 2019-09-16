//
//  SourceFileIterator.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 9/16/19.
//

import Foundation

public struct SourceFileIterator: Sequence, IteratorProtocol {
    
    public let paths: [String]
    public let ignoreHidden: Bool
    public let ignorePaths: [String]
    var currentDirectory = ""
    var pathIterator: Array<String>.Iterator
    var directoryIterator: FileManager.DirectoryEnumerator?

    public init(paths: [String], ignoreHidden: Bool = true, ignorePaths: [String] = []) {
        self.paths = paths
        self.ignoreHidden = ignoreHidden
        self.ignorePaths = ignorePaths
        self.pathIterator = paths.makeIterator()
    }

    public mutating func next() -> String? {
        var path: String?
        while path == nil {
            if directoryIterator != nil {
                path = nextInDirectory()
            } else {
                guard let nextPath = pathIterator.next() else {
                    return nil
                }
                
                var isDirectory: ObjCBool = false
                if FileManager.default.fileExists(atPath: nextPath, isDirectory: &isDirectory) &&
                    isDirectory.boolValue {
                    directoryIterator = FileManager.default.enumerator(atPath: nextPath)
                    currentDirectory = nextPath
                } else {
                    guard isValidPath(nextPath) else {
                        continue
                    }
                    path = nextPath
                }
            }
        }
        return path
    }
    
    private mutating func nextInDirectory() -> String? {
        var path: String?
        defer {
            if path == nil {
                directoryIterator = nil
            }
        }
        
        while path == nil {
            guard let pathInDirectory = directoryIterator?.nextObject() as? String else {
                break
            }
            
            let filePath = absolutePath(for: pathInDirectory)
            var isDirectory: ObjCBool = false
            guard isValidPath(filePath, pathInDirectory: pathInDirectory) &&
                FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory) &&
                !isDirectory.boolValue else {
                continue
            }

            path = filePath
        }
        return path
    }
    
    private func absolutePath(for path: String) -> String {
        return [currentDirectory, "/", path].joined()
    }
    
    private func isValidPath(_ path: String, pathInDirectory: String? = nil) -> Bool {
        // file should be .swift, not file or directory in hidden or ignored folders
        guard path.hasSuffix(".swift") else {
            return false
        }
        
        if let pathInDirectory = pathInDirectory {
            return !(ignoreHidden && pathInDirectory.hasPrefix(".")) &&
            !ignorePaths.contains(where: { path.hasPrefix($0) })
        } else {
            return true
        }
    }
}
