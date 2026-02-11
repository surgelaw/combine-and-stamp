# 🚀 Quick Start Guide

Get up and running with the native extension in 5 minutes!

## ⚡ For Developers (First Time Setup)

### Step 1: Verify Files (30 seconds)
```bash
chmod +x configure_project.sh build.sh test_extension.sh
./configure_project.sh
```

### Step 2: Open in Xcode (30 seconds)
```bash
open PDFCombineStamp.xcodeproj
```

### Step 3: Configure Targets (2 minutes)

**A) Create Extension Target** (if not exists):
- File → New → Target → macOS → **Share Extension**
- Product Name: `PDFCombineStampExtension`
- Embed in: `PDFCombineStamp`
- Click Finish

**B) Update Main App Bundle ID**:
- Select project → PDFCombineStamp target
- General → Bundle Identifier: `com.yourcompany.PDFCombineStamp`

**C) Update Extension Bundle ID**:
- Select PDFCombineStampExtension target
- General → Bundle Identifier: `com.yourcompany.PDFCombineStamp.Extension`
- ⚠️ Must be main app ID + `.Extension`

**D) Link Shared Code**:
- Select `Shared/PDFManager.swift` in Project Navigator
- File Inspector (⌘⌥1) → Target Membership
- ✓ Check BOTH: `PDFCombineStamp` AND `PDFCombineStampExtension`

### Step 4: Build & Run (1 minute)
```bash
# In Xcode:
# Select PDFCombineStamp scheme
# Press ⌘B to build
# Press ⌘R to run
```

### Step 5: Test (1 minute)
```bash
./test_extension.sh test
# This opens Finder with test PDFs
# Right-click → Quick Actions → "Combine PDFs and Stamp"
```

**Done! 🎉**

---

## 🎯 For Developers (Daily Development)

### Build
```bash
./build.sh --clean
```

### Debug Extension
1. Select `PDFCombineStampExtension` scheme in Xcode
2. Edit Scheme → Run → Executable: Choose "Ask on Launch"
3. Run (⌘R)
4. Choose Finder when prompted
5. Trigger extension from Finder
6. Xcode debugger attaches!

### Quick Test
```bash
./test_extension.sh
# Interactive menu:
# 1 = Check status
# 2 = Create test files
# 3 = Reset cache
```

---

## 📦 For Developers (Distribution)

### Build Signed Release
```bash
# Make sure you have Developer ID certificate installed
./build.sh --clean --sign "Developer ID Application: Your Name (TEAMID)"
```

### Build DMG
```bash
./build.sh --clean --sign "Developer ID Application: Your Name" --dmg
```

### Notarize (Optional)
```bash
export APPLE_ID="your@email.com"
export TEAM_ID="YOUR_TEAM_ID"
export APP_SPECIFIC_PASSWORD="xxxx-xxxx-xxxx-xxxx"

./build.sh --clean --sign "Developer ID Application" --dmg --notarize
```

**Distribution files are in: `build/`**

---

## 👤 For End Users

### Install
1. Download `PDFCombineStamp.app`
2. Drag to Applications folder
3. Double-click to launch once
4. Done!

### Use
1. Select PDF/image files in Finder
2. Right-click on selection
3. Choose **Quick Actions → Combine PDFs and Stamp**
4. Configure options
5. Click "Combine and Stamp"
6. Output opens in Finder automatically

**If extension doesn't appear:**
- Log out and back in
- Check System Settings → Extensions → Finder Extensions

---

## 🔧 Common Issues & Quick Fixes

### "Extension not appearing"
```bash
./test_extension.sh reset
# Then log out and back in
```

### "Build error: PDFManager not found"
✓ Check target membership of `Shared/PDFManager.swift` (must be in BOTH targets)

