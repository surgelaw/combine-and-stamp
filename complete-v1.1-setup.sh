#!/bin/bash
# Complete v1.1 Setup - One Command to Rule Them All

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     PDF Combine & Stamp v1.1 Setup            ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Add files to project
echo -e "${BLUE}▸ Step 1: Adding v1.1 files to Xcode project...${NC}"
./add-presets-to-project.sh

if [ $? -ne 0 ]; then
    echo -e "${YELLOW}⚠  Project generation had issues. Check the output above.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}✅ v1.1 Implementation Complete!${NC}"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""
echo "📋 What's Been Implemented:"
echo ""
echo "  ✓ F-01: Drag-and-Drop Interface"
echo "  ✓ F-02: File Reordering"
echo "  ✓ F-03: Presets and Profiles"
echo "  ✓ Page Count Display"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}⚠  Important: Enable App Groups${NC}"
echo ""
echo "Before building, you need to enable App Groups in Xcode:"
echo ""
echo "  1. Open: ${BLUE}open PDFCombineStamp.xcodeproj${NC}"
echo "  2. Select 'PDFCombineStamp' target"
echo "  3. Go to 'Signing & Capabilities'"
echo "  4. Click '+ Capability' → 'App Groups'"
echo "  5. Add group: ${GREEN}group.com.yourcompany.pdfcombinestamp${NC}"
echo "  6. Repeat for 'PDFCombineStampExtension' target"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""
echo "Then build and test:"
echo ""
echo "  • Press ⌘B to build"
echo "  • Press ⌘R to run"
echo "  • Test all the new features!"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo ""
echo "📚 Documentation:"
echo ""
echo "  • V1.1_FINAL_SUMMARY.md - Complete overview"
echo "  • F03_COMPLETE.md - Preset implementation details"
echo "  • PRODUCT_ROADMAP.md - Feature roadmap"
echo ""
echo "🎉 You're ready to ship v1.1!"
echo ""


