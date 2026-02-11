# Implementation Checklist

This checklist ensures all steps are completed for the native extension migration.

## ✅ Phase 1: File Structure

- [ ] Created `Shared/PDFManager.swift` with public interface
- [ ] Created `PDFCombineStampExtension/ShareViewController.swift`
- [ ] Created `PDFCombineStampExtension/ExtensionView.swift`
- [ ] Created `PDFCombineStampExtension/Info.plist`
- [ ] Created `PDFCombineStampExtension/PDFCombineStampExtension.entitlements`
- [ ] Created `PDFCombineStamp.entitlements`
- [ ] Created `ContentView.swift` for main app
- [ ] Updated `BatesStampApp.swift` with new architecture
- [ ] Added deprecation notice to old `PDFManager.swift`

## ✅ Phase 2: Xcode Project Configuration

### Main App Target (PDFCombineStamp)

- [ ] Target created/verified
- [ ] Set deployment target to macOS 12.0
- [ ] Set architectures to `$(ARCHS_STANDARD)` (arm64 + x86_64)
- [ ] Set bundle identifier: `com.yourcompany.PDFCombineStamp`
- [ ] Added to target membership:
  - [ ] `BatesStampApp.swift`
  - [ ] `ContentView.swift`
  - [ ] `BatesStampView.swift`
  - [ ] `Shared/PDFManager.swift`
- [ ] Configured entitlements file: `PDFCombineStamp.entitlements`
- [ ] Enabled App Sandbox in Signing & Capabilities
- [ ] Enabled Hardened Runtime (for distribution)
- [ ] Configured code signing identity

### Extension Target (PDFCombineStampExtension)

- [ ] Extension target created (Share Extension)
- [ ] Set deployment target to macOS 12.0
- [ ] Set architectures to `$(ARCHS_STANDARD)`
- [ ] Set bundle identifier: `com.yourcompany.PDFCombineStamp.Extension`
- [ ] Verified "Skip Install" is set to NO
- [ ] Added to target membership:
  - [ ] `PDFCombineStampExtension/ShareViewController.swift`
  - [ ] `PDFCombineStampExtension/ExtensionView.swift`
  - [ ] `Shared/PDFManager.swift`
- [ ] Replaced default Info.plist with custom one
- [ ] Configured entitlements file: `PDFCombineStampExtension.entitlements`
- [ ] Enabled App Sandbox in Signing & Capabilities
- [ ] Configured code signing identity
- [ ] Verified extension is embedded in main app

### Shared Code

- [ ] `Shared/PDFManager.swift` has target membership in BOTH targets:
  - [ ] PDFCombineStamp (main app)
  - [ ] PDFCombineStampExtension
- [ ] Made class and methods `public`
- [ ] Added `public init()` to PDFManager

## ✅ Phase 3: Info.plist Configuration

### Main App Info.plist

- [ ] Set `CFBundleDisplayName` to "PDF Combine & Stamp"
- [ ] Set `CFBundleShortVersionString` to current version
- [ ] Set `NSHumanReadableCopyright`
- [ ] Verified application category (optional)

### Extension Info.plist

- [ ] Set `NSExtensionPointIdentifier` to `com.apple.share-services`
- [ ] Set `NSExtensionPrincipalClass` to `ShareViewController`
- [ ] Configured `NSExtensionActivationRule`:
  - [ ] `NSExtensionActivationSupportsFileWithMaxCount` = 999
- [ ] Set `NSExtensionServiceTitleKey` to "Combine PDFs and Stamp"
- [ ] Enabled `NSExtensionServiceAllowsFinderPreviewItem`
- [ ] Set bundle display name

## ✅ Phase 4: Entitlements

### Main App Entitlements (PDFCombineStamp.entitlements)

```xml
- [ ] com.apple.security.app-sandbox = true
- [ ] com.apple.security.files.user-selected.read-write = true
- [ ] com.apple.security.files.downloads.read-write = true
```

### Extension Entitlements (PDFCombineStampExtension.entitlements)

```xml
- [ ] com.apple.security.app-sandbox = true
- [ ] com.apple.security.files.user-selected.read-write = true
- [ ] com.apple.security.files.downloads.read-write = true
- [ ] com.apple.security.inherit = true
```

