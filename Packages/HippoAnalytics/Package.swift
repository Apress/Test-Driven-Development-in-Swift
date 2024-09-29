// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "HippoAnalytics",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "HippoAnalytics",
            targets: ["HippoAnalytics"]
        ),
    ],
    targets: [
        .target(
            name: "HippoAnalytics"),
        .testTarget(
            name: "HippoAnalyticsTests",
            dependencies: ["HippoAnalytics"]
        ),
    ]
)
