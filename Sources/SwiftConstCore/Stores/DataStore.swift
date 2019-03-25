//
//  DataStore.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 3/23/19.
//

import Foundation

public protocol DataStoreType {
    var fileStrings: [FileString] { get set }
}

public final class DataStore: DataStoreType {
    public var fileStrings: [FileString] = []
    
    public init() {}
}
