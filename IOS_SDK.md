# FabricSDK API Reference

## Overview

The FabricSDK provides a simple and efficient way to integrate Fabric WebView components into iOS applications using SwiftUI. The host application provides a WebView configuration that includes the Fabric space URL, optional session context, URL routing policy, and custom-scheme handling.

## Core Components

### FabricSDKInfo (Utility Object)

Simple utility for SDK information.

**Properties:**
- `version` - Returns the SDK version string, such as `"0.4.1"`

```swift
import FabricSDK

public struct FabricSDKInfo {
  public static let version: String
}
```

#### Version Information

```swift
// Get the SDK version
let version = FabricSDKInfo.version
```

### FabricWebView SwiftUI View
Applications can use the `FabricWebView` component for displaying web content with built-in Fabric support.

```swift
import SwiftUI
import FabricSDK

struct ContentView: View {
  var body: some View {
    VStack {
      Text("FabricSDK v\(FabricSDKInfo.version)")
        .font(.subheadline)
        .foregroundColor(.secondary)

      let config = FabricWebViewConfig(
        url: URL(string: "https://sparkfabric.co/space/<your_space>")!,
        userIdToken: "<enterprise-id-token-jwt>",
        userLanguagePreferences: "en-US"
      )
      FabricWebView(config: config)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}
```

## WebView Features

The SDK WebView includes:
- **Geolocation** - Monitor user location via native CLLocationManager
- **Device orientation** - Motion sensor access via CoreMotion
- **Media permissions** - Camera/microphone permission queries
- **Safari-compatible UA** - Automatic user agent configuration for compatibility
- **Inline media playback** - Video elements play inline without fullscreen takeover
- **No-gesture media** - Support for autoplay media
- **Inspectable** - Debuggable via Safari's Develop menu (iOS 16.4+)


## Integration Guide

### 1. Add Dependency

The iOS release provides `FabricSDK.xcframework.zip` and a generated `Package.swift` for Swift Package Manager binary integration. This does not require GitHub Packages.

Add the SDK to your app via Xcode:
- File → Add Package Dependencies
- Enter the public releases repository URL: `https://github.com/fabric-pbc/fabric-sdks-releases.git`
- Select the release version you want to consume

Or via Package.swift:
```swift
dependencies: [
  .package(url: "https://github.com/fabric-pbc/fabric-sdks-releases.git", exact: "0.4.1")
]
```

If your team does not use Swift Package Manager, download `FabricSDK.xcframework.zip` from the release assets and add the extracted `FabricSDK.xcframework` to your app target manually.

## Requirements

### System Requirements
- **Minimum iOS Version**: iOS 15.0+
- **Swift**: 5.9+
- **Xcode**: 15.0+

**Why iOS 15?** The SDK uses modern iOS features including:
- Swift concurrency (async/await)
- Modern WKWebView APIs
- CoreLocation improvements
- AVFoundation permission handling

### Verify Requirements

**Check your app's minimum iOS version:**

In Xcode, select your app target and go to the Build Settings tab:
1. Search for "iOS Deployment Target" or "Minimum Deployment"
2. Verify the value is **15.0 or higher**

Or check your `Info.plist`:
```xml
<key>MinimumOSVersion</key>
<string>15.0</string>
```

**Check Swift version:**

In Terminal, verify your project uses Swift 5.9+:
```bash
# Check installed Swift version
swift --version
# Should show: Swift version 5.9 or higher

# Or check the Package.swift provided by the release repository.
# It should declare swift-tools-version 5.9 or higher.
```

**Check Xcode version:**

Verify you have Xcode 15.0 or higher:
```bash
xcodebuild -version
# Should show: Xcode 15.0 or higher
```

### Application Requirements - Permissions

If your web content uses geolocation, camera, or microphone features, **your application** must declare permission usage descriptions in your app's `Info.plist` or Xcode project settings:

**Geolocation (if used):**
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs your location to provide location-based features in the web content.</string>
```

**Camera (if used):**
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to enable video features in the web content.</string>
```

**Microphone (if used):**
```xml
<key>NSMicrophoneUsageDescription</key>
<string>This app needs microphone access to enable audio features in the web content.</string>
```

