#!/bin/bash
# netlify_build.sh
# Installs Flutter (stable) if not already cached, then builds Flutter Web.
# Netlify caches the build directory between deploys — we reuse it when valid.

set -e  # Exit immediately on error

FLUTTER_DIR="flutter"
FLUTTER_BIN="$FLUTTER_DIR/bin/flutter"

# --- Install Flutter (skip if already cached) ---
if [ -f "$FLUTTER_BIN" ]; then
  echo "Flutter already cached — skipping install."
else
  echo "Flutter not found — cloning stable channel..."
  rm -rf "$FLUTTER_DIR"  # Remove any partial/corrupt directory
  git clone https://github.com/flutter/flutter.git \
    --depth 1 \
    --branch stable \
    "$FLUTTER_DIR"
fi

export PATH="$PATH:$(pwd)/$FLUTTER_DIR/bin"

echo "Flutter version:"
flutter --version --machine

echo "Disabling analytics..."
flutter config --no-analytics

echo "Installing dependencies..."
flutter pub get

echo "Building Flutter Web (release)..."
flutter build web --release

echo "Build complete. Output:"
ls -la build/web/
