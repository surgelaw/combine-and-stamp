#!/bin/bash
# Clean up all temporary scripts and files

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Cleaning Up Temporary Files ===${NC}"
echo ""

# Move all temporary scripts to a cleanup folder
mkdir -p .build_scripts_archive

echo "Archiving build scripts..."
scripts=(
    "regenerate-project.sh"
    "fix-and-generate.sh"
    "restore-and-generate.sh"
    "check-structure.sh"
    "final-fix.sh"
    "complete-setup.sh"
    "create-all-files.sh"
    "fix-duplicate-contentview.sh"
    "project_actual.yml"
    "project_fixed.yml"
)

for script in "${scripts[@]}"; do
    if [ -f "$script" ]; then
        mv "$script" .build_scripts_archive/
        echo "  ✓ Archived: $script"
    fi
done

# Keep only the essential files
echo ""
echo "Keeping essential files:"
echo "  ✓ project.yml (main project configuration)"
echo "  ✓ project_complete.yml (backup)"

# Clean up the temporary cleanup folder if it still exists
if [ -d ".xcodegen_cleanup" ]; then
    echo ""
    echo "Cleaning up .xcodegen_cleanup folder..."
    rm -rf .xcodegen_cleanup
    echo "  ✓ Removed"
fi

echo ""
echo -e "${GREEN}✅ Cleanup complete!${NC}"
echo ""
echo "Archived scripts are in: .build_scripts_archive/"
echo "You can delete this folder anytime."
echo ""
echo -e "${BLUE}Current clean structure:${NC}"
echo "  • All Swift source files at root"
echo "  • project.yml for xcodegen"
echo "  • PDFCombineStamp.xcodeproj (generated)"
echo ""
