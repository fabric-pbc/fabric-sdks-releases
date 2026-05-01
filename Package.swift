// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FabricSDK",
    platforms: [
        .iOS(.v15)
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
            url: "https://github.com/fabric-pbc/fabric-sdks-releases/releases/download/v0.4.1/FabricSDK.xcframework.zip",
            checksum: "eadea4f4cb827e2b28b936e9a35280e68c919df77188f74ecd0e70494f2c0fd6"
        )
    ]
)

