#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_FILE="$ROOT_DIR/PDFCombineStamp.xcodeproj"
SCHEME="PDFCombineStamp"
WORKFLOW_SRC="$ROOT_DIR/Combine and Stamp.workflow"
DERIVED_DATA="$ROOT_DIR/build/derived"
RELEASE_DIR="$ROOT_DIR/build/release"
PKGROOT="$ROOT_DIR/build/pkgroot"

VERSION="${VERSION:-1.0.0}"
PKG_ID="${PKG_ID:-com.user.combineandstamp}"
APP_SIGN_IDENTITY="${APP_SIGN_IDENTITY:-}"
PKG_SIGN_IDENTITY="${PKG_SIGN_IDENTITY:-}"
NOTARY_KEYCHAIN_PROFILE="${NOTARY_KEYCHAIN_PROFILE:-}"
DEVELOPMENT_TEAM="${DEVELOPMENT_TEAM:-}"
VERBOSE="${VERBOSE:-0}"

usage() {
  cat <<USAGE
Usage: scripts/release.sh [--version X.Y.Z] [--pkg-id identifier]

Environment variables:
  DEVELOPMENT_TEAM           Optional team ID for automatic signing.
  APP_SIGN_IDENTITY          Optional app signing identity for explicit codesign.
  PKG_SIGN_IDENTITY          Optional installer signing identity for productsign.
  NOTARY_KEYCHAIN_PROFILE    Optional notarytool keychain profile name.

Examples:
  VERSION=1.2.0 scripts/release.sh
  DEVELOPMENT_TEAM=ABCDE12345 PKG_SIGN_IDENTITY="Developer ID Installer: Example, Inc. (ABCDE12345)" VERSION=1.2.0 scripts/release.sh
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --version)
      VERSION="$2"
      shift 2
      ;;
    --pkg-id)
      PKG_ID="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1" >&2
      usage
      exit 1
      ;;
  esac
done

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "error: missing required command: $1" >&2
    exit 1
  fi
}

require_cmd xcodebuild
require_cmd pkgbuild
require_cmd ditto
require_cmd codesign
require_cmd lipo

if [[ ! -d "$PROJECT_FILE" ]]; then
  echo "error: missing $PROJECT_FILE" >&2
  echo "Run scripts/bootstrap_project.sh first." >&2
  exit 1
fi

if [[ ! -d "$WORKFLOW_SRC" ]]; then
  echo "error: missing workflow at $WORKFLOW_SRC" >&2
  exit 1
fi

rm -rf "$DERIVED_DATA" "$RELEASE_DIR" "$PKGROOT"
mkdir -p "$RELEASE_DIR" "$PKGROOT/Applications" "$PKGROOT/Library/Services"

XCODE_ARGS=(
  -project "$PROJECT_FILE"
  -scheme "$SCHEME"
  -configuration Release
  -derivedDataPath "$DERIVED_DATA"
  -destination "generic/platform=macOS"
  build
)

if [[ -n "$DEVELOPMENT_TEAM" ]]; then
  XCODE_ARGS+=(DEVELOPMENT_TEAM="$DEVELOPMENT_TEAM")
fi

BUILD_LOG="$RELEASE_DIR/xcodebuild.log"
if [[ "$VERBOSE" == "1" ]]; then
  if ! xcodebuild "${XCODE_ARGS[@]}" 2>&1 | tee "$BUILD_LOG"; then
    echo "error: xcodebuild failed. Key diagnostics from $BUILD_LOG:" >&2
    if ! rg -n "error:|warning:|\\*\\* BUILD FAILED \\*\\*" "$BUILD_LOG" >&2; then
      tail -n 120 "$BUILD_LOG" >&2
    fi
    exit 1
  fi
else
  if ! xcodebuild "${XCODE_ARGS[@]}" >"$BUILD_LOG" 2>&1; then
    echo "error: xcodebuild failed. Key diagnostics from $BUILD_LOG:" >&2
    if ! rg -n "error:|warning:|\\*\\* BUILD FAILED \\*\\*" "$BUILD_LOG" >&2; then
      tail -n 120 "$BUILD_LOG" >&2
    fi
    exit 1
  fi
fi

APP_PATH="$DERIVED_DATA/Build/Products/Release/PDFCombineStamp.app"
if [[ ! -d "$APP_PATH" ]]; then
  echo "error: expected app missing at $APP_PATH" >&2
  exit 1
fi

ARCHS="$(lipo -archs "$APP_PATH/Contents/MacOS/PDFCombineStamp")"
if [[ " $ARCHS " != *" arm64 "* || " $ARCHS " != *" x86_64 "* ]]; then
  echo "error: built app is not universal. Found architectures: $ARCHS" >&2
  echo "Ensure the target builds with standard macOS architectures." >&2
  exit 1
fi

ditto "$APP_PATH" "$PKGROOT/Applications/PDFCombineStamp.app"
ditto "$WORKFLOW_SRC" "$PKGROOT/Library/Services/Combine and Stamp.workflow"

if [[ -n "$APP_SIGN_IDENTITY" ]]; then
  codesign --force --deep --options runtime --sign "$APP_SIGN_IDENTITY" "$PKGROOT/Applications/PDFCombineStamp.app"
fi

UNSIGNED_PKG="$RELEASE_DIR/Combine-and-Stamp-${VERSION}-unsigned.pkg"
pkgbuild \
  --root "$PKGROOT" \
  --identifier "$PKG_ID" \
  --version "$VERSION" \
  --install-location "/" \
  "$UNSIGNED_PKG" >/dev/null

FINAL_PKG="$UNSIGNED_PKG"
if [[ -n "$PKG_SIGN_IDENTITY" ]]; then
  require_cmd productsign
  SIGNED_PKG="$RELEASE_DIR/Combine-and-Stamp-${VERSION}.pkg"
  productsign --sign "$PKG_SIGN_IDENTITY" "$UNSIGNED_PKG" "$SIGNED_PKG" >/dev/null
  FINAL_PKG="$SIGNED_PKG"
fi

ZIP_PATH="$RELEASE_DIR/Combine-and-Stamp-${VERSION}.zip"
(
  cd "$PKGROOT"
  ditto -c -k --sequesterRsrc --keepParent Applications/PDFCombineStamp.app "$ZIP_PATH"
)

if [[ -n "$NOTARY_KEYCHAIN_PROFILE" ]]; then
  require_cmd xcrun
  xcrun notarytool submit "$FINAL_PKG" --keychain-profile "$NOTARY_KEYCHAIN_PROFILE" --wait
  xcrun stapler staple "$FINAL_PKG"
  if [[ -d "$PKGROOT/Applications/PDFCombineStamp.app" ]]; then
    xcrun stapler staple "$PKGROOT/Applications/PDFCombineStamp.app" || true
  fi
fi

echo "Release artifacts:"
echo "  App zip: $ZIP_PATH"
echo "  Installer pkg: $FINAL_PKG"
