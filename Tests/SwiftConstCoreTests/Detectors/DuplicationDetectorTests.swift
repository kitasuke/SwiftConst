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
    let bar = "aaa"

    func foo() -> String {
        let string = "aaa"
        print("bbb")

        let a = "foo"
        let b = "\\(a)"

        return "bbb" + "bar"
    }
}
"""
        let url = createSourceFile(from: input)
        let syntax = try! SyntaxParser.parse(url)
        let result = DuplicationDetector(filePath: "", syntax: syntax).detect()
        
        XCTAssertEqual(result, [
            .init(value: "aaa", line: 2, column: 16),
            .init(value: "aaa", line: 5, column: 23),
            .init(value: "bbb", line: 6, column: 16),
            .init(value: "bbb", line: 11, column: 17)]
        )
    }
}
