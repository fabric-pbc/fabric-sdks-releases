// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FabricSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "FabricSDK",
            targets: ["FabricSDK"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "FabricSDK",
            url: "https://github.com/fabric-pbc/fabric-sdks-releases/releases/download/v0.2.0/FabricSDK.xcframework.zip",
            checksum: "c7ff327869361214d49a815a936b058dee95927b58ae2f4e18c670d6bfef67d0"
        )
    ]
)


