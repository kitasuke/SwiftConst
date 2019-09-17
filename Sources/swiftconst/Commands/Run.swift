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
            ignoreHidden: options.ignoreHidden,
            ignoreTest: options.ignoreTest,
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
    fileprivate let ignoreHidden: Bool
    fileprivate let ignoreTest: Bool
    fileprivate let ignorePaths: [String]
    private init(paths: [String], ignoreHidden: Bool, ignoreTest: Bool, ignorePaths: [String]) {
        self.paths = paths
        self.ignoreHidden = ignoreHidden
        self.ignoreTest = ignoreTest
        self.ignorePaths = ignorePaths
    }
    
    private static func create(_ paths: [String]) -> (Bool) -> (Bool) -> ([String]) -> RunOptions {
        return { ignoreHidden in
            return { ignoreTest in
                return { ignorePaths in
                    RunOptions(
                        paths: paths,
                        ignoreHidden: ignoreHidden,
                        ignoreTest: ignoreTest,
                        ignorePaths: ignorePaths
                    )
                }
            }
        }
    }

    static func evaluate(_ m: CommandMode) -> Result<RunOptions, CommandantError<ClientError>> {
        return create
            <*> m <| Option(key: "paths", defaultValue: [""], usage: "paths to run")
            <*> m <| Option(key: "ignoreHidden", defaultValue: true, usage: "flag whether it ignores hidden files")
            <*> m <| Option(key: "ignoreTest", defaultValue: true, usage: "flag whether it ignores test files")
            <*> m <| Option(key: "ignore", defaultValue: [""], usage: "paths to ignore")
    }
}
