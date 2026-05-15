// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "FoundationKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "FoundationKit",
            targets: ["FoundationKit"]
        )
    ],
    targets: [
        .target(
            name: "FoundationKit"
        ),
        .testTarget(
            name: "FoundationKitTests",
            dependencies: ["FoundationKit"]
        )
    ]
)
