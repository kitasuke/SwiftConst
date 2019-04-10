//
//  StringVisitor.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax

public final class StringVisitor: SyntaxVisitor {
    
    var dataStore: DataStoreType
    
    public init(dataStore: DataStoreType) {
        self.dataStore = dataStore
    }

    public override func visit(_ node: StringSegmentSyntax) -> SyntaxVisitorContinueKind {
        let value = node.content.text
            .trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else {
            return .skipChildren
        }
        let trivia = node.position
        let stringLiteral = FileString(value: value, line: trivia.line, column: trivia.column)
        dataStore.fileStrings.append(stringLiteral)
        return .visitChildren
    }
    
    public override func visit(_ node: StringLiteralExprSyntax) -> SyntaxVisitorContinueKind {
        // ignore empty string. e.g. "\"foo\"" or "\"\"\"\n   bar\"\"\""
        // TODO: "\"" is unexpectedly ignored for now
        let value = node.stringLiteral.text
            .trimmingCharacters(in: CharacterSet(charactersIn: "\"").union(.whitespacesAndNewlines))
        guard !value.isEmpty else {
                return .skipChildren
        }
        
        let trivia = node.position
        let stringLiteral = FileString(value: value, line: trivia.line, column: trivia.column)
        dataStore.fileStrings.append(stringLiteral)
        return .visitChildren
    }
}
