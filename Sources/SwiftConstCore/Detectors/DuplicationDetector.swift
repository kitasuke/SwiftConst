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
        var duplicatedStrings: [Element] = []
        for string in sortedStrings {
            // if there is already same string in duplicatedStrings, append it immidiately
            guard !duplicatedStrings.contains(where: { $0.value == string.value }) else {
                duplicatedStrings.append(string)
                continue
            }
            
            // if there is no same string in the array, but same string from previous one,
            // that means duplication count was less than threshold, so let's skip
            guard string.value != previousString else {
                continue
            }
            
            // check if duplication count is eaqual or greater than threshold
            let duplicationCount = sortedStrings.filter { $0.value == string.value }.count
            if duplicationCount >= threshold {
                duplicatedStrings.append(string)
            }
            previousString = string.value
        }
        return duplicatedStrings
    }
}
