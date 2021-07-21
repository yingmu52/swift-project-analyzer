// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-project-analyzer",
    dependencies: [
        .package(name: "SwiftSyntax", url: "https://github.com/apple/swift-syntax.git", .revision("swift-DEVELOPMENT-SNAPSHOT-2019-02-26")),
    ],
    targets: [
        .target(name: "swift-project-analyzer", dependencies: ["SwiftSyntax"]),
        .testTarget( name: "swift-project-analyzerTests", dependencies: ["swift-project-analyzer"]),
    ]
)

