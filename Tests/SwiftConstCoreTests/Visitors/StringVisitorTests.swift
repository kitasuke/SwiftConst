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
    let bar = "foo"

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

        let syntax = makeSyntax(from: input)
        let dataStore = MockDataStore()
        var visitor = makeStringVisitor(minimumLength: 1, ignorePatterns: [], syntax: syntax, with: dataStore)
        syntax.walk(&visitor)
        
        XCTAssertEqual(
            dataStore.strings,
            [
                makeString(value: "foo", line: 2, column: 16),
                makeString(value: "aaa", line: 6, column: 23),
                makeString(value: "bbb", line: 7, column: 16),
            ]
        )
    }
    
    func test_stringVisitor_defaultIgnorePatterns() {
        let input = """
struct A {
    func foo() {
        let number = "%02d"
        print("%.02f")
        print("%2X")
        print("%02.2hhx")
    }
}
"""

        let syntax = makeSyntax(from: input)
        let dataStore = MockDataStore()
        var visitor = makeStringVisitor(minimumLength: 1, ignorePatterns: [], syntax: syntax, with: dataStore)
        syntax.walk(&visitor)
        
        XCTAssertEqual(
            dataStore.strings,
            []
        )
    }
    
    func test_stringVisitor_minLength() {
        let input = """
struct A {
    let foo = "foo"
    let bar = "bar"

    func foo() -> String {
        let string = "aaaaa"
        
        print("foo")
        print("bar")
    }
}
"""

        let syntax = makeSyntax(from: input)
        let dataStore = MockDataStore()
        var visitor = makeStringVisitor(minimumLength: 4, ignorePatterns: [], syntax: syntax, with: dataStore)
        syntax.walk(&visitor)
        
        XCTAssertEqual(
            dataStore.strings,
            [
                makeString(value: "aaaaa", line: 6, column:23),
            ]
        )
    }
    
    func test_stringVisitor_minLength_ignorePatterns() {
        let input = """
struct A {
    let foo = "foo"
    let bar = "bar"

    func foo() -> String {
        let string = "aaaaa"
        let number = "112233"
        
        print("foo")
        print("bar")
    }
}
"""

        let syntax = makeSyntax(from: input)
        let dataStore = MockDataStore()
        var visitor = makeStringVisitor(minimumLength: 4, ignorePatterns: ["[0-9]+"], syntax: syntax, with: dataStore)
        syntax.walk(&visitor)
        
        XCTAssertEqual(
            dataStore.strings,
            [
                makeString(value: "aaaaa", line: 6, column:23),
            ]
        )
    }
    
    private func makeSyntax(from input: String) -> SourceFileSyntax {
        let url = createSourceFile(from: input)
        return try! SyntaxParser.parse(url)
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
    
    private func makeString(value: String, line: Int, column: Int) -> SwiftConstString {
        return .init(
            filePath: "",
            value: value,
            line: line,
            column: column
        )
    }
}
