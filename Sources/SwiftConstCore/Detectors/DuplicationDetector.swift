//
//  DuplicationDetector.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax

public struct DuplicationDetector {
    
    let paths: [String]
    let ignoreHidden: Bool
    let ignoreTest: Bool
    let ignorePaths: [String]
    let ignorePatterns: [String]
    
    public init(paths: [String], ignoreHidden: Bool, ignoreTest: Bool, ignorePaths: [String], ignorePatterns: [String]) {
        self.paths = paths
        self.ignoreHidden = ignoreHidden
        self.ignoreTest = ignoreTest
        self.ignorePaths = ignorePaths
        self.ignorePatterns = ignorePatterns
    }
    
    public func detect() throws -> [SwiftConstString] {
        
        let sourceFilePathIterator = SourceFilePathIterator(
            paths: paths,
            ignoreHidden: ignoreHidden,
            ignoreTest: ignoreTest,
            ignorePaths: ignorePaths
        )

        return try sourceFilePathIterator
            .flatMap { filePath -> [SwiftConstString] in
                let parser = SourceFileParser(filePath: filePath)
                let syntax = try parser.parse()
                let dataStore = DataStore()
                var visitor = StringVisitor(filePath: filePath, ignorePatterns: ignorePatterns, syntax: syntax, dataStore: dataStore)
                syntax.walk(&visitor)
                return dataStore.strings
            }
            .filteredDuplicatedStrings()
    }
}

extension Array where Element == SwiftConstString {
    fileprivate func filteredDuplicatedStrings() -> [Element] {
        let sortedStrings = self.sorted(by: { $0.value < $1.value })
        
        var previousString = ""
        var duplicatedStrings: [SwiftConstString] = []
        for (index, string) in sortedStrings.enumerated() {
            guard previousString != string.value else {
                duplicatedStrings.append(string)
                continue
            }
            
            let nextIndex = index + 1
            guard nextIndex < sortedStrings.count - 1 else {
                break
            }
                        
            if string.value == sortedStrings[nextIndex].value {
                duplicatedStrings.append(string)
            }
            previousString = string.value
        }
        
        return duplicatedStrings
    }
}
