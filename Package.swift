// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftOpenF1",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftOpenF1",
            targets: ["SwiftOpenF1"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftOpenF1",
            dependencies: [],
            path: "Sources/SwiftOpenF1",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency")
            ]
        ),
        .testTarget(
            name: "SwiftOpenF1Tests",
            dependencies: ["SwiftOpenF1"],
            path: "Tests/SwiftOpenF1Tests"
        ),
    ]
)
