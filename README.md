# swiftconst

[![Swift 5.1](https://img.shields.io/badge/swift-5.1-orange.svg?style=flat)](https://swift.org/download/)
[![Build Status](https://app.bitrise.io/app/f45d3e8ffa077288/status.svg?token=1oqaCoE9MuMQrWJnYh1Cjg&branch=master)](https://app.bitrise.io/app/f45d3e8ffa077288)
[![codecov](https://codecov.io/gh/kitasuke/SwiftConst/branch/master/graph/badge.svg)](https://codecov.io/gh/kitasuke/SwiftConst)


## Overview

Find in Swift repeated strings that could be replaced by a constant using [SwiftSyntax](https://github.com/apple/swift-syntax).

This is highly inspired by [goconst](https://github.com/jgautheron/goconst) and Swift version of it.

## Requirements

Swift 5.1+  
Xcode 11.0+ beta

## How to use

### Installation

Run below command

```terminal
$ make install
$ swiftconst help
```

### Available Commands

#### `help`

Display general or command-specific help

#### `run --path <path> --ignore <path,path...>`

Display repeated strings

## Examples

```terminal
$ swiftconst run --ignore "/Users/kitasuke/SwiftConst/Tests/,/Users/kitasuke/SwiftConst/Package.swift"
other occurrence(s) of "error" found in: /Users/kitasuke/SwiftConst/main.swift:7:11
other occurrence(s) of "help" found in: /Users/kitasuke/SwiftConst/main.swift:18:19
other occurrence(s) of "error" found in: /Users/kitasuke/SwiftConst/main.swift:19:28
other occurrence(s) of "help" found in: /Users/kitasuke/SwiftConst/main.swift:21:19
```

## TODOs

- [ ] Recursive run in subfolders

## Acknowledgements

- [goconst](https://github.com/jgautheron/goconst)
- [SwiftRewriter](https://github.com/inamiy/SwiftRewriter)
- [swift-ast-explorer-playground](https://github.com/kishikawakatsumi/swift-ast-explorer-playground)