## ✅ Phase 5: Build & Test

### Building

- [ ] Clean build folder (Shift + Cmd + K)
- [ ] Build main app target (Cmd + B)
- [ ] Verify no build errors
- [ ] Verify no warnings (or address important ones)
- [ ] Check that extension is embedded in app bundle:
  ```
  PDFCombineStamp.app/Contents/PlugIns/PDFCombineStampExtension.appex
  ```

### Testing Main App

- [ ] Run main app (Cmd + R)
- [ ] Verify ContentView displays correctly
- [ ] Check window title and styling
- [ ] Verify app doesn't crash on launch

### Testing Extension (Manual)

- [ ] Build and run main app
- [ ] Open Finder
- [ ] Select 2-3 PDF files
- [ ] Right-click on selection
- [ ] Verify "Combine PDFs and Stamp" appears in Quick Actions
  - If not, also check Services submenu
- [ ] Click the action
- [ ] Verify extension UI appears
- [ ] Test file validation (supported/unsupported)
- [ ] Test with PDF files
- [ ] Test with image files
- [ ] Test with mixed files
- [ ] Test Bates stamping enabled
- [ ] Test Bates stamping disabled
- [ ] Test prefix customization
- [ ] Test starting number customization
- [ ] Test cancel button
- [ ] Test process button
- [ ] Verify output file created
- [ ] Verify output file opened in Finder

### Testing Extension (Debugging)

- [ ] Select extension scheme: `PDFCombineStampExtension`
- [ ] Edit Scheme → Run → Executable: "Ask on Launch"
- [ ] Run (Cmd + R)
- [ ] Choose Finder.app when prompted
- [ ] Trigger extension from Finder
- [ ] Verify breakpoints work
- [ ] Check console output

## ✅ Phase 6: Edge Cases & Error Handling

