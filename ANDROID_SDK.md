# Fabric Android SDK API Reference

## Overview

The Fabric Android SDK provides a simple and efficient way to integrate Fabric WebView components into Android applications using Jetpack Compose.

## Core Components

### FabricSDKInfo (Utility Object)

Simple utility functions for SDK information.

```kotlin
import space.fabric.sdk.FabricSDKInfo
```

#### Version Information

```kotlin
// Get the SDK version
val version = FabricSDKInfo.version // Returns the SDK version, such as "0.4.3"
```

### FabricWebViewConfig

Configuration object for customizing WebView behavior.

```kotlin
// Basic configuration with no external domain restrictions
val config = FabricWebViewConfig(
    url = "https://sparkfabric.co/space/<your_space>",
    userIdToken = "<enterprise-id-token-jwt>"
)

// Configuration with domains that stay in WebView (not opened in system browser)
val config = FabricWebViewConfig(
    url = "https://sparkfabric.co/space/<your_space>",
    userIdToken = "<enterprise-id-token-jwt>",
    userLanguagePreferences = "en-US",
    webViewDomains = setOf(
        "accounts.google.com",
        "login.microsoftonline.com"
    )
)

// Configuration with custom scheme handler for deep links
val config = FabricWebViewConfig(
    url = "https://sparkfabric.co/space/<your_space>",
    userIdToken = "<enterprise-id-token-jwt>",
    onCustomScheme = { url, scheme ->
        when (scheme) {
            "myapp" -> {
                // Handle app-specific deep links
                Log.d("DeepLink", "Handling custom scheme: $url")
                true  // Mark as handled
            }
            else -> false  // Let SDK try Intent.ACTION_VIEW
        }
    }
)
```

**Parameters:**
- `url` (required): The URL to load in the WebView.
- `userIdToken` (optional): Enterprise ID Token JWT sent to the Fabric web application through the bridge after the core handshake succeeds. Defaults to an empty string.
- `userLanguagePreferences` (optional): BCP 47 language tag to send with the session context. Defaults to `null`; the SDK does not infer this value.
- `webViewDomains` (optional): Set of external domains that will load in the WebView (main window) instead of opening in the system browser. Domains not in this set will open in the system browser. Subdomains are automatically included (e.g., "google.com" includes "accounts.google.com"). Defaults to an empty set.
- `onCustomScheme` (optional): Callback to handle custom URL schemes (deep links, tel:, mailto:, etc.). Return true if handled, false to let the SDK attempt Intent.ACTION_VIEW. Defaults to `null`.

### FabricWebView

The main WebView component for displaying web content with native bridge capabilities.

```kotlin
@Composable
fun FabricWebView(
  config: FabricWebViewConfig,
  modifier: Modifier = Modifier
)
```

Usage:
```kotlin
val config = FabricWebViewConfig(
  url = "https://sparkfabric.co/space/<your_space>",
  userIdToken = idToken
)
FabricWebView(
  config = config,
  modifier = Modifier.weight(1f)
)
```

**Parameters:**
- `config`: Configuration object specifying the URL and settings
- `modifier`: Compose modifier for layout and styling

The WebView handles all bridge communication and native functionality (permissions, geolocation, etc.) internally and transparently.

## Integration Guide

### Requirements

- **Minimum Android Version**: Android 6.0 (API 23)
- **Kotlin**: 2.0+
- **Jetpack Compose**: Required

**Why API 23?** The SDK requires:
- Jetpack Compose
- androidx.webkit library
- Modern WebView postMessage APIs
- Activity Result API for permissions

**Device coverage**: API 23+ covers the active Android devices expected for enterprise integrations.

### Verify Requirements

**Check your app's Android version support:**

In your app's `build.gradle.kts`, verify your `minSdk` is 23 or higher:

```kotlin
android {
    defaultConfig {
        minSdk = 23  // Compatible with FabricSDK
        // or minSdk = 24, 25, etc. - any value 23+ is supported
    }
}
```

**Check Kotlin version:**

In your `build.gradle.kts` (root or app level), verify Kotlin is 2.0+:

```kotlin
plugins {
    id("org.jetbrains.kotlin.android") version "2.0.20"  // ✓ 2.0 or higher
}
```

**Check Jetpack Compose:**

Verify `compose = true` is enabled in your app's `build.gradle.kts`:

```kotlin
android {
    buildFeatures {
        compose = true  // ✓ Required
    }
}
```

### 1. Add Dependency

Add the SDK to your app's `build.gradle.kts`:

```kotlin
dependencies {
  implementation(files("libs/FabricSDK-release.aar"))
}
```

### 2. Basic Usage

```kotlin
import space.fabric.sdk.FabricWebView
import space.fabric.sdk.FabricWebViewConfig
import space.fabric.sdk.FabricSDKInfo

@Composable
fun MyApp() {
  Column {
    Text("App powered by FabricSDK v${FabricSDKInfo.version}")
    
    val config = FabricWebViewConfig(
      url = "https://sparkfabric.co/space/<your_space>",
      userIdToken = idToken,
      userLanguagePreferences = "en-US"
    )
    FabricWebView(
      config = config,
      modifier = Modifier.weight(1f)
    )
  }
}
```

### 3. Debugging

The SDK enables WebView inspection so native teams can debug the embedded Fabric web application with Android WebView tooling.

## WebView Features

The SDK WebView includes:
- JavaScript enabled
- DOM storage enabled
- Proper viewport configuration
- Full-screen layout support
- Mobile-optimized settings

## Permissions

### Required Permissions (Included by SDK)

