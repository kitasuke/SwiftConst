//
//  DataStore.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 3/23/19.
//

import Foundation

public protocol DataStoreType {
    var strings: [String] { get set }
}

public final class DataStore: DataStoreType {
    public var strings: [String] = []
}
