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
        return "bbb"
    }
}
"""
        let url = createSourceFile(from: input)
        let result = try! DuplicationDetector(fileURL: url).detect()
        
        XCTAssertEqual(result, [
            .init(value: "\"aaa\"", lineNumber: 2, column: 15),
            .init(value: "\"aaa\"", lineNumber: 5, column: 22),
            .init(value: "\"bbb\"", lineNumber: 6, column: 15),
            .init(value: "\"bbb\"", lineNumber: 8, column: 16)]
        )
    }
}
