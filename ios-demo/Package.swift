// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "DemoApp",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .executable(
            name: "DemoApp",
            targets: ["DemoApp"]
        ),
    ],
    dependencies: [
        // For production apps, add the binary target from the release
        // See: https://github.com/fabric-pbc/fabric-sdks/releases
    ],
    targets: [
        .executableTarget(
            name: "DemoApp",
            dependencies: ["FabricSDK"],
            path: "DemoApp"
        ),
        // Local binary target for testing
        .binaryTarget(
            name: "FabricSDK",
            path: "Frameworks/FabricSDK.xcframework"
        ),
    ]
)
