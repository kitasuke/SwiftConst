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
    let syntax: SourceFileSyntax
    var dataStore: DataStoreType
    
    public init(filePath: String, syntax: SourceFileSyntax, dataStore: DataStoreType) {
        self.filePath = filePath
        self.syntax = syntax
        self.dataStore = dataStore
    }

    public mutating func visit(_ node: StringSegmentSyntax) -> SyntaxVisitorContinueKind {
        let value = node.content.text
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else {
            return .skipChildren
        }
        
        let sourceRange = node.sourceRange(converter: SourceLocationConverter(file: filePath, tree: syntax))
        let stringLiteral = FileString(value: value, line: sourceRange.start.line ?? 0, column: sourceRange.start.column ?? 0)
        dataStore.fileStrings.append(stringLiteral)
        
        return .skipChildren
    }
    
    public mutating func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        // ignore empty string. e.g. "\"foo\"" or "\"\"\"\n   bar\"\"\""
        // TODO: "\"" is unexpectedly ignored for now
        let value = node.stringLiteral.text
            .trimmingCharacters(in: CharacterSet(charactersIn: "\"").union(.whitespacesAndNewlines))
        guard !value.isEmpty else {
            return .skipChildren
        }
        
        let sourceRange = node.sourceRange(converter: SourceLocationConverter(file: filePath, tree: syntax))
        let stringLiteral = FileString(value: value, line: sourceRange.start.line ?? 0, column: sourceRange.start.column ?? 0)
        dataStore.fileStrings.append(stringLiteral)
        return .skipChildren
    }
}
