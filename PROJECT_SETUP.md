# PDF Combine & Stamp - Native Extension Setup

## Overview

This project has been refactored to use a native macOS App Extension (Share Extension) instead of Automator workflows. Users now install a single signed app that provides a Finder Quick Action.

## Architecture

### Main App Target: PDFCombineStamp
- **Purpose**: Host application for the extension and standalone utility
- **Bundle ID**: `com.yourcompany.PDFCombineStamp` (customize as needed)
- **Deployment Target**: macOS 12.0+
- **Architecture**: Universal (arm64 + x86_64)
- **Files**:
  - `BatesStampApp.swift` - App entry point and delegate
  - `ContentView.swift` - Information view when app is launched directly
  - `BatesStampView.swift` - Legacy UI (kept for command-line compatibility)

### Extension Target: PDFCombineStampExtension
- **Type**: Share Extension (com.apple.share-services)
- **Bundle ID**: `com.yourcompany.PDFCombineStamp.Extension` (must match parent + .Extension)
- **Files**:
  - `ShareViewController.swift` - Extension entry point
  - `ExtensionView.swift` - SwiftUI view for options
  - `Info.plist` - Extension configuration

### Shared Code
- **Location**: `Shared/PDFManager.swift`
- **Purpose**: Core PDF combining and stamping logic
- **Used By**: Both main app and extension
- **Important**: This file must be added to both targets' build phases

## Xcode Project Setup

### 1. Create the Main App Target (if not already done)
1. File → New → Target → macOS → App
2. Product Name: `PDFCombineStamp`
3. Interface: SwiftUI
4. Language: Swift
5. Add to existing project

### 2. Create the Extension Target
1. File → New → Target → macOS → Share Extension
2. Product Name: `PDFCombineStampExtension`
3. Language: Swift
4. Embed in Application: PDFCombineStamp
5. Click Finish

### 3. Configure Main App Target

#### Build Settings:
- **Deployment Target**: macOS 12.0
- **Architectures**: $(ARCHS_STANDARD) (arm64, x86_64)
- **Product Bundle Identifier**: `com.yourcompany.PDFCombineStamp`
- **Swift Language Version**: Swift 5

#### Info.plist Additions:
```xml
<key>NSHumanReadableCopyright</key>
<string>Copyright © 2026 Your Company. All rights reserved.</string>
<key>CFBundleDisplayName</key>
<string>PDF Combine &amp; Stamp</string>
```

#### Entitlements (PDFCombineStamp.entitlements):
- App Sandbox: YES
- User Selected File (Read/Write): YES
- Downloads Folder (Read/Write): YES

#### Signing & Capabilities:
- Enable App Sandbox
- Enable Hardened Runtime (for notarization)
- Sign with Developer ID or Mac App Store certificate

### 4. Configure Extension Target

#### Build Settings:
- **Deployment Target**: macOS 12.0
- **Architectures**: $(ARCHS_STANDARD)
- **Product Bundle Identifier**: `com.yourcompany.PDFCombineStamp.Extension`
- **Skip Install**: NO

#### Info.plist Configuration:
Use the provided `PDFCombineStampExtension/Info.plist` which includes:
- NSExtensionPointIdentifier: com.apple.share-services
- NSExtensionPrincipalClass: ShareViewController
- NSExtensionActivationRule: Supports up to 999 files
- Display Name: "Combine PDFs and Stamp"

#### Entitlements (PDFCombineStampExtension.entitlements):
- App Sandbox: YES
- User Selected File (Read/Write): YES
- Downloads Folder (Read/Write): YES
- Inherit from parent: YES

### 5. Link Shared Code

#### For Main App Target:
1. Select `Shared/PDFManager.swift` in Project Navigator
2. In File Inspector, check "Target Membership" for **PDFCombineStamp**

#### For Extension Target:
1. Select `Shared/PDFManager.swift` in Project Navigator
2. In File Inspector, check "Target Membership" for **PDFCombineStampExtension**

**Note**: The shared file should be included in BOTH targets.

### 6. File Organization

```
PDFCombineStamp/
├── PDFCombineStamp/                 (Main App)
│   ├── BatesStampApp.swift
│   ├── ContentView.swift
│   ├── BatesStampView.swift
│   └── PDFCombineStamp.entitlements
├── PDFCombineStampExtension/        (Extension)
│   ├── ShareViewController.swift
│   ├── ExtensionView.swift
│   ├── Info.plist
│   └── PDFCombineStampExtension.entitlements
├── Shared/                          (Shared Code)
│   └── PDFManager.swift
└── PROJECT_SETUP.md                 (This file)
```

## Building and Testing

