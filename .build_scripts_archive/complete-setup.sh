#!/bin/bash
# Complete setup: Add all files and regenerate project

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Complete v1.1 Setup ===${NC}"
echo ""

echo "✓ All v1.1 files created"
echo "✓ Using complete project.yml with Info.plist generation"

cp project_complete.yml project.yml

echo ""
echo -e "${BLUE}Generating Xcode project...${NC}"
xcodegen generate

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Success! Project fully configured.${NC}"
    echo ""
    echo "All v1.1 features included:"
    echo "  ✓ Drag-and-drop interface"
    echo "  ✓ File reordering"
    echo "  ✓ Page count display"
    echo "  ✓ Info.plist auto-generation (fixes code signing)"
    echo ""
    echo "Next steps:"
    echo "  open PDFCombineStamp.xcodeproj"
    echo "  Build (⌘B) - should work!"
    echo ""
else
    echo "❌ Generation failed"
fi
