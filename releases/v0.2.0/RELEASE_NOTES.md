# Release Notes

## Ci
### Fix
- add Package.swift.template for release workflow
- add gradle wrapper bootstrap step and use JDK 24
- use gradle setup action
- :green_heart: upgrade actions/setup-java
- :green_heart: fix release workflow
- :green_heart: improve release workflows
- :green_heart: fix release notes in PR body
- :green_heart: fix release workflows
- :green_heart: remove Read version summary step, useless
- :green_heart: Fix maintain-release-pr.yml to handle multiline output correctly
- :green_heart: fix script to calculate version number for releases

### Chore
- switch to JDK 21 for better CI compatibility

### Ci
- :hammer: add scripts for release workflows
- :bookmark: add release automation
- :green_heart: fix ios build
- :green_heart: fix android build
- :green_heart: fix ios builds
- :green_heart: fix build script for ios
- :green_heart: fix ios build error due to code signing
- :green_heart: skip all tests to fix the android CI build
- :green_heart: build the right kind of framework for ios
- :test_tube: skip tests that require a simulator on iOS CI
- :test_tube: skip tests that require an emulator on android CI

### Refactor
- :truck: rename build tasks
- :green_heart: try to fix code signing error on ios

### Feat
- :green_heart: add CI jobs for android and ios


## General
### Docs
- :memo: customize release_notes.md
- :memo: fix typos in README files

### Chore
- :technologist: add vscode settings for conventional commits scope

### Feat
- :sparkles: initial commit: ios,android, simple webview implementation


## Ios
### Feat
- :sparkles: Implement custom scheme interception and intelligent URL routing
- :sparkles: source the runtime SDK API for version from files that can be generated during the release automation (Version.swift, Version.xcconfig)
- :sparkles: avoid webkit popups when streaming a web camera.
- add sensor bridge, debug panel, UA init; add privacy keys
- :sparkles: intercept more JS APIs like Permissions query and watchPosition.
- :sparkles: intercept the web-level permission prompt and check the native-level access request
- :sparkles: support a callback to log browser console messages
- :sparkles: add ios demo application

### Refactor
- :wrench: change the URL loaded by the ios demo
- :construction_worker: fix the name collision and minos (was 15, now 16) for binary builds
- :truck: rename to log subsystem for the fabric domain
- :recycle: make FabricWebView component initialize with a structure for future-proofing
- :wastebasket: clean up the webview API so the SDK can be more intuitive
- :recycle: configure URL to be local network IP so physical devices can test as well as simulators
- :recycle: fix the communication from native to web for modern iOS JS Bridge implementation.
- :recycle: separate the ios demo header into its own component for legibility

### Docs
- :memo: add documentation about permissions
- :memo: improve notes about using physical devices
- :memo: fix the build instructions to refer to shell variable TARGET_DESTINATION only


## Android
### Feat
- :sparkles: Add source-based URL routing and custom scheme handling
- :sparkles: source the runtime SDK API for version from the gradle.properties that will be updated by release automation.
- :sparkles: handle permission requests for camera and data stream for orientation.
- :sparkles: add android bridge support for geolocation permission query and geolocation start watch.
- :sparkles: trust local certificate

### Refactor
- :wrench: change the URL loaded by the android demo
- :recycle: match the iOS API (FabricSDK was renamed to FabricSDKInfo)
- :truck: renamed the package path used for imports
- :recycle: make FabricWebView component initialize with a structure for future-proofing
- :wastebasket: clean up the webview API so the SDK can be more intuitive
- :wastebasket: clean up unused string resources
- :truck: rename the java path for the demo
- :recycle: remove unnecessary android SDK init method
- :recycle: change android bridge to use WebViewCompat.addWebMessageListener for simpler code.

### Fix
- :bug: add missing implementation to handle bridge messages for get location
- :bug: fix the permissions request when starting a geolocation watch.

### Build
- :construction_worker: configure release build android demo
- :arrow_down: assign minSdk for android gradle build
- :building_construction: add dependencies for geolocation features
- :technologist: add convenient VSCode tasks for android.

### Docs
- :memo: add documentation about permissions
- :memo: document SDKs logging
- :memo: document SDK initialization required usage.
- :memo: document using custom certificate on android to recognize local server HTTPS


## Web
### Refactor
- :fire: remove web/fabric-bridge-sdk because it was moved to the main fabric-platform repo.
- :recycle: simplify the implementation of when to prefer bridge comms over browser APIs
- :recycle: use the NativeBridge interface, as required by android, and eventually iOS.
- :recycle: simplify overly complex permissions query method.
- :recycle: require handshake method to avoid conditional checks
- :recycle: restructure web demo significantly to handle increased complexity in a compact UI
- :recycle: make the sensor methods work when in a browser and not only when in a webview.
- :memo: improve the documentation for the web demo usage

### Feat
- :sparkles: prefer browser APIs for android orientation sensors because they do not cause a browser popup that reveals the web domain.
- :sparkles: support specifying the keys to access postMessage in NativeBridge
- :sparkles: add camera sensor to web demo to demonstrate browser prompt appears and will need a bridge solution.
- :sparkles: improve visual feedback for web demo
- :sparkles: support web sdk configuration for android
- envelope bridge, demo UX, and test setup

### Fix
- :bug: fix to prefer bridge communication when embedded in a webview
- :bug: fix showing camera stream in preview area on ios safari

### Style
- :technologist: align code indentation
- :lipstick: improve UI style in web demo



## iOS Integration

Download `Package.swift` from this release and add the binary target to your app's `Package.swift`:

```swift
.binaryTarget(
    name: "FabricSDK",
    url: "https://github.com/fabric-pbc/fabric-sdks/releases/download/v0.2.0/FabricSDK.xcframework.zip",
    checksum: "c7ff327869361214d49a815a936b058dee95927b58ae2f4e18c670d6bfef67d0"
)
```

Or reference the `Package.swift` file included in this release.
