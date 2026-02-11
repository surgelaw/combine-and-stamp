#!/bin/bash

# Xcode Project Configuration Helper
# This script helps verify your Xcode project is configured correctly
# for the native extension architecture

echo "=== PDF Combine & Stamp - Project Configuration Checker ==="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if we're in the project directory
if [ ! -f "BatesStampApp.swift" ]; then
    echo -e "${RED}Error: Run this script from the project root directory${NC}"
    exit 1
fi

echo "Checking file structure..."

# Check for required files
FILES=(
    "BatesStampApp.swift"
    "BatesStampView.swift"
    "ContentView.swift"
    "Shared/PDFManager.swift"
    "PDFCombineStampExtension/ShareViewController.swift"
    "PDFCombineStampExtension/ExtensionView.swift"
    "PDFCombineStampExtension/Info.plist"
)

MISSING_FILES=0
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓${NC} Found: $file"
    else
        echo -e "${RED}✗${NC} Missing: $file"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

echo ""

if [ $MISSING_FILES -gt 0 ]; then
    echo -e "${RED}⚠️  Missing $MISSING_FILES required file(s)${NC}"
    echo "Please ensure all files are created as described in PROJECT_SETUP.md"
else
    echo -e "${GREEN}✓ All required files present${NC}"
fi

echo ""
echo "=== Next Steps ==="
echo ""
echo "1. Open your .xcodeproj in Xcode"
echo ""
echo "2. Create/verify the Extension target:"
echo "   - File → New → Target → Share Extension"
echo "   - Name: PDFCombineStampExtension"
echo "   - Embed in: PDFCombineStamp"
echo ""
echo "3. Configure Main App target (PDFCombineStamp):"
echo "   - Build Settings → Deployment Target: macOS 12.0"
echo "   - Build Settings → Architectures: \$(ARCHS_STANDARD)"
echo "   - Signing & Capabilities → Enable App Sandbox"
echo "   - Add entitlements: PDFCombineStamp.entitlements"
echo ""
echo "4. Configure Extension target (PDFCombineStampExtension):"
echo "   - Build Settings → Deployment Target: macOS 12.0"
echo "   - Build Settings → Architectures: \$(ARCHS_STANDARD)"
echo "   - Replace Info.plist with PDFCombineStampExtension/Info.plist"
echo "   - Add entitlements: PDFCombineStampExtension/PDFCombineStampExtension.entitlements"
echo ""
echo "5. Configure Shared/PDFManager.swift:"
echo "   - Select file in Project Navigator"
echo "   - File Inspector → Target Membership"
echo "   - Check BOTH: PDFCombineStamp AND PDFCombineStampExtension"
echo ""
echo "6. Update bundle identifiers:"
echo "   - Main app: com.yourcompany.PDFCombineStamp"
echo "   - Extension: com.yourcompany.PDFCombineStamp.Extension"
echo ""
echo "7. Build and test:"
echo "   - Select PDFCombineStamp scheme"
echo "   - Build (⌘B)"
echo "   - Run (⌘R)"
echo "   - Test in Finder with right-click on PDFs"
echo ""
echo "For detailed instructions, see: PROJECT_SETUP.md"
echo ""
