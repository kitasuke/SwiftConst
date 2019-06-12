//
//  DuplicationDetector.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import SwiftSyntax

public struct DuplicationDetector {
    
    let filePath: String
    let syntax: SourceFileSyntax
    
    public init(filePath: String, syntax: SourceFileSyntax) {
        self.filePath = filePath
        self.syntax = syntax
    }
    
    public func detect() -> [FileString] {
        let dataStore = DataStore()
        var visitor = StringVisitor(filePath: filePath, syntax: syntax, dataStore: dataStore)
        syntax.walk(&visitor)
        return filter(dataStore.fileStrings)
    }
    
    private func filter(_ fileStrings: [FileString]) -> [FileString] {
        return fileStrings.filter { fileString in
            return fileStrings.filter { $0.value == fileString.value }.count > 1
        }
    }
}
