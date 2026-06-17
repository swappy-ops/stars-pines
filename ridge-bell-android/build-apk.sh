#!/bin/bash
# Build Ridge Bell APK
# Requires: Android SDK (ANDROID_HOME set), Java 11+

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

# Copy latest app code to assets
cp ../ridge-bell-staff-app.html app/src/main/assets/index.html
cp ../ridge-bell-manifest.json app/src/main/assets/ 2>/dev/null || true
cp ../ridge-bell-sw.js app/src/main/assets/ 2>/dev/null || true

echo "Building Ridge Bell APK..."

if [ -z "$ANDROID_HOME" ]; then
    echo "ERROR: ANDROID_HOME not set. Set it to your Android SDK path."
    echo "Example: export ANDROID_HOME=\$HOME/Android/Sdk"
    exit 1
fi

# Use gradlew if available, otherwise use system gradle
if [ -f "./gradlew" ]; then
    ./gradlew assembleDebug
else
    gradle assembleDebug
fi

APK_PATH="app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK_PATH" ]; then
    echo ""
    echo "✓ APK built: $APK_PATH"
    echo "  Install with: adb install $APK_PATH"
else
    echo "ERROR: APK not found at $APK_PATH"
    exit 1
fi