- [ ] Test with no files selected (shouldn't appear in menu)
- [ ] Test with 1 file
- [ ] Test with many files (10+, 50+)
- [ ] Test with very large files (>500MB)
- [ ] Test with extremely large files (>1.5GB)
- [ ] Test "Force Proceed" toggle for large files
- [ ] Test with corrupted PDF
- [ ] Test with unsupported file types
- [ ] Test with mixed supported/unsupported
- [ ] Test permission errors
- [ ] Test read-only destination
- [ ] Test insufficient disk space
- [ ] Test output file name conflicts
- [ ] Test cancellation during processing
- [ ] Test background/foreground transitions

## ✅ Phase 7: Code Quality

### Code Review

- [ ] All Swift code follows conventions
- [ ] No force unwraps in critical paths
- [ ] Proper error handling everywhere
- [ ] Memory management (autoreleasepool for large loops)
- [ ] Thread safety (proper async/await or DispatchQueue usage)
- [ ] No hardcoded strings (use constants where appropriate)
- [ ] Comments for complex logic
- [ ] TODO/FIXME items resolved or documented

### Performance

- [ ] Large file processing uses autoreleasepool
- [ ] UI remains responsive during processing
- [ ] Progress indicator appears immediately
- [ ] No memory leaks (tested with Instruments)
- [ ] Efficient PDF operations

## ✅ Phase 8: Documentation

- [ ] `README.md` created/updated
- [ ] `PROJECT_SETUP.md` created
- [ ] `MIGRATION_GUIDE.md` created
- [ ] Code comments added where needed
- [ ] User instructions are clear
- [ ] Developer setup instructions complete
- [ ] Troubleshooting section included

## ✅ Phase 9: Distribution Preparation

### Code Signing

- [ ] Developer ID certificate obtained
- [ ] Main app signing works
- [ ] Extension signing works
- [ ] Signature verification passes
- [ ] Hardened runtime enabled
- [ ] Correct entitlements applied

### Notarization (if distributing outside App Store)

- [ ] App-specific password created
- [ ] Notarization submitted successfully
- [ ] Notarization approved
- [ ] Ticket stapled to app
- [ ] Ticket stapled to DMG (if using)

### Packaging

- [ ] DMG created (optional)
- [ ] DMG includes app
- [ ] DMG includes Applications symlink
- [ ] DMG appearance customized (optional)
- [ ] Or: ZIP archive created
- [ ] Installation instructions included

## ✅ Phase 10: Pre-Release Testing

### Fresh Install Testing

- [ ] Uninstall any previous versions
- [ ] Install new version
- [ ] Launch app for first time
- [ ] Verify extension appears in Finder
  - If not: log out and back in
- [ ] Test basic workflow
- [ ] Verify no crashes or errors

### Multi-User Testing

- [ ] Test on fresh user account
- [ ] Test with different permission sets
- [ ] Test on various macOS versions:
  - [ ] macOS 12 (Monterey)
  - [ ] macOS 13 (Ventura)
  - [ ] macOS 14 (Sonoma)
  - [ ] macOS 15 (Sequoia) if available

### Architecture Testing

- [ ] Test on Apple Silicon Mac
- [ ] Test on Intel Mac (if available)
- [ ] Verify universal binary works on both

## ✅ Phase 11: Remove Automator Artifacts

- [ ] Removed `.workflow` directory from project
- [ ] Removed workflow from git (if applicable)
- [ ] Removed workflow-related build scripts
- [ ] Removed workflow-related documentation
- [ ] Updated all references to old installation process
- [ ] Removed old workflows from development machine:
  ```bash
  rm -rf ~/Library/Services/PDFCombineStamp.workflow
  ```
- [ ] Flushed Services cache:
  ```bash
  /System/Library/CoreServices/pbs -flush
  ```

## ✅ Phase 12: Final Verification

- [ ] All files committed to version control
- [ ] Git tags created for release version
- [ ] Build script works (`./build.sh`)
- [ ] Distribution package tested
- [ ] README instructions followed successfully
- [ ] No Automator references remain
- [ ] Extension registers on first launch
- [ ] All functionality works as expected
- [ ] Performance is acceptable
- [ ] No memory leaks
- [ ] No crashes or hangs

## ✅ Phase 13: Release Preparation

- [ ] Version number updated in project
- [ ] Release notes written
- [ ] Screenshots prepared (optional)
- [ ] Website/documentation updated
- [ ] Distribution channels prepared
- [ ] Support resources ready
- [ ] Rollback plan documented

## ✅ Phase 14: Post-Release

- [ ] Monitor for user issues
- [ ] Check crash reports
- [ ] Respond to feedback
- [ ] Plan next iteration
- [ ] Archive build for reference

---

## Quick Reference Commands

### Build Project
```bash
xcodebuild -scheme PDFCombineStamp -configuration Release build
```

### Sign Extension
```bash
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application" \
  --entitlements PDFCombineStampExtension/PDFCombineStampExtension.entitlements \
  --options runtime \
  PDFCombineStamp.app/Contents/PlugIns/PDFCombineStampExtension.appex
```

### Sign Main App
```bash
codesign --deep --force --verify --verbose \
  --sign "Developer ID Application" \
  --entitlements PDFCombineStamp.entitlements \
  --options runtime \
  PDFCombineStamp.app
```

### Verify Signature
```bash
codesign --verify --deep --strict --verbose=2 PDFCombineStamp.app
spctl -a -vv PDFCombineStamp.app
```

### Submit for Notarization
```bash
xcrun notarytool submit PDFCombineStamp.zip \
  --apple-id "your@email.com" \
  --team-id "TEAM_ID" \
  --password "app-specific-password" \
  --wait
```

### Staple Notarization
```bash
xcrun stapler staple PDFCombineStamp.app
```

### Check Extension in Bundle
```bash
ls -la PDFCombineStamp.app/Contents/PlugIns/
```

### Reset Extension Cache (if not appearing)
```bash
/System/Library/CoreServices/pbs -flush
killall Finder
```

---

## Troubleshooting Quick Fixes

**Extension not appearing**: 
- Launch app once, log out/in, check System Settings → Extensions

**Build errors**:
- Clean build folder, verify target memberships, check bundle IDs

**Signing errors**:
- Verify certificates, check entitlements, ensure extension signed first

**Permission errors**:
- Check entitlements, verify sandboxing, test with different file locations

---

**Last Updated**: February 10, 2026
