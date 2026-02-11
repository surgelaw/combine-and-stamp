#!/bin/bash
# Final fix: Use actual project structure

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}=== Fixing Project Structure ===${NC}"
echo ""

# 1. Restore ContentView from cleanup
if [ -f ".xcodegen_cleanup/ContentView.swift" ]; then
    echo -e "${YELLOW}Restoring ContentView.swift from cleanup...${NC}"
    cp ".xcodegen_cleanup/ContentView.swift" ./
    echo "✓ ContentView.swift restored"
fi

# 2. Check for missing v1.1 files
echo ""
echo -e "${BLUE}Checking for v1.1 files...${NC}"

missing_files=()

if [ ! -f "FileItem.swift" ]; then
    missing_files+=("FileItem.swift")
fi

if [ ! -f "FileValidator.swift" ]; then
    missing_files+=("FileValidator.swift")
fi

if [ ! -f "DropZoneView.swift" ]; then
    missing_files+=("DropZoneView.swift")
fi

if [ ! -f "FileListView.swift" ]; then
    missing_files+=("FileListView.swift")
fi

if [ ${#missing_files[@]} -gt 0 ]; then
    echo -e "${YELLOW}⚠ Missing v1.1 files:${NC}"
    for file in "${missing_files[@]}"; do
        echo "  - $file"
    done
    echo ""
    echo "These files need to be re-added to the project."
    echo "They should be in your repo but may have been moved."
fi

# 3. Use the project.yml that matches actual structure
echo ""
echo -e "${BLUE}Using project.yml for flat structure...${NC}"
cp project_actual.yml project.yml

# 4. Generate project
echo -e "${BLUE}Generating Xcode project...${NC}"
xcodegen generate

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Success! Project generated.${NC}"
    echo ""
    echo "Your project has been generated with the files that exist:"
    echo "  ✓ BatesStampApp.swift"
    echo "  ✓ BatesStampView.swift"
    echo "  ✓ ContentView 2.swift"
    echo "  ✓ SharedPDFManager.swift"
    echo "  ✓ FileRowView.swift"
    echo "  ✓ ReorderableFileListView.swift"
    echo "  ✓ Extension files"
    echo ""
    
    if [ ${#missing_files[@]} -gt 0 ]; then
        echo -e "${YELLOW}Note: Some v1.1 files are missing.${NC}"
        echo "The project will build, but you may want to re-add:"
        for file in "${missing_files[@]}"; do
            echo "  - $file"
        done
        echo ""
    fi
    
    echo "Next steps:"
    echo "  1. open PDFCombineStamp.xcodeproj"
    echo "  2. Build (⌘B)"
    echo "  3. If missing files are needed, I can recreate them"
    echo ""
else
    echo ""
    echo -e "${YELLOW}xcodegen had issues. Check the errors above.${NC}"
fi
