//
//  SwiftConstError.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 2019/09/26.
//

import Foundation

struct AnyError: Error {
    let error: Error

    init(_ error: Error) {
        if let anyError = error as? AnyError {
            self = anyError
        } else {
            self.error = error
        }
    }
}
