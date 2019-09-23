//
//  StringVisitorTests.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax
import XCTest
@testable import SwiftConstCore

final class StringVisitorTests: XCTestCase {
    
    func test_stringVisitor() {
        let input = """
struct A {
    let bar = "ddd"

    func foo() -> String {
        // aaa
        let string = "aaa"
        print("bbb")

        let a = ""
        let b = ""
        a = b

        let b = "\\(aaa)"
    }
}
"""

        let url = createSourceFile(from: input)
        let syntax = try! SyntaxParser.parse(url)
        
        let dataStore = MockDataStore()
        var visitor = makeStringVisitor(minimumLength: 1, ignorePatterns: [], syntax: syntax, with: dataStore)
        syntax.walk(&visitor)
        
        XCTAssertEqual(
            dataStore.strings,
            [
                makeSwiftConstString(value: "ddd", line: 2, column: 16),
                makeSwiftConstString(value: "aaa", line: 6, column: 23),
                makeSwiftConstString(value: "bbb", line: 7, column: 16),
            ]
        )
    }
    
    private func makeStringVisitor(minimumLength: Int, ignorePatterns: [String], syntax: SourceFileSyntax, with dataStore: MockDataStore) -> StringVisitor {
        return .init(
            filePath: "",
            minimumLength: minimumLength,
            ignorePatterns: ignorePatterns,
            syntax: syntax,
            dataStore: dataStore
        )
    }
    
    private func makeSwiftConstString(value: String, line: Int, column: Int) -> SwiftConstString {
        return .init(
            filePath: "",
            value: value,
            line: line,
            column: column
        )
    }
}
