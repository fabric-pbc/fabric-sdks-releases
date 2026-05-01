# Fabric SDK Releases

This repository contains binary releases of the Fabric SDK for iOS and Android.

## Developer Guides

- [Android SDK Guide](ANDROID_SDK.md)
- [iOS SDK Guide](IOS_SDK.md)

## Latest Release

# Fabric Mobile SDK

The Fabric SDK packages the native mobile integration layer for Fabric spaces. It lets an enterprise application embed a Fabric web experience inside a native Android or iOS app while keeping the host application in control of session identity, user consent, permissions, and navigation policy.

The release artifacts are intended for teams that consume both platform SDKs:

- Android: `FabricSDK-release.aar`, published as an Android library artifact.
- iOS: `FabricSDK.xcframework.zip`, plus a generated `Package.swift` for Swift Package Manager binary integration.
- iOS debug symbols: `FabricSDK-dSYMs.zip`, for crash symbolication in production monitoring systems.

## Why Teams Use It

The Fabric web application needs a bridge when it must exchange structured messages with the native host application, especially:

1. Session identity.
2. Device permission requests and responses.

Without FabricSDK, each host app would need to define that message contract, expose it safely to JavaScript, handle platform-specific WebView behavior, and keep Android and iOS implementations aligned as Fabric web capabilities evolve.

FabricSDK gives native teams a consistent wrapper around that bridge contract and the native WebView responsibilities:

- Loads a configured Fabric space URL in a native WebView.
- Sends session context to the Fabric web application through the bridge after the web bridge handshake succeeds.
- Routes selected web domains inside the WebView while opening other destinations in the system browser.
- Lets the host app handle custom URL schemes before the SDK falls back to native app intents or system behavior.

## Session Context

The host application provides the user's ID token when constructing the WebView configuration. The SDK stores that value in memory as part of the WebView configuration and relays it to the Fabric web application through the bridge session domain after a successful core handshake.

The host application may also provide user language preferences. The SDK does not infer enterprise language policy on its own; applications should pass the language preferences they want Fabric web content to receive.

## Expected Application Side Effects

Using FabricSDK means the host application should expect these runtime behaviors:

- A native WebView is created and loads the configured Fabric URL.
- The WebView performs normal network requests for the configured page and any allowed in-WebView domains.
- The SDK may send session context, including the provided ID token, to the loaded Fabric web application through the JavaScript bridge.
- The SDK may participate in web-requested device capabilities such as camera, location, motion, or orientation when the platform, host app permissions, and web content request flow allow it.
- Navigation to domains outside the configured WebView policy may open in the system browser.
- Custom schemes such as `tel:`, `mailto:`, or app-specific schemes may be offered to the host app callback before system handling.

## Host Application Responsibilities

Before shipping an app with FabricSDK, native teams should review:

- Which Fabric space URL or environment the app should load.
- How the app obtains and refreshes the ID token provided to FabricSDK.
- Which user language preferences should be passed to Fabric web content.
- Which external domains should remain inside the WebView for authentication or embedded flows.
- Which domains should open in the system browser.
- Which custom URL schemes should be handled by the host app.
- Which camera, location, motion, or other privacy-sensitive capabilities the app is willing to expose.
- Which platform privacy strings, permissions, and enterprise compliance reviews are required for any device capabilities the app wants to support.

## Platform Notes

Android consumers can integrate the AAR directly or consume the published package when available. The SDK is designed for modern Android applications using the AndroidX WebKit and Jetpack Compose ecosystem.

iOS consumers can integrate the XCFramework through Swift Package Manager using the generated `Package.swift` or by adding the binary framework directly. The SDK is designed for SwiftUI applications and wraps `WKWebView`.

---

# Release Notes

Current version: v0.4.1

Changes since v0.4.1


## 📦 Release Artifacts

This release includes the following files:

### iOS
- **`FabricSDK.xcframework.zip`** - The iOS SDK binary framework for Swift Package Manager integration
- **`FabricSDK-dSYMs.zip`** - Debug symbols for crash symbolication (upload to Firebase Crashlytics, Sentry, etc.)
- **`Package.swift`** - Swift Package Manager manifest file with pre-configured binary target

### Android
- **`FabricSDK-release.aar`** - The Android SDK library (also available via GitHub Packages)

---

## 🍎 iOS Integration

### Using Swift Package Manager

Add the binary target to your app's `Package.swift`:

```swift
.binaryTarget(
    name: "FabricSDK",
    url: "https://github.com/fabric-pbc/fabric-sdks-releases/releases/download/v0.4.1/FabricSDK.xcframework.zip",
    checksum: "eadea4f4cb827e2b28b936e9a35280e68c919df77188f74ecd0e70494f2c0fd6"
)
```

Or download `Package.swift` from this release and reference it directly.

### Debug Symbols (dSYMs)

For crash symbolication in production:

1. Download `FabricSDK-dSYMs.zip` from this release
2. Upload to your crash reporting service:
   - **Firebase Crashlytics**: Add upload script to your build phase
   - **Sentry**: Use `sentry-cli upload-dif`
   - **Bugsnag**: Use `bugsnag-dsym-upload`
3. Or keep locally for manual symbolication with `symbolicatecrash` or `atos`

The dSYM package includes symbols for both iOS device (arm64) and simulator (arm64 + x86_64) builds.

---

## 🤖 Android Integration

1. Download `FabricSDK-release.aar` from the Assets section above
2. Copy it to your Android project's `libs` folder (create if it doesn't exist)
3. Add to your `build.gradle.kts`:

```kotlin
dependencies {
    implementation(files("libs/FabricSDK-release.aar"))
}
```
