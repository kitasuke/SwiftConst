//
//  DuplicationDetector.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax

public struct DuplicationDetector {
    
    let syntax: SourceFileSyntax
    
    public init(syntax: SourceFileSyntax) {
        self.syntax = syntax
    }
    
    public func detect() -> [FileString] {
        let dataStore = DataStore()
        syntax.walk(StringVisitor(dataStore: dataStore))
        return filter(dataStore.fileStrings)
    }
    
    private func filter(_ fileStrings: [FileString]) -> [FileString] {
        return fileStrings.filter { fileString in
            return fileStrings.filter { $0.value == fileString.value }.count > 1
        }
    }
}
