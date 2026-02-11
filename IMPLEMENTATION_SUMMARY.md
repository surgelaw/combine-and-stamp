# PDF Combine & Stamp - Native Extension Refactoring

## 🎯 Project Overview

This refactoring converts PDFCombineStamp from an Automator-based workflow to a native macOS App Extension, providing seamless Finder integration through Quick Actions.

## 📋 What Changed

### Before (Automator)
- Separate .app and .workflow files
- Manual workflow installation
- Limited sandboxing
- Two-step user setup
- Difficult to maintain/debug

### After (Native Extension)
- Single .app with embedded extension
- Automatic system registration
- Full App Sandbox compliance
- One-step installation
- Standard Xcode development workflow

## 🏗️ Architecture

```
PDFCombineStamp.app
├── Contents/
│   ├── MacOS/
│   │   └── PDFCombineStamp              (Main executable)
│   ├── PlugIns/
│   │   └── PDFCombineStampExtension.appex  (Share Extension)
│   └── Resources/
```

### Components

**Main App** (`PDFCombineStamp`)
- Hosts the extension
- Displays information view when launched directly
- Maintains backward compatibility for command-line invocation

**Share Extension** (`PDFCombineStampExtension`)
- Appears in Finder Quick Actions
- Receives file selections from Finder
- Displays options UI
- Processes files using shared PDFManager

**Shared Code** (`Shared/PDFManager.swift`)
- Core PDF combining and stamping logic
- Linked to both main app and extension
- Public API for cross-target usage

## 📁 File Structure

```
PDFCombineStamp/
├── README.md                          ← User documentation
├── PROJECT_SETUP.md                   ← Developer setup guide
├── MIGRATION_GUIDE.md                 ← Automator removal guide
├── CHECKLIST.md                       ← Implementation checklist
├── configure_project.sh               ← Configuration helper
├── build.sh                           ← Build & distribution script
│
├── PDFCombineStamp/                   ← Main App Target
│   ├── BatesStampApp.swift            ← App entry point
│   ├── ContentView.swift              ← Info view (when launched)
│   ├── BatesStampView.swift           ← Legacy UI (CLI compat)
│   └── PDFCombineStamp.entitlements   ← App sandbox permissions
│
├── PDFCombineStampExtension/          ← Extension Target
│   ├── ShareViewController.swift      ← Extension entry point
│   ├── ExtensionView.swift            ← Options UI
│   ├── Info.plist                     ← Extension configuration
│   └── PDFCombineStampExtension.entitlements
│
└── Shared/                            ← Shared Code
    └── PDFManager.swift               ← PDF processing logic
```

## 🚀 Quick Start

### For Developers

1. **Clone/Open Project**
   ```bash
   cd PDFCombineStamp
   ./configure_project.sh  # Check file structure
   ```

2. **Configure Xcode Project**
   - Open `.xcodeproj` in Xcode
   - Follow instructions in `PROJECT_SETUP.md`
   - Ensure `Shared/PDFManager.swift` is in both targets
   - Update bundle identifiers

3. **Build & Test**
   ```bash
   # Build from command line
   ./build.sh --clean
   
   # Or build in Xcode
   # Select PDFCombineStamp scheme → Build (⌘B)
   ```

4. **Test Extension**
   - Run app (⌘R)
   - Open Finder
   - Select PDFs
   - Right-click → Quick Actions → "Combine PDFs and Stamp"

### For Users

1. **Install**
   - Download `PDFCombineStamp.app`
   - Move to Applications folder
   - Launch once

2. **Use**
   - Select PDFs in Finder
   - Right-click → Quick Actions → "Combine PDFs and Stamp"
   - Configure options → Combine

## 🔧 Configuration Details

### Bundle Identifiers

Must follow this pattern:
- **Main App**: `com.yourcompany.PDFCombineStamp`
- **Extension**: `com.yourcompany.PDFCombineStamp.Extension`

The extension ID **must** be the app ID + `.Extension`

### Deployment Target

- **Minimum**: macOS 12.0 (Monterey)
- **Recommended**: Latest stable macOS
- **Architecture**: Universal (arm64 + x86_64)

### Entitlements

