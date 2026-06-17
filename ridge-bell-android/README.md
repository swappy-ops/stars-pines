# Ridge Bell — Android APK

Staff operations app for Stars & Pines.

## Quick Build

```bash
# 1. Set Android SDK path
export ANDROID_HOME=$HOME/Android/Sdk

# 2. Build
./build-apk.sh

# 3. Install on device
adb install app/build/outputs/apk/debug/app-debug.apk
```

## Alternative: Open in Android Studio

1. Open Android Studio
2. File → Open → select `ridge-bell-android/` folder
3. Wait for Gradle sync
4. Build → Build APK(s)
5. APK will be in `app/build/outputs/apk/debug/`

## PWA (No Build Required)

The app works as a Progressive Web App:
1. Host the files on any web server
2. Open in Chrome on Android
3. Tap "Add to Home Screen"
4. Works like a native app

## App Structure

- `app/src/main/assets/index.html` — The Ridge Bell app (copied from root)
- `app/src/main/java/` — Minimal WebView wrapper
- `app/src/main/res/` — Android resources
