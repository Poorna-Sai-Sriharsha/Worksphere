#!/bin/bash
# netlify_build.sh
# This script is used by Netlify to build the Flutter web app.
# It installs Flutter (stable channel) and runs the production build.
# Note: GitHub Actions is the primary CI/CD pipeline (see .github/workflows/deploy.yml)
# This script serves as a fallback for direct Netlify deploys.

set -e  # Exit immediately if a command exits with a non-zero status

echo "Installing Flutter..."
git clone https://github.com/flutter/flutter.git --depth 1 --branch stable flutter
export PATH="$PATH:$(pwd)/flutter/bin"

echo "Flutter version:"
flutter --version

echo "Disabling analytics..."
flutter config --no-analytics

echo "Installing dependencies..."
flutter pub get

echo "Building Flutter Web (release)..."
flutter build web --release

echo "Build complete. Output in build/web/"
ls -la build/web/
