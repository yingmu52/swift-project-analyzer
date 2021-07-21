// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-project-analyzer",
    dependencies: [
      
        .package(
            name: "SwiftSemantics",
            url: "https://github.com/SwiftDocOrg/SwiftSemantics",
            .branch("main")
        ),
    ],
    targets: [
        .target(name: "swift-project-analyzer", dependencies: ["SwiftSemantics"]),
        .testTarget( name: "swift-project-analyzerTests", dependencies: ["swift-project-analyzer"]),
    ]
)

