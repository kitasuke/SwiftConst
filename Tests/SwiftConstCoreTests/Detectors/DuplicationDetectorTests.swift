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
    
    func test_detector() {
        let input1 = """
let fooo = "fooo"
print("aaaa")
"""
        let input2 = """
let fooo = "fooo"
let barr = "barr"
print("bbbb")
print("fooo")
"""
        let paths = makePaths(from: [input1, input2])
        defer {
            delete(paths: paths)
        }
        
        let detector = makeDetector(paths: paths)
        let strings = try! detector.detect()
        XCTAssertEqual(
            strings,
            [
                makeString(filePath: paths[0], value: "fooo", line: 1, column: 13),
                makeString(filePath: paths[1], value: "fooo", line: 1, column: 13),
                makeString(filePath: paths[1], value: "fooo", line: 4, column: 8)
            ]
        )
    }
    
    private func makePaths(from inputs: [String]) -> [String] {
        return inputs.map { input in
            let url = URL(fileURLWithPath: NSTemporaryDirectory())
                .appendingPathComponent(UUID().uuidString)
                .appendingPathExtension("swift")
            try! input.write(to: url, atomically: true, encoding: .utf8)
            
            return url.absoluteString
        }
    }
    
    private func delete(paths: [String]) {
        paths
            .compactMap(URL.init(string:))
            .forEach { try! FileManager.default.removeItem(at: $0) }
    }
    
    private func makeDetector(paths: [String], minimumLength: Int = 4, duplicationThreshold: Int = 2, ignoreHidden: Bool = true, ignoreTest: Bool = true, ignorePaths: [String] = [], ignorePatterns: [String] = []) -> DuplicationDetector {
        return .init(
            paths: paths,
            minimumLength: minimumLength,
            duplicationThreshold: duplicationThreshold,
            ignoreHidden: ignoreHidden,
            ignoreTest: ignoreTest,
            ignorePaths: ignorePaths,
            ignorePatterns: ignorePatterns
        )
    }
    
    private func makeString(filePath: String, value: String, line: Int, column: Int) -> SwiftConstString {
        return .init(
            filePath: filePath,
            value: value,
            line: line,
            column: column
        )
    }
}
