#!/bin/bash

# Build and Distribution Script for PDF Combine & Stamp
# This script builds, signs, and optionally notarizes the app for distribution

set -e

# Configuration
APP_NAME="PDFCombineStamp"
SCHEME_NAME="PDFCombineStamp"
CONFIGURATION="Release"
BUILD_DIR="build"
ARCHIVE_PATH="$BUILD_DIR/$APP_NAME.xcarchive"
APP_PATH="$BUILD_DIR/$APP_NAME.app"
DMG_PATH="$BUILD_DIR/$APP_NAME.dmg"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print colored output
print_step() {
    echo -e "${BLUE}==>${NC} ${1}"
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

# Check for required tools
check_requirements() {
    print_step "Checking requirements..."
    
    if ! command -v xcodebuild &> /dev/null; then
        print_error "xcodebuild not found. Please install Xcode."
        exit 1
    fi
    
    if ! command -v codesign &> /dev/null; then
        print_error "codesign not found. Please install Xcode Command Line Tools."
        exit 1
    fi
    
    print_success "All requirements met"
}

# Clean previous builds
clean_build() {
    print_step "Cleaning previous builds..."
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"
    print_success "Build directory cleaned"
}

# Build the app
build_app() {
    print_step "Building $APP_NAME..."
    
    xcodebuild archive \
        -scheme "$SCHEME_NAME" \
        -configuration "$CONFIGURATION" \
        -archivePath "$ARCHIVE_PATH" \
        -destination "generic/platform=macOS" \
        CODE_SIGN_IDENTITY="" \
        CODE_SIGNING_REQUIRED=NO \
        CODE_SIGNING_ALLOWED=NO \
        | grep -E '^(▸|❌|⚠️|error:|warning:)' || true
    
    if [ ! -d "$ARCHIVE_PATH" ]; then
        print_error "Archive failed"
        exit 1
    fi
    
    # Copy app from archive
    cp -R "$ARCHIVE_PATH/Products/Applications/$APP_NAME.app" "$APP_PATH"
    
    print_success "Build completed: $APP_PATH"
}

# Sign the app (optional, requires Developer ID)
sign_app() {
    local SIGNING_IDENTITY="$1"
    
    if [ -z "$SIGNING_IDENTITY" ]; then
        print_warning "No signing identity provided, skipping code signing"
        return
    fi
    
    print_step "Signing app with identity: $SIGNING_IDENTITY"
    
    # Sign the extension first
    print_step "Signing extension..."
    codesign --deep --force --verify --verbose \
        --sign "$SIGNING_IDENTITY" \
        --entitlements "PDFCombineStampExtension/PDFCombineStampExtension.entitlements" \
        --options runtime \
        "$APP_PATH/Contents/PlugIns/PDFCombineStampExtension.appex"
    
    # Sign the main app
    print_step "Signing main app..."
    codesign --deep --force --verify --verbose \
        --sign "$SIGNING_IDENTITY" \
        --entitlements "PDFCombineStamp.entitlements" \
        --options runtime \
        "$APP_PATH"
    
    # Verify signature
    print_step "Verifying signature..."
    codesign --verify --deep --strict --verbose=2 "$APP_PATH"
    spctl -a -vv "$APP_PATH"
    
    print_success "App signed successfully"
}

# Create DMG for distribution
create_dmg() {
    print_step "Creating DMG..."
    
    local TEMP_DMG="$BUILD_DIR/temp.dmg"
    local VOLUME_NAME="$APP_NAME"
    local DMG_SIZE="100m"
    
    # Create temporary DMG
    hdiutil create -size $DMG_SIZE -fs HFS+ -volname "$VOLUME_NAME" "$TEMP_DMG"
    
    # Mount it
    hdiutil attach "$TEMP_DMG" -mountpoint "/Volumes/$VOLUME_NAME"
    
    # Copy app
    cp -R "$APP_PATH" "/Volumes/$VOLUME_NAME/"
    
    # Create Applications symlink
    ln -s /Applications "/Volumes/$VOLUME_NAME/Applications"
    
    # Unmount
    hdiutil detach "/Volumes/$VOLUME_NAME"
    
    # Convert to compressed DMG
    hdiutil convert "$TEMP_DMG" -format UDZO -o "$DMG_PATH"
    rm "$TEMP_DMG"
    
    print_success "DMG created: $DMG_PATH"
}

# Notarize the app (optional, requires Apple Developer credentials)
notarize_app() {
    local APPLE_ID="$1"
    local TEAM_ID="$2"
    local APP_PASSWORD="$3"
    
    if [ -z "$APPLE_ID" ] || [ -z "$TEAM_ID" ] || [ -z "$APP_PASSWORD" ]; then
        print_warning "Notarization credentials not provided, skipping notarization"
        return
    fi
    
    print_step "Notarizing app..."
    
    # Create zip for notarization
    local ZIP_PATH="$BUILD_DIR/$APP_NAME.zip"
    ditto -c -k --keepParent "$APP_PATH" "$ZIP_PATH"
    
    # Submit for notarization
    print_step "Submitting to Apple for notarization (this may take several minutes)..."
    xcrun notarytool submit "$ZIP_PATH" \
        --apple-id "$APPLE_ID" \
        --team-id "$TEAM_ID" \
        --password "$APP_PASSWORD" \
        --wait
    
    # Staple the ticket
    print_step "Stapling notarization ticket..."
    xcrun stapler staple "$APP_PATH"
    
    # Staple to DMG if it exists
    if [ -f "$DMG_PATH" ]; then
        xcrun stapler staple "$DMG_PATH"
    fi
    
    print_success "Notarization completed"
}

# Display usage
usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -s, --sign IDENTITY        Code sign with specified identity"
    echo "  -n, --notarize             Notarize the app (requires environment variables)"
    echo "  -d, --dmg                  Create DMG for distribution"
    echo "  -c, --clean                Clean before building"
    echo "  -h, --help                 Show this help message"
    echo ""
    echo "Environment variables for notarization:"
    echo "  APPLE_ID                   Your Apple ID email"
    echo "  TEAM_ID                    Your Team ID"
    echo "  APP_SPECIFIC_PASSWORD      App-specific password"
    echo ""
    echo "Example:"
    echo "  $0 --clean --sign \"Developer ID Application\" --dmg"
    echo "  $0 --sign \"Developer ID Application\" --notarize"
}

