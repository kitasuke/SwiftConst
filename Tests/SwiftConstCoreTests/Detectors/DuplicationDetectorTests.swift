//
//  ConstDetectorTests.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax
import XCTest
@testable import SwiftConstCore

final class DuplicationDetectorTests: XCTestCase {
    
    func test_Detector() {
        let input = """
struct A {
    let bar = "aaaa"

    func foo() -> String {
        let string = "aaaa"
        print("bbbb")

        let a = "foobar"
        let b = "\\(a)"

        return "bbbb" + "bar"
    }
}
"""
        let url = createSourceFile(from: input)
        let syntax = try! SyntaxParser.parse(url)
        let result = DuplicationDetector(filePath: "", ignorePatterns: [], syntax: syntax).detect()
        
        XCTAssertEqual(result, [
            .init(value: "aaaa", line: 2, column: 16),
            .init(value: "aaaa", line: 5, column: 23),
            .init(value: "bbbb", line: 6, column: 16),
            .init(value: "bbbb", line: 11, column: 17)]
        )
    }
}
