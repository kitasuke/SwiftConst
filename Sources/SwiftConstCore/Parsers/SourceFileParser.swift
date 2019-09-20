//
//  SourceFileParser.swift
//  SwiftConstCore
//
//  Created by Yusuke Kita on 03/02/19.
//

import Foundation
import SwiftSyntax

public class SourceFileParser {
    
    public let pathURL: URL
    
    public init(filePath: String) {
        self.pathURL = URL(fileURLWithPath: filePath)
    }
    
    public func parse() throws -> SourceFileSyntax {
        return try SyntaxParser.parse(pathURL)
    }
}