**Or in Xcode project settings:**
- Select your target → Info tab
- Add keys: `Privacy - Location When In Use Usage Description`, `Privacy - Camera Usage Description`, `Privacy - Microphone Usage Description`

**Important Notes:**
- Only add descriptions for features your web content actually uses
- The text you provide appears in the iOS system permission alert
- Customize the description to explain why YOUR app needs the permission
- The SDK will handle permission requests when these keys are present

## API Reference

### FabricWebViewConfig

Configuration object for WebView initialization.

```swift
public struct FabricWebViewConfig {
  public let url: URL
  public let userIdToken: String
  public let userLanguagePreferences: String?
  public let webViewDomains: Set<String>
  public let onCustomScheme: ((URL, String) -> Bool)?

  public init(
    url: URL,
    userIdToken: String = "",
    userLanguagePreferences: String? = nil,
    webViewDomains: Set<String> = [],
    onCustomScheme: ((URL, String) -> Bool)? = nil
  )
}
```

**Parameters:**
- `url: URL` (required): The HTTPS URL to load.
- `userIdToken: String` (optional): Enterprise ID Token JWT sent to the Fabric web application through the bridge after the core handshake succeeds. Defaults to an empty string.
- `userLanguagePreferences: String?` (optional): BCP 47 language tag to send with the session context. Defaults to `nil`; the SDK does not infer this value.
- `webViewDomains: Set<String>` (optional): External domains that should stay in the WebView instead of opening in Safari. Subdomains are included. Defaults to an empty set.
- `onCustomScheme: ((URL, String) -> Bool)?` (optional): Callback to handle custom URL schemes before the SDK falls back to `UIApplication.shared.open`. Return `true` when the host app handled the URL. Defaults to `nil`.

**Example:**
```swift
let config = FabricWebViewConfig(
  url: URL(string: "https://sparkfabric.co/space/<your_space>")!,
  userIdToken: "<enterprise-id-token-jwt>",
  userLanguagePreferences: "en-US",
  webViewDomains: ["accounts.google.com", "login.microsoftonline.com"],
  onCustomScheme: { url, scheme in
    switch scheme {
    case "myapp":
      // Handle app-specific deep links.
      return true
    default:
      // Let the SDK attempt UIApplication.shared.open.
      return false
    }
  }
)
```

### FabricWebView

```swift
public struct FabricWebView: UIViewRepresentable {
  public init(config: FabricWebViewConfig)
}
```

**Parameters:**
- `config: FabricWebViewConfig` - Configuration object specifying the URL and settings

**Example:**
```swift
let config = FabricWebViewConfig(
  url: URL(string: "https://sparkfabric.co/space/<your_space>")!,
  userIdToken: "<enterprise-id-token-jwt>"
)
FabricWebView(config: config)
```


## Best Practices

1. **URL Validation** - Always validate URLs before creating FabricWebViewConfig
2. **Permission Descriptions** - Provide clear Info.plist descriptions explaining why your app needs each permission
3. **HTTPS Only** - Use HTTPS URLs in production (localhost OK for development)
4. **Error Handling** - Handle potential URL force-unwrap failures in production code

```swift
// Good: Safe URL handling
if let url = URL(string: userInput) {
  let config = FabricWebViewConfig(
    url: url,
    userIdToken: idToken
  )
  FabricWebView(config: config)
} else {
  Text("Invalid URL")
}

// Avoid: Force unwrapping in production
let config = FabricWebViewConfig(url: URL(string: userInput)!) // Could crash!
```

## Troubleshooting

### WebView doesn't load
- Verify the URL is valid HTTPS
- Check App Transport Security settings in Info.plist
- Confirm network connectivity

### Geolocation not working
- Add `NSLocationWhenInUseUsageDescription` to Info.plist
- User must grant location permission when prompted

### Camera/microphone not working
- Add `NSCameraUsageDescription` and `NSMicrophoneUsageDescription` to Info.plist
- User must grant permission when prompted by the web application

### Can't debug in Safari
- Requires iOS 16.4+ for inspection support
- Enable Safari's Develop menu: Safari > Preferences > Advanced > Show Develop menu
- Connect device and select it from Develop menu
