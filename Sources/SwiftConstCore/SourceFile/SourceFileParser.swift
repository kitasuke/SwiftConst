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
    
    public init(pathString: String) {
        self.pathURL = URL(fileURLWithPath: pathString)
    }
    
    public func parse() throws -> SourceFileSyntax {
        return try SyntaxTreeParser.parse(pathURL)
    }
}
