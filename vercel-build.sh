#!/bin/bash

# Install Flutter
FLUTTER_VERSION="3.22.0"
FLUTTER_CHANNEL="stable"

# Clone the Flutter repository
git clone https://github.com/flutter/flutter.git --depth 1 --branch $FLUTTER_VERSION /tmp/flutter

# Add Flutter to the PATH
export PATH="/tmp/flutter/bin:$PATH"

# Enable web support
flutter config --enable-web

# Get dependencies
flutter pub get

# Build the web application
flutter build web

# Move the build output to the public directory
mkdir -p public
cp -r build/web/* public/
