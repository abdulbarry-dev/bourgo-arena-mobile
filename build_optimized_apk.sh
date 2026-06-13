#!/bin/bash
# Optimized APK Build Script
# This script builds the Android APK with all size-reduction techniques applied.

# Variables
ENV_FILE=".env"
OUTPUT_DIR="build/app/outputs/apk/release"

echo "Building highly optimized Android APK..."

# Clean up first to ensure fresh build
flutter clean
flutter pub get

# Build the APK with:
# - Target Platform specified (arm64 usually sufficient for modern devices)
# - Obfuscation enabled (reduces AOT size)
# - Debug info split (removes symbol tables from the final APK)
# - Env file injection
flutter build apk \
  --target-platform android-arm64 \
  --obfuscate \
  --split-debug-info=build/app/outputs/symbols \
  --dart-define-from-file=$ENV_FILE

echo "Build complete. Check the size of the APK in $OUTPUT_DIR"
