#!/bin/bash
# Restore files and regenerate project

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Restoring files from cleanup folder...${NC}"

# Restore the renamed files back to root if they exist
if [ -f "FileRowView.swift" ]; then
    echo "✓ FileRowView.swift already in place"
else
    echo "FileRowView.swift not found - will be created"
fi

if [ -f "ReorderableFileListView.swift" ]; then
    echo "✓ ReorderableFileListView.swift already in place"
else
    echo "ReorderableFileListView.swift not found - will be created"
fi

# Check if files exist in cleanup folder
if [ -d ".xcodegen_cleanup" ]; then
    echo -e "${BLUE}Found cleanup folder, checking for files...${NC}"
    
    # Don't restore ContentView - it should only be in PDFCombineStamp folder
    # Just restore the v1.1 files we need
    
    if [ -f ".xcodegen_cleanup/FileItem.swift" ]; then
        echo "  Restoring FileItem.swift"
        cp ".xcodegen_cleanup/FileItem.swift" ./
    fi
    
    if [ -f ".xcodegen_cleanup/FileValidator.swift" ]; then
        echo "  Restoring FileValidator.swift"
        cp ".xcodegen_cleanup/FileValidator.swift" ./
    fi
    
    if [ -f ".xcodegen_cleanup/DropZoneView.swift" ]; then
        echo "  Restoring DropZoneView.swift"
        cp ".xcodegen_cleanup/DropZoneView.swift" ./
    fi
    
    if [ -f ".xcodegen_cleanup/FileListView.swift" ]; then
        echo "  Restoring FileListView.swift"
        cp ".xcodegen_cleanup/FileListView.swift" ./
    fi
fi

echo -e "${BLUE}Checking for required files...${NC}"

# List what files we have
echo "Files in current directory:"
ls -1 *.swift 2>/dev/null | grep -E '(FileItem|FileValidator|DropZone|FileList|FileRow|Reorderable)' || echo "  (none found)"

echo ""
echo -e "${BLUE}Using corrected project.yml...${NC}"
cp project_fixed.yml project.yml

echo -e "${BLUE}Generating project with xcodegen...${NC}"
xcodegen generate

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Success! Project generated.${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. open PDFCombineStamp.xcodeproj"
    echo "  2. Build (⌘B)"
    echo ""
else
    echo ""
    echo "❌ xcodegen failed. Checking what's missing..."
    echo ""
    echo "Required files:"
    echo "  - PDFCombineStamp/   (folder with main app files)"
    echo "  - PDFCombineStampExtension/  (folder with extension files)"
    echo "  - SharedPDFManager.swift"
    echo "  - FileItem.swift"
    echo "  - FileValidator.swift"
    echo "  - DropZoneView.swift"
    echo "  - FileListView.swift"
    echo "  - FileRowView.swift"
    echo "  - ReorderableFileListView.swift"
    echo ""
fi
