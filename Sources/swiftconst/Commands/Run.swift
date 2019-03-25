//
//  Run.swift
//  SwiftConst
//
//  Created by Yusuke Kita on 03/03/19.
//

import Foundation
import Commandant
import Result
import SwiftConstCore

struct RunCommand: CommandProtocol {
    
    typealias Options = RunOptions
    
    let verb = "run"
    let function = "Display duplicated strings"
    
    func run(_ options: RunOptions) -> Result<(), AnyError> {
        
        let scanner = SourceFileScanner(pathString: options.path)
        
        do {

            let strings: [DuplicatedString] = try scanner.files.reduce(into: []) { result, file in
                let parser = SourceFileParser(pathString: file.path)
                let syntax = try parser.parse()
                let detector = DuplicationDetector(syntax: syntax)
                let detectedStrings = detector.detect()
                let duplicatedStrings = detectedStrings.map { DuplicatedString(filePath: file.path, fileString: $0) }
                
                result.append(contentsOf: duplicatedStrings)
            }

            strings.forEach { print($0) }
            return .init(value: ())
        } catch let error {
            return .init(error: AnyError(error))
        }
    }
}

struct RunOptions: OptionsProtocol {
    
    typealias ClientError = AnyError
    
    fileprivate let path: String
    private init(path: String) {
        self.path = path
    }
    
    private static func create(_ path: String) -> RunOptions {
        return RunOptions(path: path)
    }

    static func evaluate(_ m: CommandMode) -> Result<RunOptions, CommandantError<ClientError>> {
        return create
            <*> m <| Option(key: "path", defaultValue: "", usage: "path to run SwiftConst")
    }
}