The SDK automatically declares these permissions in its manifest. Your app will inherit them:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

**What they're used for:**
- `INTERNET`: Required for the WebView to load web content from URLs
- `ACCESS_NETWORK_STATE`: Allows the SDK to check network connectivity status

### Optional Permissions (Application Must Declare)

If your web content uses geolocation or camera features, **your application** must declare these permissions in your app's `AndroidManifest.xml`:

```xml
<!-- Add to your app's AndroidManifest.xml if using geolocation -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />

<!-- Add to your app's AndroidManifest.xml if using camera -->
<uses-permission android:name="android.permission.CAMERA" />

<!-- Add to your app's AndroidManifest.xml if using microphone -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

**Important Notes:**
- Only add permissions your web content actually uses
- The SDK will handle permission requests when granted
- Users see system permission dialogs with **your app name** from `AndroidManifest.xml`
- Permission descriptions use Android's standard text and **cannot be customized**

**What users will see:**
- For camera: "Allow [Your App Name] to take pictures and record video?"
- For location: "Allow [Your App Name] to access this device's location?"
- For microphone: "Allow [Your App Name] to record audio?"

The `[Your App Name]` comes from the `android:label` in your app's `<application>` tag.

## URL Routing and Navigation

The FabricWebView implements intelligent URL routing based on where navigation originates from:

### Routing Rules

**Rule 1: From configured domain → domain listed for webview use → Load in WebView**
```
User at: https://dev.sparkfabric.co/space/john
Clicks:  https://auth.dev.sparkfabric.co/oauth2/authorize
Result:  ✓ Stays in WebView (listed for webview use)
```

**Rule 2: From configured domain → domain not listed for webview use → Open system browser**
```
User at: https://dev.sparkfabric.co/space/john
Clicks:  https://untrusted-site.com
Result:  🌐 Opens in system browser (not listed for webview use)
```

**Rule 3: From external domain → any domain → Load in WebView**
```
User at: https://accounts.google.com/login
Clicks:  https://auth.dev.sparkfabric.co/oauth2/callback
Result:  ✓ Stays in WebView (already external)
```

**Custom schemes: Any domain → Open native app**
```
Clicks:  maps://coordinates?q=51.5074,-0.1278
Result:  Host app callback receives the URL first
Or:      SDK falls back to Intent.ACTION_VIEW if the callback returns false
```

### Domain Matching

Domain matching includes subdomains:
- `auth.dev.sparkfabric.co` matches configured domain `dev.sparkfabric.co` ✓
- `accounts.google.com` matches domain listed for webview use `google.com` ✓
- `example.com` doesn't match `google.com` ✗

**Important:** Subdomains of your configured URL don't need to be listed for webview use separately—they're already trusted by Rule 1. For example, if your URL is `https://dev.sparkfabric.co/space/john`, then `auth.dev.sparkfabric.co` will automatically stay in the WebView without being added to `webViewDomains`.

### OAuth2 Flow Example

This routing enables complete OAuth2 flows:

```
1. User clicks "Login" on https://dev.sparkfabric.co/space/john
   ↓ (Rule 1: auth.dev.sparkfabric.co listed for webview use)

2. Navigates to https://auth.dev.sparkfabric.co/oauth2/authorize?provider=Google
   ↓ (stays in WebView, redirects to)

3. https://accounts.google.com/o/oauth2/v2/auth?...
   ↓ (Rule 3: now in external domain, can navigate anywhere)

4. User logs in, Google redirects to:
   ↓

5. https://auth.dev.sparkfabric.co/oauth2/callback?code=XXX
   ↓ (Rule 3: still in external domain, can navigate to domain listed for webview use)

6. auth.dev.sparkfabric.co processes callback, redirects to:
   ↓

7. https://dev.sparkfabric.co/space/john
   ✓ OAuth flow complete!
```

### Configuration Example

```kotlin
val config = FabricWebViewConfig(
    url = "https://dev.sparkfabric.co/space/<your_space>",
    userIdToken = "<enterprise-id-token-jwt>",
    userLanguagePreferences = "en-US",
    webViewDomains = setOf(
        "accounts.google.com",             // Google OAuth
        "login.microsoftonline.com",       // Microsoft OAuth
        "appleid.apple.com"                // Apple OAuth
    ),
    onCustomScheme = { url, scheme ->
        when (scheme) {
            "tel", "mailto" -> false  // Let system handle these
            "myapp" -> {
                Log.d("DeepLink", "Custom app deep link: $url")
                true  // Mark as handled by app
            }
            else -> false
        }
    }
)
```

### Logging

Debug logs show routing decisions:

```
D/FabricWebViewClient: URL loading: https://auth.dev.sparkfabric.co/oauth2/authorize?...
D/FabricWebViewClient: Current host: dev.sparkfabric.co, destination host: auth.dev.sparkfabric.co
D/FabricWebViewClient: Navigation allowed - domain listed for webview use: auth.dev.sparkfabric.co

D/FabricWebViewClient: URL loading: https://accounts.google.com/o/oauth2/v2/auth?...
D/FabricWebViewClient: Current host: auth.dev.sparkfabric.co, destination host: accounts.google.com
D/FabricWebViewClient: Navigation allowed - domain listed for webview use: accounts.google.com

D/FabricWebViewClient: URL loading: https://auth.dev.sparkfabric.co/oauth2/callback?code=XXX
D/FabricWebViewClient: Current host: accounts.google.com, destination host: auth.dev.sparkfabric.co
D/FabricWebViewClient: Navigation allowed - currently in external domain
```
