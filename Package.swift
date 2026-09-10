// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-async-sequence",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(name: "Async Sequence", targets: ["Async Sequence"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-async.git", branch: "main"),
        .package(url: "https://github.com/swift-molecules/swift-async-stream.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Async Sequence",
            dependencies: [
                .product(name: "Async", package: "swift-async"),
            ],
            path: "Sources/Async Sequence"
        ),
        .testTarget(
            name: "Async Sequence Tests",
            dependencies: [
                .product(name: "Async", package: "swift-async"),
                .product(name: "Async Stream", package: "swift-async-stream"),
                .target(name: "Async Sequence"),
            ],
            path: "Tests/Async Sequence Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
