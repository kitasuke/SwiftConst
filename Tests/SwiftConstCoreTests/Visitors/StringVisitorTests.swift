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
    func foo() -> String {
        let string = "aaa"
        print("bbb")
        return "ccc"
    }
}
"""
        let url = createSourceFile(from: input)
        let syntax = try! SyntaxTreeParser.parse(url)
        
        let dataStore: DataStoreType = MockDataStore()
        StringVisitor(dataStore: dataStore).visit(syntax)
        
        XCTAssertEqual(dataStore.strings, ["\"aaa\"", "\"bbb\"", "\"ccc\""])
    }
    
    private func createSourceFile(from input: String) -> URL {
        let url = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(UUID().uuidString)
            .appendingPathExtension("swift")
        try! input.write(to: url, atomically: true, encoding: .utf8)
        
        return url
    }
}