### Debug Build:
1. Select **PDFCombineStamp** scheme
2. Build (⌘B)
3. Run (⌘R) - Shows information window
4. Extension is automatically embedded

### Testing the Extension:
1. Build and run the app
2. Open Finder
3. Select one or more PDF or image files
4. Right-click → Quick Actions → "Combine PDFs and Stamp"
   - Or: Right-click → Services → "Combine PDFs and Stamp"
5. Configure options and process

**Debugging Extension**:
1. Select the Extension scheme (PDFCombineStampExtension)
2. Edit Scheme → Run → Executable: Choose "Ask on Launch" or "Finder"
3. Run - Xcode will attach to the extension when invoked

### Distribution Build:
1. Archive the app (Product → Archive)
2. Sign with Developer ID
3. Notarize with Apple
4. Export signed app
5. Distribute .app bundle or create installer

## Migration from Automator

### What Changed:
- ❌ **Removed**: Automator .workflow file
- ❌ **Removed**: Manual workflow installation
- ✅ **Added**: Native Share Extension
- ✅ **Added**: Automatic Quick Action registration
- ✅ **Added**: Proper sandboxing and entitlements
- ✅ **Improved**: User experience (no manual setup)

### User Experience:
**Before** (Automator):
1. Download app
2. Download workflow separately
3. Double-click workflow to install
4. Grant permissions manually
5. Use from Finder

**After** (Native Extension):
1. Download app
2. Launch once to register extension
3. Use immediately from Finder Quick Actions

### File Selection:
- Extension receives files through NSExtensionContext
- Supports up to 999 files (configurable in Info.plist)
- Maintains Finder selection order
- Automatically filters supported types (PDF, images)

## Supported File Types

The extension accepts all file types and filters them internally:
- **Supported**: PDF, PNG, JPEG, TIFF, GIF, BMP
- **Unsupported files**: Displayed in warning, skipped during processing

## Output Location

Combined PDF is saved to:
1. **Primary**: Directory of first selected file
2. **Fallback**: User's Desktop folder
3. **Filename**: `Combined_<timestamp>.pdf`
4. **Post-processing**: Automatically revealed in Finder

## Known Limitations

1. **First Launch**: Extension may take a few seconds to appear after first app launch
2. **Large Files**: Files over 1.5GB require "Force Proceed" confirmation
3. **Sandboxing**: Extension can only write to user-selected locations or Desktop
4. **Memory**: Very large operations may require significant RAM

## Troubleshooting

### Extension Not Appearing:
1. Launch the main app at least once
2. Log out and log back in (or restart)
3. Check System Settings → Extensions → Finder Extensions
4. Ensure app is not in quarantine: `xattr -cr PDFCombineStamp.app`

### Permission Errors:
1. Verify entitlements are properly configured
2. Check that files are in accessible locations
3. Grant necessary permissions in System Settings → Privacy & Security

### Build Errors:
1. Ensure Shared/PDFManager.swift is in both targets
2. Verify bundle identifiers match pattern (main + .Extension)
3. Check deployment target is macOS 12.0 or later
4. Confirm architectures include both arm64 and x86_64

## Code Signing for Distribution

### Development:
```bash
codesign --deep --force --verify --verbose --sign "Apple Development" \
  PDFCombineStamp.app
```

### Distribution:
```bash
# Sign the extension first
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application: Your Name (TEAM_ID)" \
  --entitlements PDFCombineStampExtension/PDFCombineStampExtension.entitlements \
  PDFCombineStamp.app/Contents/PlugIns/PDFCombineStampExtension.appex

# Then sign the main app
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application: Your Name (TEAM_ID)" \
  --entitlements PDFCombineStamp.entitlements \
  --options runtime \
  PDFCombineStamp.app
```

### Notarization:
```bash
# Create a zip archive
ditto -c -k --keepParent PDFCombineStamp.app PDFCombineStamp.zip

# Submit for notarization
xcrun notarytool submit PDFCombineStamp.zip \
  --apple-id "your@email.com" \
  --team-id "TEAM_ID" \
  --password "app-specific-password" \
  --wait

# Staple the notarization ticket
xcrun stapler staple PDFCombineStamp.app
```

## Future Enhancements

Potential improvements for future versions:
- [ ] Configurable stamp position and style
- [ ] Multiple output format options
- [ ] Batch processing presets
- [ ] App Intents support for Shortcuts
- [ ] Widget for quick access to recent operations
- [ ] Cloud storage integration (iCloud, etc.)

## Support

For issues or questions:
- Check the troubleshooting section above
- Review Apple's documentation on App Extensions
- Verify entitlements and sandboxing configuration

---

**Last Updated**: February 10, 2026
**Deployment Target**: macOS 12.0+
**Swift Version**: 5.0+
**Xcode Version**: 14.0+
