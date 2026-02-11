#!/bin/bash

# Local Installation Script for PDFCombineStamp
# This script builds and installs the app to /Applications

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║   PDFCombineStamp - Local Installation           ║${NC}"
    echo -e "${BLUE}╚═══════════════════════════════════════════════════╝${NC}"
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

# Check if build.sh exists
check_build_script() {
    if [ ! -f "build.sh" ]; then
        print_error "build.sh not found!"
        echo "Make sure you're running this from the project root directory."
        exit 1
    fi
}

# Build the app
build_app() {
    print_step "Building PDFCombineStamp..."
    
    if [ ! -x "build.sh" ]; then
        chmod +x build.sh
    fi
    
    ./build.sh --clean
    
    if [ ! -d "build/PDFCombineStamp.app" ]; then
        print_error "Build failed! App not found in build/ directory."
        exit 1
    fi
    
    print_success "Build completed"
}

# Check if app is running
check_running() {
    if pgrep -x "PDFCombineStamp" > /dev/null; then
        print_warning "PDFCombineStamp is currently running"
        read -p "Quit it now? [Y/n] " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Nn]$ ]]; then
            killall PDFCombineStamp
            sleep 1
            print_success "App quit"
        else
            print_error "Installation cancelled - quit the app first"
            exit 1
        fi
    fi
}

# Install to Applications
install_app() {
    print_step "Installing to /Applications..."
    
    # Remove old version if it exists
    if [ -d "/Applications/PDFCombineStamp.app" ]; then
        print_warning "Removing old version..."
        rm -rf /Applications/PDFCombineStamp.app
    fi
    
    # Copy new version
    cp -R build/PDFCombineStamp.app /Applications/
    
    if [ ! -d "/Applications/PDFCombineStamp.app" ]; then
        print_error "Installation failed!"
        exit 1
    fi
    
    print_success "App installed to /Applications"
}

# Verify extension is embedded
verify_extension() {
    print_step "Verifying extension bundle..."
    
    if [ -d "/Applications/PDFCombineStamp.app/Contents/PlugIns/PDFCombineStampExtension.appex" ]; then
        print_success "Extension is embedded"
    else
        print_error "Extension not found in app bundle!"
        print_warning "The app may not work correctly"
    fi
}

# Launch the app
launch_app() {
    print_step "Launching app to register extension..."
    
    open /Applications/PDFCombineStamp.app
    
    print_success "App launched"
}

# Wait for extension registration
wait_for_registration() {
    print_step "Waiting for extension registration..."
    
    local max_attempts=10
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if pluginkit -m -v 2>/dev/null | grep -q "PDFCombineStamp"; then
            print_success "Extension registered with system"
            return 0
        fi
        
        sleep 1
        attempt=$((attempt + 1))
        echo -n "."
    done
    
    echo ""
    print_warning "Extension not detected in system registry (yet)"
    print_warning "This is normal - it may take a few seconds"
}

# Print usage instructions
print_instructions() {
    echo ""
    echo -e "${GREEN}╔═══════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║         Installation Complete! ✓                  ║${NC}"
    echo -e "${GREEN}╚═══════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${YELLOW}How to use:${NC}"
    echo "  1. Open Finder"
    echo "  2. Select some PDF or image files"
    echo "  3. Right-click on the selected files"
    echo "  4. Choose: Quick Actions → Combine PDFs and Stamp"
    echo ""
    echo -e "${YELLOW}If the Quick Action doesn't appear:${NC}"
    echo "  • Wait a few seconds and try again"
    echo "  • Log out and log back in"
    echo "  • Run: /System/Library/CoreServices/pbs -flush && killall Finder"
    echo "  • Check System Settings → Extensions → Finder Extensions"
    echo ""
    echo -e "${BLUE}Test files:${NC}"
    echo "  Run: ./test_extension.sh test"
    echo "  This creates sample PDFs and opens them in Finder"
    echo ""
}

# Offer to test
offer_test() {
    echo ""
    read -p "Would you like to create test files and open Finder? [y/N] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [ -f "test_extension.sh" ]; then
            if [ ! -x "test_extension.sh" ]; then
                chmod +x test_extension.sh
            fi
            ./test_extension.sh test
        else
            print_warning "test_extension.sh not found - skipping test"
        fi
    fi
}

# Main installation flow
main() {
    print_header
    
    check_build_script
    build_app
    check_running
    install_app
    verify_extension
    launch_app
    wait_for_registration
    print_instructions
    offer_test
    
    echo ""
    echo "Done! 🎉"
    echo ""
}

# Run main function
main "$@"
