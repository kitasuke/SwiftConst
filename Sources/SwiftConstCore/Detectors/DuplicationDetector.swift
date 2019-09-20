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
    let minimumLength: Int
    let duplicationThreshold: Int
    let ignoreHidden: Bool
    let ignoreTest: Bool
    let ignorePaths: [String]
    let ignorePatterns: [String]
    
    public init(
        paths: [String],
        minimumLength: Int,
        duplicationThreshold: Int,
        ignoreHidden: Bool,
        ignoreTest: Bool,
        ignorePaths: [String],
        ignorePatterns: [String]
    ) {
        self.paths = paths
        self.minimumLength = minimumLength
        self.duplicationThreshold = duplicationThreshold
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
                var visitor = StringVisitor(
                    filePath: filePath,
                    minimumLength: minimumLength,
                    ignorePatterns: ignorePatterns,
                    syntax: syntax,
                    dataStore: dataStore
                )
                syntax.walk(&visitor)
                return dataStore.strings
            }
            .filteredDuplicatedStrings(with: duplicationThreshold)
    }
}

extension Array where Element == SwiftConstString {
    fileprivate func filteredDuplicatedStrings(with threshold: Int) -> [Element] {
        let sortedStrings = self.sorted(by: { $0.value < $1.value })
        
        var previousString = ""
        var duplicatedStrings: [SwiftConstString] = []
        for (index, string) in sortedStrings.enumerated() {
            guard previousString != string.value else {
                duplicatedStrings.append(string)
                continue
            }
            
            let duplicationCount = duplicatedStrings.filter({ $0.value == previousString }).count
            if duplicationCount < threshold {
                duplicatedStrings = duplicatedStrings.dropLast(duplicationCount)
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
