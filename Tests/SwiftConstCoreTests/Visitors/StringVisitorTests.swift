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
    }
}
"""

        let url = createSourceFile(from: input)
        let syntax = try! SyntaxParser.parse(url)
        
        let dataStore: DataStoreType = MockDataStore()
        var visitor = StringVisitor(filePath: "", ignorePatterns: [], syntax: syntax, dataStore: dataStore)
        syntax.walk(&visitor)
        
        XCTAssertEqual(dataStore.fileStrings, [
            .init(value: "dddd", line: 2, column: 16),
            .init(value: "aaaa", line: 6, column: 23),
            .init(value: "bbbb", line: 7, column: 16),
            ]
        )
    }
}
