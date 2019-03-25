# swiftconst

[![Swift 4.2](https://img.shields.io/badge/swift-4.2-orange.svg?style=flat)](https://swift.org/download/)

## Overview

Find in Swift repeated strings that could be replaced by a constant using [SwiftSyntax](https://github.com/apple/swift-syntax).

This is highly inspired by [goconst](https://github.com/jgautheron/goconst) and Swift version of it.

## Requirements

Swift 4.2+  
Xcode 10+

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

#### `run --path <file-path> --ignore /path/to/project/Tests/,/path/to/project/Carthage/`

Display repeated strings

## Examples

```terminal
$swiftconst run --ignore /Users/kitasuke/SwiftConst/Tests
other occurrence(s) of "error" found in: /Users/kitasuke/SwiftConst/main.swift:7:11
other occurrence(s) of "help" found in: /Users/kitasuke/SwiftConst/main.swift:18:19
other occurrence(s) of "error" found in: /Users/kitasuke/SwiftConst/main.swift:19:28
other occurrence(s) of "help" found in: /Users/kitasuke/SwiftConst/main.swift:21:19
```

## TODOs

## Acknowledgements

- [goconst](https://github.com/jgautheron/goconst)
- [SwiftRewriter](https://github.com/inamiy/SwiftRewriter)
- [swift-ast-explorer-playground](https://github.com/kishikawakatsumi/swift-ast-explorer-playground)
