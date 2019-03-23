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
    
    public override func visit(_ node: StringLiteralExprSyntax) {
        let value = node.stringLiteral.text
        let trivia = node.positionAfterSkippingLeadingTrivia
        let stringLiteral = FileString(value: value, lineNumber: trivia.line, column: trivia.column)
        dataStore.fileStrings.append(stringLiteral)
    }
}
