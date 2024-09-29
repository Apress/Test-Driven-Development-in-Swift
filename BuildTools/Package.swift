// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_13)],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.54.5"),
    ],
    targets: [.target(name: "BuildTools", path: "")]
)
