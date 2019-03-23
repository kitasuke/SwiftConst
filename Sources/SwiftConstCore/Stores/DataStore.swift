//
//  DataStore.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 3/23/19.
//

import Foundation

public struct FileString {
    public let value: String
    public let lineNumber: Int
    public let column: Int
}

extension FileString: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
        hasher.combine(lineNumber)
        hasher.combine(column)
    }
}

public protocol DataStoreType {
    var fileStrings: [FileString] { get set }
}

public final class DataStore: DataStoreType {
    public var fileStrings: [FileString] = []
}
