#!/bin/bash

# Regenerate Xcode Project with xcodegen
# This script cleans up duplicate files and regenerates a clean project

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_step() {
    echo -e "${BLUE}▸${NC} ${1}"
}

print_success() {
    echo -e "${GREEN}✓${NC} ${1}"
}

print_error() {
    echo -e "${RED}✗${NC} ${1}"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC}  ${1}"
}

echo ""
echo -e "${BLUE}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Regenerating Xcode Project with xcodegen       ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════════════════╝${NC}"
echo ""

# Check if xcodegen is installed
if ! command -v xcodegen &> /dev/null; then
    print_error "xcodegen is not installed or not in PATH"
    echo ""
    echo "Install with: brew install xcodegen"
    echo "Or download from: https://github.com/yonaskolb/XcodeGen"
    exit 1
fi

print_success "xcodegen found"

# Check if project.yml exists
if [ ! -f "project.yml" ]; then
    print_error "project.yml not found!"
    echo "Make sure you're running this from the project root directory."
    exit 1
fi

print_success "project.yml found"

# Backup existing project (optional)
if [ -d "PDFCombineStamp.xcodeproj" ]; then
    print_step "Backing up existing project..."
    timestamp=$(date +%Y%m%d_%H%M%S)
    cp -R PDFCombineStamp.xcodeproj "PDFCombineStamp.xcodeproj.backup_${timestamp}"
    print_success "Backup created: PDFCombineStamp.xcodeproj.backup_${timestamp}"
fi

# Clean up duplicate files (move to a backup folder)
print_step "Cleaning up duplicate files..."

mkdir -p .xcodegen_cleanup

# Move duplicate files to cleanup folder
duplicates=(
    "FileRowView.swift"
    "FileRowView_Fixed.swift"
    "FileRowView_v2.swift"
    "ReorderableFileListView.swift"
    "ContentView.swift" # Keep only in PDFCombineStamp folder
)

for file in "${duplicates[@]}"; do
    if [ -f "$file" ]; then
        print_warning "Moving duplicate: $file"
        mv "$file" ".xcodegen_cleanup/"
    fi
done

# Rename final versions to standard names
if [ -f "FileRowView_FINAL.swift" ]; then
    print_step "Renaming FileRowView_FINAL.swift → FileRowView.swift"
    mv "FileRowView_FINAL.swift" "FileRowView.swift"
fi

if [ -f "ReorderableFileListView_Fixed.swift" ]; then
    print_step "Renaming ReorderableFileListView_Fixed.swift → ReorderableFileListView.swift"
    mv "ReorderableFileListView_Fixed.swift" "ReorderableFileListView.swift"
fi

print_success "Cleanup complete"

# Generate project
print_step "Generating Xcode project with xcodegen..."

xcodegen generate

if [ $? -eq 0 ]; then
    print_success "Project generated successfully!"
else
    print_error "xcodegen failed!"
    exit 1
fi

# Update project.yml to use the renamed files
print_step "Updating project.yml..."
sed -i '' 's/FileRowView_FINAL.swift/FileRowView.swift/g' project.yml
sed -i '' 's/ReorderableFileListView_Fixed.swift/ReorderableFileListView.swift/g' project.yml

# Regenerate with updated names
print_step "Regenerating with updated file names..."
xcodegen generate

print_success "Project regeneration complete!"

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              Project Ready! ✓                     ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Open PDFCombineStamp.xcodeproj in Xcode"
echo "  2. Build (⌘B) - should work without errors!"
echo "  3. Run (⌘R) - test the app"
echo ""
echo -e "${BLUE}Duplicate files moved to:${NC} .xcodegen_cleanup/"
echo -e "${BLUE}Project backup:${NC} PDFCombineStamp.xcodeproj.backup_*"
echo ""
echo "Done! 🎉"
echo ""