### "Code signing failed"
Sign extension first, then main app:
```bash
codesign --deep --force --sign "Developer ID" \
  --entitlements PDFCombineStampExtension/PDFCombineStampExtension.entitlements \
  build/PDFCombineStamp.app/Contents/PlugIns/PDFCombineStampExtension.appex

codesign --deep --force --sign "Developer ID" \
  --entitlements PDFCombineStamp.entitlements \
  build/PDFCombineStamp.app
```

### "Extension bundle not found"
Check that extension target:
- Has Skip Install = NO
- Is set to Embed in Application
- Build Settings → Product Name = PDFCombineStampExtension

---

## 📋 Checklists

### ✅ First Build Checklist
- [ ] Extension target created
- [ ] Bundle IDs set (app + app.Extension)
- [ ] Shared/PDFManager.swift in BOTH targets
- [ ] Entitlements files configured
- [ ] App builds without errors
- [ ] Extension embedded in app bundle
- [ ] Test files work

### ✅ Before Distribution Checklist  
- [ ] Version number updated
- [ ] Code signed with Developer ID
- [ ] Signature verified
- [ ] Notarized (if distributing outside App Store)
- [ ] DMG created
- [ ] Tested on clean Mac
- [ ] README updated

---

## 📚 Documentation Quick Links

| Need to... | Read... |
|------------|---------|
| Understand architecture | `IMPLEMENTATION_SUMMARY.md` |
| Set up Xcode project | `PROJECT_SETUP.md` |
| Remove Automator | `MIGRATION_GUIDE.md` |
| Verify implementation | `CHECKLIST.md` |
| Help end users | `README.md` |

---

## 💡 Pro Tips

### Development
- Use `./test_extension.sh` frequently during development
- Debug extension by selecting its scheme and choosing Finder as executable
- Check console output with: `log stream --predicate 'subsystem contains "PDFCombineStamp"'`

### Testing
- Test with various file counts (1, 10, 50, 100+)
- Test with large files to trigger warnings
- Test permission edge cases (network volumes, read-only)
- Test on both Intel and Apple Silicon if possible

### Distribution
- Always test signed build before distributing
- Test on a fresh user account
- Verify extension appears without manual steps
- Include clear installation instructions

---

## 🎓 Learning Resources

**Apple Documentation**:
- [App Extension Programming Guide](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/)
- [Share Extension](https://developer.apple.com/documentation/foundation/nsextensioncontext)
- [Code Signing Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/)

**This Project**:
- Full architecture: `IMPLEMENTATION_SUMMARY.md`
- Detailed setup: `PROJECT_SETUP.md`
- Step-by-step: `CHECKLIST.md`

---

## 🎬 Next Steps

### Just Starting?
1. Run `./configure_project.sh` to verify files
2. Open project in Xcode
3. Follow **Step 3** above to configure targets
4. Build and test with `./test_extension.sh`

### Ready to Distribute?
1. Complete `CHECKLIST.md` verification
2. Build signed version with `./build.sh`
3. Test on clean Mac
4. Distribute!

### Migrating from Automator?
1. Read `MIGRATION_GUIDE.md`
2. Remove .workflow files
3. Update documentation
4. Notify users of new version

---

## 🆘 Need Help?

1. **Check the docs**: Most questions answered in:
   - `PROJECT_SETUP.md` (setup issues)
   - `CHECKLIST.md` (verification)
   - `MIGRATION_GUIDE.md` (Automator removal)

2. **Run diagnostics**:
   ```bash
   ./test_extension.sh check
   ```

3. **Common issues**: See "Common Issues & Quick Fixes" above

4. **Clean slate**:
   ```bash
   # Clean Xcode
   rm -rf ~/Library/Developer/Xcode/DerivedData/PDFCombineStamp-*
   
   # Clean build
   ./build.sh --clean
   
   # Reset extension cache
   ./test_extension.sh reset
   ```

---

**⏱️ Total Setup Time: ~5 minutes**  
**📝 Full Documentation: See `IMPLEMENTATION_SUMMARY.md`**  
**🎯 Ready to build? Let's go! 🚀**
