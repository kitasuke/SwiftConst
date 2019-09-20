//
//  DataStore.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 3/23/19.
//

import Foundation

public protocol DataStoreType {
    var strings: [SwiftConstString] { get set }
}

public final class DataStore: DataStoreType {
    public var strings: [SwiftConstString] = []
    
    public init() {}
}
