//
//  main.swift
//  SwiftConst
//
//  Created by Yusuke Kita on 03/02/19.
//

import Foundation
import Commandant

let registry = CommandRegistry<AnyError>()

registry.register(RunCommand())
registry.register(VersionCommand())
let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)

registry.main(defaultVerb: helpCommand.verb) { error in
    fputs("\(error)\n", stderr)
}
