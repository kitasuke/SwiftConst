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
    let bar = "dddd"

    func foo() -> String {
        // aaaa
        let string = "aaaa"
        print("bbbb")

        let a = ""
        let b = ""
        a = b

        print("eee")
    }
}
"""

        let url = createSourceFile(from: input)
        let syntax = try! SyntaxParser.parse(url)
        
        let dataStore: DataStoreType = MockDataStore()
        var visitor = StringVisitor(filePath: "foo", ignorePatterns: ["eee"], syntax: syntax, dataStore: dataStore)
        syntax.walk(&visitor)
        
        XCTAssertEqual(
            dataStore.strings,
            [
                .init(filePath: "foo", value: "dddd", line: 2, column: 16),
                .init(filePath: "foo", value: "aaaa", line: 6, column: 23),
                .init(filePath: "foo", value: "bbbb", line: 7, column: 16),
            ]
        )
    }
}
