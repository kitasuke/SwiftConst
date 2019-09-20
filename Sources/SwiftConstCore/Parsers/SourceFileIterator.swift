//
//  SourceFilePathIterator.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 9/16/19.
//

import Foundation

public struct SourceFilePathIterator: Sequence, IteratorProtocol {
    
    public let paths: [String]
    public let ignoreHidden: Bool
    public let ignoreTest: Bool
    public let ignorePaths: [String]
    private var currentDirectory = ""
    private var pathIterator: Array<String>.Iterator
    private var directoryIterator: FileManager.DirectoryEnumerator?

    public init(
        paths: [String],
        ignoreHidden: Bool = true,
        ignoreTest: Bool = true,
        ignorePaths: [String] = []
    ) {
        self.paths = paths
        self.ignoreHidden = ignoreHidden
        self.ignoreTest = ignoreTest
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
                
                if FileManager.default.isDirectory(atPath: nextPath) {
                    setDirectoryIterator(of: nextPath)
                } else {
                    guard isValidPath(for: nextPath) else {
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
                setDirectoryIterator(of: path)
            }
        }
        
        while path == nil {
            guard let pathInDirectory = directoryIterator?.nextObject() as? String else {
                break
            }
            
            let filePath = absolutePath(for: pathInDirectory)
            guard isValidPath(for: filePath, pathInDirectory: pathInDirectory) &&
                FileManager.default.isFile(atPath: filePath) else {
                continue
            }

            path = filePath
        }
        return path
    }
    
    private func absolutePath(for path: String) -> String {
        return [currentDirectory, "/", path].joined()
    }
    
    private func isValidPath(for path: String, pathInDirectory: String? = nil) -> Bool {
        // file should be .swift, not file or directory in hidden or ignored folders
        guard path.hasSuffix(".swift"),
            !(ignoreTest && path.contains("Tests")) else {
            return false
        }
        
        if let pathInDirectory = pathInDirectory {
            let isValidHidden = ignoreHidden ? !pathInDirectory.hasPrefix(".") : true
            let isValidPaths = ignorePaths.isEmpty ? true : !ignorePaths.contains(where: { path.hasPrefix($0) })
            return isValidHidden && isValidPaths
        } else {
            return true
        }
    }
    
    private mutating func setDirectoryIterator(of path: String?) {
        if let path = path {
            directoryIterator = FileManager.default.enumerator(atPath: path)
            currentDirectory = path
        } else {
            directoryIterator = nil
            currentDirectory = ""
        }
    }
}

extension FileManager {
    fileprivate func isFile(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) &&
            !isDirectory.boolValue
    }
    
    fileprivate func isDirectory(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) &&
            isDirectory.boolValue
    }
}
