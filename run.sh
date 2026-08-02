#!/usr/bin/env bash
# Builds and runs the AHD (formerly OffPay) Android app on a connected device,
# or an emulator if nothing is connected.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

APPLICATION_ID="com.offpay.app"
LAUNCHER_ACTIVITY="${APPLICATION_ID}/${APPLICATION_ID}.presentation.MainActivity"
AVD_NAME="AHD_Pixel"

export JAVA_HOME="${JAVA_HOME:-/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home}"
export ANDROID_HOME="${ANDROID_HOME:-/opt/homebrew/share/android-commandlinetools}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"

if [ ! -f "$JAVA_HOME/bin/java" ]; then
    echo "error: JDK not found at $JAVA_HOME. Install with: brew install openjdk@17" >&2
    exit 1
fi
if [ ! -d "$ANDROID_HOME" ]; then
    echo "error: Android SDK not found at $ANDROID_HOME. Install with: brew install --cask android-commandlinetools" >&2
    exit 1
fi

# Point Gradle at the SDK regardless of shell env, in case it's invoked outside this script.
if [ ! -f local.properties ] || ! grep -q '^sdk.dir=' local.properties 2>/dev/null; then
    echo "sdk.dir=$ANDROID_HOME" >> local.properties
fi

has_device() {
    adb devices | awk 'NR>1 && $2=="device" {found=1} END {exit !found}'
}

echo "==> Checking for a connected device or running emulator..."
if ! has_device; then
    echo "==> None found. Booting emulator '$AVD_NAME'..."
    if ! avdmanager list avd | grep -q "Name: $AVD_NAME"; then
        echo "error: AVD '$AVD_NAME' does not exist. Create it with:" >&2
        echo "  avdmanager create avd -n $AVD_NAME -k \"system-images;android-35;google_apis;arm64-v8a\" -d pixel_6" >&2
        exit 1
    fi
    nohup emulator -avd "$AVD_NAME" -netdelay none -netspeed full > /tmp/ahd-emulator.log 2>&1 &
    echo "==> Waiting for emulator to come online (log: /tmp/ahd-emulator.log)..."
    adb wait-for-device
    boot_completed=""
    while [ "$boot_completed" != "1" ]; do
        boot_completed=$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r\n' || true)
        sleep 2
    done
    echo "==> Emulator booted."
else
    echo "==> Found a connected device/emulator."
fi

echo "==> Building and installing debug APK..."
./gradlew installDebug

echo "==> Launching AHD..."
adb shell am start -n "$LAUNCHER_ACTIVITY"

echo "==> Done. AHD is running."
