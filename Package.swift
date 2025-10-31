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
            url: "https://github.com/fabric-pbc/fabric-sdks-releases/releases/download/v0.3.4/FabricSDK.xcframework.zip",
            checksum: "6b79bb6dc8f6effb600a2dddd39c96835f5774020d368563c63845f756710200"
        )
    ]
)


