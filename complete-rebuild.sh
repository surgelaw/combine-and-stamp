#!/bin/bash
# Complete rebuild - clean and regenerate everything

set -e

echo "╔════════════════════════════════════════════════╗"
echo "║   Complete Project Rebuild                    ║"
echo "╚════════════════════════════════════════════════╝"
echo ""

# Step 1: Check if all required files exist
echo "▸ Step 1: Checking for required files..."

required_files=(
    "StampPreset.swift"
    "PresetManager.swift"
    "PresetPickerView.swift"
    "PresetEditorView.swift"
    "FileItem.swift"
    "FileValidator.swift"
    "BatesStampView.swift"
)

missing_files=()
for file in "${required_files[@]}"; do
    if [ ! -f "$file" ]; then
        missing_files+=("$file")
        echo "  ❌ Missing: $file"
    else
        echo "  ✓ Found: $file"
    fi
done

if [ ${#missing_files[@]} -gt 0 ]; then
    echo ""
    echo "❌ Missing ${#missing_files[@]} required file(s)!"
    echo ""
    echo "Run this first to create them:"
    echo "  ./create-preset-files.sh"
    exit 1
fi

echo ""
echo "✅ All required files present"
echo ""

# Step 2: Clean Xcode derived data
echo "▸ Step 2: Cleaning Xcode derived data..."
rm -rf ~/Library/Developer/Xcode/DerivedData/PDFCombineStamp-*
echo "  ✓ Cleaned"
echo ""

# Step 3: Remove old project
echo "▸ Step 3: Removing old Xcode project..."
if [ -d "PDFCombineStamp.xcodeproj" ]; then
    rm -rf PDFCombineStamp.xcodeproj
    echo "  ✓ Removed"
else
    echo "  ℹ No existing project found"
fi
echo ""

# Step 4: Regenerate with xcodegen
echo "▸ Step 4: Generating new Xcode project..."
xcodegen generate

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ xcodegen failed!"
    exit 1
fi

echo "  ✓ Generated"
echo ""

# Step 5: Open Xcode
echo "▸ Step 5: Opening Xcode..."
open PDFCombineStamp.xcodeproj

echo ""
echo "╔════════════════════════════════════════════════╗"
echo "║   Project Rebuilt Successfully! ✅             ║"
echo "╚════════════════════════════════════════════════╝"
echo ""
echo "⚠️  IMPORTANT: Enable App Groups before building"
echo ""
echo "In Xcode:"
echo "  1. Select 'PDFCombineStamp' target"
echo "  2. Go to 'Signing & Capabilities'"
echo "  3. Click '+ Capability' → 'App Groups'"
echo "  4. Add: group.com.yourcompany.pdfcombinestamp"
echo "  5. Repeat for 'PDFCombineStampExtension' target"
echo ""
echo "Then:"
echo "  • Clean Build Folder (⌘⇧K)"
echo "  • Build (⌘B)"
echo ""

