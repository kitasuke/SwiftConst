//
//  Version.swift
//  SwiftConst
//
//  Created by Yusuke Kita on 04/11/19.
//

import Foundation
import Commandant
import Result

struct VersionCommand: CommandProtocol {
    
    typealias Options = NoOptions<AnyError>
    
    let verb = "version"
    let function = "Display current version of swiftconst"
    
    func run(_ options: Options) -> Result<(), AnyError> {
        print("0.1.0")
        return .init(value: ())
    }
}