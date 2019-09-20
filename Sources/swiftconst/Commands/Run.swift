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
        
        do {

            let detector = DuplicationDetector(
                paths: options.paths,
                minimumLength: options.minimumLength,
                duplicationThreshold: options.duplicationThreshold,
                ignoreHidden: options.ignoreHidden,
                ignoreTest: options.ignoreTest,
                ignorePaths: options.ignorePaths,
                ignorePatterns: options.ignorePatterns
            )
            let duplicatedStrings = try detector.detect()

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
    fileprivate let minimumLength: Int
    fileprivate let duplicationThreshold: Int
    fileprivate let ignoreHidden: Bool
    fileprivate let ignoreTest: Bool
    fileprivate let ignorePaths: [String]
    fileprivate let ignorePatterns: [String]
    private init(
        paths: [String],
        minimumLength: Int,
        duplicationThreshold: Int,
        ignoreHidden: Bool,
        ignoreTest: Bool,
        ignorePaths: [String],
        ignorePatterns: [String]
    ) {
        self.paths = paths
        self.minimumLength = minimumLength
        self.duplicationThreshold = duplicationThreshold
        self.ignoreHidden = ignoreHidden
        self.ignoreTest = ignoreTest
        self.ignorePaths = ignorePaths
        self.ignorePatterns = ignorePatterns
    }
    
    private static func create(_ paths: [String]) -> (Int) -> (Int) -> (Bool) -> (Bool) -> ([String]) -> ([String]) -> RunOptions {
        return { minimumLength in
            return { duplicationThreshold in
                return { ignoreHidden in
                    return { ignoreTest in
                        return { ignorePaths in
                            return { ignorePatterns in
                                RunOptions(
                                    paths: paths,
                                    minimumLength: minimumLength,
                                    duplicationThreshold: duplicationThreshold,
                                    ignoreHidden: ignoreHidden,
                                    ignoreTest: ignoreTest,
                                    ignorePaths: ignorePaths,
                                    ignorePatterns: ignorePatterns
                                )
                            }
                        }
                    }
                }
            }
        }
    }

    static func evaluate(_ m: CommandMode) -> Result<RunOptions, CommandantError<ClientError>> {
        return create
            <*> m <| Option(key: "paths", defaultValue: ["."], usage: "paths to run")
            <*> m <| Option(key: "minLength", defaultValue: 5, usage: "minimum string length to find")
            <*> m <| Option(key: "hreshold", defaultValue: 3, usage: "threshold to determine if duplicated")
            <*> m <| Option(key: "ignoreHidden", defaultValue: true, usage: "flag whether it ignores hidden files")
            <*> m <| Option(key: "ignoreTest", defaultValue: true, usage: "flag whether it ignores test files")
            <*> m <| Option(key: "ignorePaths", defaultValue: [], usage: "paths to ignore")
            <*> m <| Option(key: "ignorePatterns", defaultValue: [], usage: "regular expression patterns to ignore specific string")
    }
}
