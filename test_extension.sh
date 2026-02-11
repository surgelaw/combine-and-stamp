#!/bin/bash

# Quick test script for the PDF Combine & Stamp extension
# This script helps verify the extension is properly installed and working

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  PDF Combine & Stamp - Extension Test${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════${NC}"
    echo ""
}

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

# Check if app exists
check_app_installation() {
    print_step "Checking app installation..."
    
    if [ -d "/Applications/PDFCombineStamp.app" ]; then
        print_success "App found in Applications folder"
        return 0
    elif [ -d "build/PDFCombineStamp.app" ]; then
        print_warning "App found in build folder (not installed)"
        return 1
    else
        print_error "App not found"
        echo "  Build the app first with: ./build.sh"
        return 2
    fi
}

# Check if extension is embedded
check_extension_bundle() {
    print_step "Checking extension bundle..."
    
    local APP_PATH=""
    if [ -d "/Applications/PDFCombineStamp.app" ]; then
        APP_PATH="/Applications/PDFCombineStamp.app"
    elif [ -d "build/PDFCombineStamp.app" ]; then
        APP_PATH="build/PDFCombineStamp.app"
    else
        print_error "No app found"
        return 1
    fi
    
    if [ -d "$APP_PATH/Contents/PlugIns/PDFCombineStampExtension.appex" ]; then
        print_success "Extension is embedded in app bundle"
        return 0
    else
        print_error "Extension not found in app bundle"
        echo "  Expected: $APP_PATH/Contents/PlugIns/PDFCombineStampExtension.appex"
        return 1
    fi
}

# Check extension registration
check_extension_registration() {
    print_step "Checking extension registration..."
    
    # Use pluginkit to check
    local RESULT=$(pluginkit -m -v 2>/dev/null | grep -i "PDFCombineStamp" || true)
    
    if [ -n "$RESULT" ]; then
        print_success "Extension is registered with system"
        echo "$RESULT" | sed 's/^/  /'
        return 0
    else
        print_warning "Extension not found in system registry"
        echo "  This is normal if you haven't launched the app yet"
        return 1
    fi
}

# Check code signature
check_code_signature() {
    print_step "Checking code signature..."
    
    local APP_PATH=""
    if [ -d "/Applications/PDFCombineStamp.app" ]; then
        APP_PATH="/Applications/PDFCombineStamp.app"
    elif [ -d "build/PDFCombineStamp.app" ]; then
        APP_PATH="build/PDFCombineStamp.app"
    else
        return 1
    fi
    
    if codesign --verify --deep --strict "$APP_PATH" 2>/dev/null; then
        print_success "Code signature is valid"
        
        # Show signing identity
        local IDENTITY=$(codesign -dv "$APP_PATH" 2>&1 | grep "Authority=" | head -1)
        echo "  $IDENTITY"
        return 0
    else
        print_warning "App is not signed or signature is invalid"
        echo "  This is OK for development, but required for distribution"
        return 1
    fi
}

# Create test files
create_test_files() {
    print_step "Creating test PDF files..."
    
    local TEST_DIR="/tmp/pdfcombinestamp_test_$$"
    mkdir -p "$TEST_DIR"
    
    # Create a simple PDF using Python (available on all Macs)
    python3 - "$TEST_DIR" <<'EOF'
import sys
import os

try:
    from reportlab.pdfgen import canvas
    from reportlab.lib.pagesizes import letter
    
    test_dir = sys.argv[1]
    
    for i in range(1, 4):
        filename = os.path.join(test_dir, f"test_{i}.pdf")
        c = canvas.Canvas(filename, pagesize=letter)
        c.drawString(100, 750, f"Test PDF {i}")
        c.drawString(100, 730, "This is a test file for PDFCombineStamp")
        c.save()
    
    print(f"Created test files in {test_dir}")
    sys.exit(0)
    
except ImportError:
    # Reportlab not available, create minimal PDFs manually
    for i in range(1, 4):
        filename = os.path.join(test_dir, f"test_{i}.pdf")
        # Minimal PDF structure
        with open(filename, 'w') as f:
            f.write("%PDF-1.4\n")
            f.write("1 0 obj<</Type/Catalog/Pages 2 0 R>>endobj\n")
            f.write("2 0 obj<</Type/Pages/Count 1/Kids[3 0 R]>>endobj\n")
            f.write("3 0 obj<</Type/Page/Parent 2 0 R/MediaBox[0 0 612 792]>>endobj\n")
            f.write("xref\n0 4\n0000000000 65535 f\n")
            f.write("0000000009 00000 n\n0000000056 00000 n\n0000000115 00000 n\n")
            f.write("trailer<</Size 4/Root 1 0 R>>\nstartxref\n190\n%%EOF\n")
    
    print(f"Created minimal test files in {test_dir}")
    sys.exit(0)

EOF
    
    if [ $? -eq 0 ]; then
        print_success "Test files created in $TEST_DIR"
        echo "$TEST_DIR"
        return 0
    else
        print_error "Failed to create test files"
        return 1
    fi
}

