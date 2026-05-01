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
            url: "https://github.com/fabric-pbc/fabric-sdks-releases/releases/download/v0.4.3/FabricSDK.xcframework.zip",
            checksum: "c0b958b0737bc8a460f10fd02f3beb039919cc97e23b5352060311f2182fd848"
        )
    ]
)

