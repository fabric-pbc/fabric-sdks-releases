# Fabric iOS Demo

This standalone demo application embeds the released FabricSDK XCFramework from `Frameworks/FabricSDK.xcframework`.

## Run in Xcode

1. Open `DemoApp.xcodeproj` in Xcode.
2. Select the `DemoApp` scheme.
3. Select an iOS simulator or physical device.
4. Run the app.

The app asks for a Fabric space URL and JWT ID token at runtime, then creates the Fabric WebView using those values.

For physical devices, set a valid development team in Xcode if code signing requires it.
