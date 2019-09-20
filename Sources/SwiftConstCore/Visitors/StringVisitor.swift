//
//  StringVisitor.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax

public struct StringVisitor: SyntaxVisitor {
    
    let filePath: String
    let minimumLength: Int
    let ignorePatterns: [String]
    let syntax: SourceFileSyntax
    var dataStore: DataStoreType
    
    public init(
        filePath: String,
        minimumLength: Int,
        ignorePatterns: [String],
        syntax: SourceFileSyntax,
        dataStore: DataStoreType
    ) {
        self.filePath = filePath
        self.minimumLength = minimumLength
        self.ignorePatterns = ignorePatterns
        self.syntax = syntax
        self.dataStore = dataStore
    }
    
    // Ignore string interpolated literal because it's too complex to compare
    public mutating func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        guard node.segments.count == 1 else {
            return .skipChildren
        }
        return .visitChildren
    }

    public mutating func visit(_ node: StringSegmentSyntax) -> SyntaxVisitorContinueKind {
        let value = node.content.text
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty,
            value.count >= minimumLength else {
            return .skipChildren
        }
        
        do {
            let defaultIgnorePatterns = ["%[.0-9]{2}d|f|hhx", "%@"]
            let patterns = ignorePatterns.isEmpty ? defaultIgnorePatterns : defaultIgnorePatterns + ignorePatterns
            let range = NSRange(location: 0, length: value.count)
            let regex = try NSRegularExpression(pattern: patterns.joined(separator: "|"))
            guard regex.firstMatch(in: value, options: [], range: range) == nil else {
                return .skipChildren
            }
        } catch let error {
            assertionFailure(error.localizedDescription)
        }
        let sourceRange = node.sourceRange(
            converter: SourceLocationConverter(
                file: filePath,
                tree: syntax
            )
        )
        let string = SwiftConstString(
            filePath: filePath,
            value: value,
            line: sourceRange.start.line ?? 0,
            column: sourceRange.start.column ?? 0
        )
        dataStore.strings.append(string)
        
        return .skipChildren
    }
}
