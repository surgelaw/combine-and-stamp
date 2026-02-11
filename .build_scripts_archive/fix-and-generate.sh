#!/bin/bash
# Quick fix: Replace project.yml and regenerate

set -e

echo "Replacing project.yml with corrected version..."
cp project_fixed.yml project.yml

echo "Running xcodegen..."
xcodegen generate

echo ""
echo "✅ Done! Now open PDFCombineStamp.xcodeproj in Xcode and build!"
echo ""
