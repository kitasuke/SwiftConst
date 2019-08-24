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
        return "ccc"

        let a = ""
        let b = ""
        a = b

        print("ccc \\(b)")
    }
}
"""

        let url = createSourceFile(from: input)
        let syntax = try! SyntaxParser.parse(url)
        
        let dataStore: DataStoreType = MockDataStore()
        var visitor = StringVisitor(filePath: "", syntax: syntax, dataStore: dataStore)
        syntax.walk(&visitor)
        
        XCTAssertEqual(dataStore.fileStrings, [
            .init(value: "ddd", line: 2, column: 16),
            .init(value: "aaa", line: 6, column: 23),
            .init(value: "bbb", line: 7, column: 16),
            .init(value: "ccc", line: 8, column: 17),
            .init(value: "ccc", line: 14, column: 16)]
        )
    }
}
