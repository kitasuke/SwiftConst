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
        
        let iterator = SourceFileIterator(
            paths: options.paths,
            ignoreHidden: true,
            ignorePaths: options.ignorePaths
        )
        do {

            var duplicatedStrings: [DuplicatedString] = []
            for path in iterator {
                let parser = SourceFileParser(path: path)
                let syntax = try parser.parse()
                let detector = DuplicationDetector(filePath: path ,syntax: syntax)
                let strings = detector.detect().map { DuplicatedString(filePath: path, fileString: $0) }
                duplicatedStrings.append(contentsOf: strings)
            }

            duplicatedStrings.forEach { print($0) }
            return .init(value: ())
        } catch let error {
            return .init(error: AnyError(error))
        }
    }
}

struct RunOptions: OptionsProtocol {
    
    typealias ClientError = AnyError
    
    fileprivate let paths: [String]
    fileprivate let ignorePaths: [String]
    private init(paths: [String], ignorePaths: [String]) {
        self.paths = paths
        self.ignorePaths = ignorePaths
    }
    
    private static func create(_ paths: [String]) -> ([String]) -> RunOptions {
        return { ignorePaths in
            RunOptions(paths: paths, ignorePaths: ignorePaths)
        }
    }

    static func evaluate(_ m: CommandMode) -> Result<RunOptions, CommandantError<ClientError>> {
        return create
            <*> m <| Option(key: "paths", defaultValue: [""], usage: "paths to run")
            <*> m <| Option(key: "ignore", defaultValue: [""], usage: "paths to ignore")
    }
}
