// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftConst",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50100.0")),
        .package(url: "https://github.com/Carthage/Commandant.git", from: "0.17.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "SwiftConst",
            dependencies: ["SwiftConstCore", "Commandant"]),
        .target(
            name: "SwiftConstCore",
            dependencies: ["SwiftSyntax"]),
        .testTarget(
            name: "SwiftConstTests",
            dependencies: ["SwiftConst"]),
        .testTarget(
            name: "SwiftConstCoreTests",
            dependencies: ["SwiftConstCore", "SwiftSyntax"]),
    ]
)