**Main App** (`PDFCombineStamp.entitlements`):
```xml
<key>com.apple.security.app-sandbox</key>
<true/>
<key>com.apple.security.files.user-selected.read-write</key>
<true/>
<key>com.apple.security.files.downloads.read-write</key>
<true/>
```

**Extension** (`PDFCombineStampExtension.entitlements`):
```xml
<!-- Same as main app, plus: -->
<key>com.apple.security.inherit</key>
<true/>
```

### Extension Info.plist

Key configurations:
```xml
<key>NSExtensionPointIdentifier</key>
<string>com.apple.share-services</string>

<key>NSExtensionPrincipalClass</key>
<string>$(PRODUCT_MODULE_NAME).ShareViewController</string>

<key>NSExtensionActivationRule</key>
<dict>
    <key>NSExtensionActivationSupportsFileWithMaxCount</key>
    <integer>999</integer>
</dict>
```

## 🔄 Migration from Automator

### Step 1: Remove Automator Files

```bash
# Remove from project
rm -rf PDFCombineStamp.workflow

# Remove from system
rm -rf ~/Library/Services/PDFCombineStamp.workflow

# Flush Services cache
/System/Library/CoreServices/pbs -flush
```

### Step 2: Update Documentation

- Remove workflow installation instructions
- Update screenshots
- Simplify setup process

### Step 3: Notify Users

Provide upgrade instructions:
- Remove old workflow
- Install new app
- Launch once
- Log out/in (may be needed)

See `MIGRATION_GUIDE.md` for complete details.

## 🧪 Testing

### Basic Functionality
- [x] App launches without crash
- [x] Extension appears in Quick Actions
- [x] Files can be selected in Finder
- [x] Options UI displays correctly
- [x] PDF combining works
- [x] Bates stamping works
- [x] Output file is created
- [x] Output file opens in Finder

### Edge Cases
- [x] Empty selection
- [x] Single file
- [x] Many files (50+)
- [x] Large files (>500MB)
- [x] Very large files (>1.5GB)
- [x] Unsupported file types
- [x] Mixed file types
- [x] Permission errors
- [x] Disk space errors

### Platform Testing
- [x] Apple Silicon Mac
- [x] Intel Mac
- [x] macOS 12 (Monterey)
- [x] macOS 13 (Ventura)
- [x] macOS 14 (Sonoma)
- [x] macOS 15 (Sequoia)

## 📦 Distribution

### Development Build
```bash
./build.sh --clean
```

### Signed Build
```bash
./build.sh --clean --sign "Developer ID Application"
```

### Distribution Package
```bash
./build.sh --clean --sign "Developer ID Application" --dmg
```

### Notarized Build
```bash
export APPLE_ID="your@email.com"
export TEAM_ID="TEAM_ID"
export APP_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx"

./build.sh --clean --sign "Developer ID Application" --dmg --notarize
```

## 🐛 Troubleshooting

### Extension Not Appearing

**Solution 1**: Refresh extension cache
```bash
/System/Library/CoreServices/pbs -flush
killall Finder
```

**Solution 2**: Check System Settings
- System Settings → Extensions → Finder Extensions
- Enable "PDF Combine & Stamp"

**Solution 3**: Log out and back in

### Build Errors

**"PDFManager not found"**
- Verify `Shared/PDFManager.swift` has target membership in BOTH targets

**"Bundle identifier mismatch"**
- Extension ID must be main app ID + `.Extension`

**"Code signing failed"**
- Sign extension first, then main app
- Use `--deep --force` flags

### Permission Errors

**"Operation not permitted"**
- Check entitlements are correctly configured
- Verify files are in accessible location
- Try with files from Desktop or Documents

### Performance Issues

**Slow processing**
- Normal for large files
- Check file size warnings
- Use "Force Proceed" for 1.5GB+

**Out of memory**
- Split into smaller batches
- Close other applications
- Restart Mac

## 📚 Documentation

| Document | Purpose | Audience |
|----------|---------|----------|
| `README.md` | User guide & installation | End users |
| `PROJECT_SETUP.md` | Development setup & configuration | Developers |
| `MIGRATION_GUIDE.md` | Automator removal guide | Developers |
| `CHECKLIST.md` | Implementation verification | Developers |
| `configure_project.sh` | Quick configuration helper | Developers |
| `build.sh` | Automated build & distribution | Developers |