# Open test directory in Finder
open_test_directory() {
    local TEST_DIR="$1"
    
    if [ -d "$TEST_DIR" ]; then
        print_step "Opening test directory in Finder..."
        open "$TEST_DIR"
        print_success "Test directory opened"
        
        echo ""
        echo -e "${YELLOW}Next steps:${NC}"
        echo "  1. Select the test PDF files in Finder"
        echo "  2. Right-click on the selected files"
        echo "  3. Look for 'Quick Actions' → 'Combine PDFs and Stamp'"
        echo "  4. Click it to test the extension"
        echo ""
        echo -e "${YELLOW}If the action doesn't appear:${NC}"
        echo "  • Make sure you launched the app at least once"
        echo "  • Try logging out and back in"
        echo "  • Check System Settings → Extensions → Finder Extensions"
        echo ""
        
        return 0
    fi
    
    return 1
}

# Cleanup test files
cleanup_test_files() {
    local TEST_DIR="$1"
    
    if [ -n "$TEST_DIR" ] && [ -d "$TEST_DIR" ]; then
        print_step "Cleaning up test files..."
        rm -rf "$TEST_DIR"
        print_success "Test files removed"
    fi
}

# Reset extension cache
reset_extension_cache() {
    print_step "Resetting extension cache..."
    
    /System/Library/CoreServices/pbs -flush
    
    print_success "Extension cache flushed"
    print_warning "You may need to log out and back in for changes to take effect"
}

# Main menu
show_menu() {
    echo ""
    echo "Choose an option:"
    echo ""
    echo "  1) Check installation status"
    echo "  2) Create test files and open in Finder"
    echo "  3) Reset extension cache"
    echo "  4) Open System Settings → Extensions"
    echo "  5) Run all checks"
    echo "  6) Exit"
    echo ""
    read -p "Enter choice [1-6]: " choice
    
    case $choice in
        1)
            check_app_installation
            check_extension_bundle
            check_extension_registration
            check_code_signature
            ;;
        2)
            TEST_DIR=$(create_test_files)
            if [ $? -eq 0 ]; then
                open_test_directory "$TEST_DIR"
                read -p "Press Enter when done testing (files will be cleaned up)..."
                cleanup_test_files "$TEST_DIR"
            fi
            ;;
        3)
            reset_extension_cache
            ;;
        4)
            print_step "Opening System Settings..."
            open "x-apple.systempreferences:com.apple.preferences.extensions"
            print_success "System Settings opened"
            echo "  Navigate to: Extensions → Finder Extensions"
            ;;
        5)
            check_app_installation
            check_extension_bundle
            check_extension_registration
            check_code_signature
            ;;
        6)
            echo "Goodbye!"
            exit 0
            ;;
        *)
            print_error "Invalid choice"
            ;;
    esac
}

# Main script
main() {
    print_header
    
    # If no arguments, show interactive menu
    if [ $# -eq 0 ]; then
        while true; do
            show_menu
        done
    fi
    
    # Handle command-line arguments
    case "$1" in
        check)
            check_app_installation
            check_extension_bundle
            check_extension_registration
            check_code_signature
            ;;
        test)
            TEST_DIR=$(create_test_files)
            if [ $? -eq 0 ]; then
                open_test_directory "$TEST_DIR"
            fi
            ;;
        reset)
            reset_extension_cache
            ;;
        clean)
            TEST_DIR="/tmp/pdfcombinestamp_test_*"
            cleanup_test_files "$TEST_DIR"
            ;;
        *)
            echo "Usage: $0 [check|test|reset|clean]"
            echo ""
            echo "Commands:"
            echo "  check  - Check installation and registration status"
            echo "  test   - Create test files and open in Finder"
            echo "  reset  - Reset extension cache"
            echo "  clean  - Clean up test files"
            echo ""
            echo "Run without arguments for interactive mode"
            exit 1
            ;;
    esac
}

main "$@"
