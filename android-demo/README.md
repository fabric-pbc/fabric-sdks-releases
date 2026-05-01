# Fabric Android Demo

This standalone demo application embeds the released FabricSDK Android AAR from `libs/FabricSDK-release.aar`.

## Run in Android Studio

1. Open this folder in Android Studio.
2. Let Gradle sync.
3. Select the `app` run configuration.
4. Run on an Android emulator or physical device.

The app asks for a Fabric space URL and JWT ID token at runtime, then creates the Fabric WebView using those values.

## Command Line

```bash
./gradlew :app:assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n space.fabric.sdk.demo.debug/space.fabric.sdk.demo.MainActivity
```
