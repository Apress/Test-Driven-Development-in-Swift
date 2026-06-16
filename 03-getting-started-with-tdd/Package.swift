// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LeapYear",
    products: [
        .library(
            name: "LeapYear",
            targets: ["LeapYear"]
        ),
        .library(
            name: "ProductsManager",
            targets: ["ProductsManager"]
        ),
    ],
    targets: [
        .target(
            name: "LeapYear"
        ),
        .testTarget(
            name: "LeapYearTests",
            dependencies: ["LeapYear"]
        ),
        .target(
            name: "ProductsManager"
        ),
        .testTarget(
            name: "ProductsManagerTests",
            dependencies: ["ProductsManager"]
        ),
    ]
)
