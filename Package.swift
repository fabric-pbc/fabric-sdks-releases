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
            url: "https://github.com/fabric-pbc/fabric-sdks-releases/releases/download/v0.4.0/FabricSDK.xcframework.zip",
            checksum: "82e58dbe427f1fd99be7b2b0cb82f6148c0c99eee30b5f0d4b5a6f99838ba3cd"
        )
    ]
)

