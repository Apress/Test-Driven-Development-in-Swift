// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "CollectionSafe",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "CollectionSafe",
            targets: ["CollectionSafe"]
        ),
    ],
    targets: [
        .target(
            name: "CollectionSafe"),
    ]
)
