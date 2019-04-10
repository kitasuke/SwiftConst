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
        print("ccc")

        let a = "foo"
        let b = "\\(a)"
        let d = \"\"\"
            ddd
\"\"\"

        print("ccc \\(b) ddd")

        return "bbb" + "bar"
    }
}
"""
        let url = createSourceFile(from: input)
        let syntax = try! SyntaxTreeParser.parse(url)
        let result = DuplicationDetector(syntax: syntax).detect()
        
        XCTAssertEqual(result, [
            .init(value: "aaa", line: 2, column: 15),
            .init(value: "aaa", line: 5, column: 22),
            .init(value: "bbb", line: 6, column: 15),
            .init(value: "ccc", line: 7, column: 15),
            .init(value: "ddd", line: 11, column: 17),
            .init(value: "ccc", line: 15, column: 16),
            .init(value: "ddd", line: 15, column: 24),
            .init(value: "bbb", line: 17, column: 16)]
        )
    }
}
