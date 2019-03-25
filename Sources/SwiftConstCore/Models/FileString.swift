//
//  DuplicationDetector.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation

public struct FileString {
    public let value: String
    public let line: Int
    public let column: Int
}

extension FileString: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(line)
        hasher.combine(column)
    }
}
