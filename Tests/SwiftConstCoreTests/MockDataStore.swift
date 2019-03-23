//
//  MockDataStore.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 3/23/19.
//

import Foundation
@testable import SwiftConstCore

final class MockDataStore: DataStoreType {
    public var fileStrings: [FileString] = []
}
