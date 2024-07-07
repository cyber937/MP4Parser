// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MP4Parser",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MP4Parser",
            targets: ["MP4Parser"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MP4Parser"
        ),
        .testTarget(
            name: "MP4ParserTests",
            dependencies: ["MP4Parser"],
            resources: [
                .process("Resources")
            ]),
    ]
)
