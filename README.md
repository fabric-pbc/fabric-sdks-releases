# Fabric SDK Releases

This repository contains binary releases of the Fabric SDK for iOS and Android.

## Latest Release

# Release Notes

Changes since v0.3.3


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
    url: "https://github.com/fabric-pbc/fabric-sdks-releases/releases/download/v0.3.3/FabricSDK.xcframework.zip",
    checksum: "dabeb13de049b5a4f4350eef45afc56a624ff4caceb5a016f641af984a836192"
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
