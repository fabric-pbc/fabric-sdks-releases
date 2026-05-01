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
            url: "https://github.com/fabric-pbc/fabric-sdks-releases/releases/download/v0.4.2/FabricSDK.xcframework.zip",
            checksum: "eba0ebe87ec43beaca1ea6f0ccd8640b4a2f1b94412b68918d7add41b3d300f9"
        )
    ]
)

