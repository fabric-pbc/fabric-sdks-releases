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
            url: "https://github.com/fabric-pbc/fabric-sdks-releases/releases/download/v0.3.0/FabricSDK.xcframework.zip",
            checksum: "b716521c8326b0d85dae8ded8c8f791546e4f5a0e70d7287b73ccd6584caddd3"
        )
    ]
)


