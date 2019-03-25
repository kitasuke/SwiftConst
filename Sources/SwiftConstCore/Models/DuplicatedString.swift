//
//  DuplicationDetector.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation

public struct DuplicatedString {
    public let filePath: String
    public let value: String
    public let line: Int
    public let column: Int
    
    public init(filePath: String, fileString: FileString) {
        self.filePath = filePath
        self.value = fileString.value
        self.line = fileString.line
        self.column = fileString.column
    }
}

extension DuplicatedString: CustomStringConvertible {
    public var description: String {
        return "other occurrence(s) of \(value) found in: \(filePath):\(line):\(column)"
    }
}
