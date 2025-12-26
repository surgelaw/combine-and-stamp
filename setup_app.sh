#!/bin/bash

APP_NAME="PDFCombineStamp"
APP_BUNDLE="$APP_NAME.app"
CONTENTS="$APP_BUNDLE/Contents"
MACOS="$CONTENTS/MacOS"
RESOURCES="$CONTENTS/Resources"

# Create directory structure
mkdir -p "$MACOS"
mkdir -p "$RESOURCES"

# Compile the binary
swiftc -o "$MACOS/$APP_NAME" PDFManager.swift BatesStampView.swift BatesStampApp.swift \
    -framework SwiftUI -framework PDFKit -framework AppKit -framework CoreGraphics -framework CoreText

# Create Info.plist
cat <<EOF > "$CONTENTS/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.user.pdfcombinestamp</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSMinimumSystemVersion</key>
    <string>12.0</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSAppleEventsUsageDescription</key>
    <string>This app needs to control Finder to select the generated PDF.</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF

echo "Created $APP_BUNDLE"
echo "To use as a Quick Action:"
echo "1. Open Automator.app"
echo "2. Create a 'Quick Action'"
echo "3. Set 'Workflow receives current' to 'files or folders' in 'Finder'"
echo "4. Add 'Run Shell Script' action"
echo "5. Set 'Pass input' to 'as arguments'"
echo "6. Enter the following script:"
echo "   open -a \"$(pwd)/$APP_BUNDLE\" --args \"\$@\""
echo "7. Save it as 'Combine and Stamp'"