# Main script
main() {
    local SIGN_IDENTITY=""
    local DO_NOTARIZE=false
    local DO_DMG=false
    local DO_CLEAN=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -s|--sign)
                SIGN_IDENTITY="$2"
                shift 2
                ;;
            -n|--notarize)
                DO_NOTARIZE=true
                shift
                ;;
            -d|--dmg)
                DO_DMG=true
                shift
                ;;
            -c|--clean)
                DO_CLEAN=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                usage
                exit 1
                ;;
        esac
    done
    
    echo ""
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║   PDF Combine & Stamp - Build & Distribution     ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo ""
    
    check_requirements
    
    if [ "$DO_CLEAN" = true ]; then
        clean_build
    else
        mkdir -p "$BUILD_DIR"
    fi
    
    build_app
    
    if [ -n "$SIGN_IDENTITY" ]; then
        sign_app "$SIGN_IDENTITY"
    fi
    
    if [ "$DO_DMG" = true ]; then
        create_dmg
    fi
    
    if [ "$DO_NOTARIZE" = true ]; then
        notarize_app "$APPLE_ID" "$TEAM_ID" "$APP_SPECIFIC_PASSWORD"
    fi
    
    echo ""
    echo "╔═══════════════════════════════════════════════════╗"
    echo "║                Build Complete! ✓                  ║"
    echo "╚═══════════════════════════════════════════════════╝"
    echo ""
    echo "Output directory: $BUILD_DIR"
    echo ""
    
    if [ -f "$APP_PATH" ]; then
        echo "  • App: $APP_PATH"
    fi
    
    if [ -f "$DMG_PATH" ]; then
        echo "  • DMG: $DMG_PATH"
    fi
    
    echo ""
    echo "Next steps:"
    echo "  1. Test the app: open \"$APP_PATH\""
    echo "  2. Test the extension in Finder"
    if [ "$DO_DMG" = true ]; then
        echo "  3. Distribute: $DMG_PATH"
    fi
    echo ""
}

# Run main function
main "$@"