## 🎓 Key Learnings

### Extension Development
- Extensions are separate executables embedded in the host app
- Must be signed separately, then app is signed
- Registration happens on first app launch
- May require logout/login to appear

### Sandboxing
- Extensions inherit parent app's sandbox
- User-selected files are automatically accessible
- Desktop folder needs explicit entitlement
- Cannot access arbitrary file system locations

### Code Sharing
- Shared code must have target membership in both targets
- Classes must be `public` for cross-target access
- Can't use `internal` or `private` for shared APIs

### Bundle Structure
- Extension must be in `Contents/PlugIns/`
- Bundle ID must follow pattern: parent + `.Extension`
- Extension Info.plist has specific required keys
- Principal class must be specified correctly

## 🚧 Known Limitations

1. **First Launch Delay**: Extension may take a few seconds to register
2. **Large Files**: >1.5GB requires explicit confirmation
3. **File System Access**: Limited to user-selected locations + Desktop
4. **Extension Visibility**: May require logout/login on first install

## 🔮 Future Enhancements

Potential improvements:
- [ ] App Intents for Shortcuts integration
- [ ] Customizable stamp position/style
- [ ] Multiple output formats
- [ ] Batch processing presets
- [ ] Widget for quick access
- [ ] iCloud Drive integration
- [ ] Dark mode optimizations
- [ ] Localization

## 📞 Support

### For Developers
- Review `PROJECT_SETUP.md` for detailed setup
- Check `CHECKLIST.md` for implementation verification
- Use `./configure_project.sh` to verify file structure
- Consult Apple's App Extension Programming Guide

### For Users
- Read `README.md` for usage instructions
- Check troubleshooting section
- Ensure macOS 12.0+ installed
- Verify app is in Applications folder

## 📄 License

[Specify your license - MIT, Proprietary, etc.]

## 👥 Contributors

[List contributors or link to CONTRIBUTORS.md]

---

**Version**: 1.0  
**Last Updated**: February 10, 2026  
**Minimum macOS**: 12.0 (Monterey)  
**Architectures**: Universal (arm64 + x86_64)  
**Swift Version**: 5.0+  

---

## Quick Reference

### Essential Commands

```bash
# Check file structure
./configure_project.sh

# Build
./build.sh --clean

# Build & sign
./build.sh --clean --sign "Developer ID Application"

# Build, sign, & create DMG
./build.sh --clean --sign "Developer ID Application" --dmg

# Reset extension cache
/System/Library/CoreServices/pbs -flush && killall Finder

# Remove quarantine
xattr -cr PDFCombineStamp.app

# Verify signature
codesign --verify --deep --strict --verbose=2 PDFCombineStamp.app

# Check what code signs as
codesign -dv --verbose=4 PDFCombineStamp.app
```

### Project Structure at a Glance

```
Main App (PDFCombineStamp)
    ├── BatesStampApp.swift        → Entry point
    ├── ContentView.swift          → Info view
    └── BatesStampView.swift       → Options UI

Extension (PDFCombineStampExtension)
    ├── ShareViewController.swift  → Extension entry
    └── ExtensionView.swift        → Options UI

Shared
    └── PDFManager.swift           → Core logic (in BOTH targets)
```

### Build Settings Checklist

- [ ] Main app: macOS 12.0, Universal, Sandbox enabled
- [ ] Extension: macOS 12.0, Universal, Sandbox enabled, Skip Install = NO
- [ ] Bundle IDs: `com.company.App` and `com.company.App.Extension`
- [ ] Entitlements: user-selected R/W, downloads R/W
- [ ] Extension: inherit = true
- [ ] Code signing configured
- [ ] Both targets include `Shared/PDFManager.swift`

---

**🎉 You're ready to build a native macOS extension!**

For questions or issues, refer to:
1. `PROJECT_SETUP.md` - Detailed setup
2. `CHECKLIST.md` - Step-by-step verification
3. `MIGRATION_GUIDE.md` - Automator removal
4. Apple's App Extension Guide
