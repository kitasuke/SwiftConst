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
        if let url = URL(string: filePath), url.isFileURL {
            self.pathURL = url
        } else {
            self.pathURL = URL(fileURLWithPath: filePath)
        }
    }
    
    public func parse() throws -> SourceFileSyntax {
        return try SyntaxParser.parse(pathURL)
    }
}
