// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "HippoPayments",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "HippoPayments",
            targets: ["HippoPayments"]
        ),
    ],
    targets: [
        .target(
            name: "HippoPayments"),
        .testTarget(
            name: "HippoPaymentsTests",
            dependencies: ["HippoPayments"]
        ),
    ]
)
