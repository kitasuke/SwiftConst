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
            let pathURL = URL(fileURLWithPath: options.path)
            let detector = try DuplicationDetector(fileURL: pathURL)

            let strings = detector.detect()
            print(strings)
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
