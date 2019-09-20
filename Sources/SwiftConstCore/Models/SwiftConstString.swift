//
//  SwiftConstString.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation

public struct SwiftConstString {
    public let filePath: String
    public let value: String
    public let line: Int
    public let column: Int
    
    public init(filePath: String, value: String, line: Int, column: Int) {
        self.filePath = filePath
        self.value = value
        self.line = line
        self.column = column
    }
}

extension SwiftConstString: CustomStringConvertible {
    public var description: String {
        return "other occurrence(s) of \(value) found in: \(filePath):\(line):\(column)"
    }
}
