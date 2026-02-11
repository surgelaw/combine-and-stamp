# Installation Guide

Complete guide for installing PDFCombineStamp locally and on test machines.

---

## 📋 Table of Contents

1. [Local Development Installation](#local-development-installation)
2. [Test Machine Installation](#test-machine-installation)
3. [Troubleshooting](#troubleshooting)
4. [Uninstallation](#uninstallation)

---

## 🔧 Local Development Installation

### Option 1: Build and Run from Xcode (Easiest)

This installs to a temporary location and runs immediately:

1. **Open Project**
   ```bash
   open PDFCombineStamp.xcodeproj
   ```

2. **Select Scheme**
   - Top toolbar: Select **PDFCombineStamp** scheme
   - Select **My Mac** as destination

3. **Build and Run**
   ```bash
   # Or press: Cmd + R
   ```

4. **Extension Registers Automatically**
   - The app launches and registers the extension
   - Close the info window if desired
   - Extension is now available in Finder

5. **Test It**
   - Open Finder
   - Select some PDF files
   - Right-click → **Quick Actions** → **Combine PDFs and Stamp**

**Note**: This builds to `~/Library/Developer/Xcode/DerivedData/` and doesn't persist after cleaning.

---

### Option 2: Build and Install to Applications (Persistent)

For a more permanent local installation:

1. **Build Release Version**
   ```bash
   # Using build script:
   ./build.sh --clean
   
   # Or in Xcode:
   # Product → Scheme → Edit Scheme → Run → Info → Build Configuration → Release
   # Then: Product → Build (Cmd + B)
   ```

2. **Locate the Built App**
   
   **If using build.sh:**
   ```bash
   # App is in:
   build/PDFCombineStamp.app
   ```
   
   **If using Xcode:**
   ```bash
   # Find it with:
   open ~/Library/Developer/Xcode/DerivedData
   
   # Look for: PDFCombineStamp-*/Build/Products/Release/PDFCombineStamp.app
   ```

3. **Copy to Applications**
   ```bash
   # Using build.sh output:
   cp -R build/PDFCombineStamp.app /Applications/
   
   # Or from Xcode DerivedData:
   cp -R ~/Library/Developer/Xcode/DerivedData/PDFCombineStamp-*/Build/Products/Release/PDFCombineStamp.app /Applications/
   ```

4. **Launch to Register Extension**
   ```bash
   open /Applications/PDFCombineStamp.app
   ```

5. **Verify Extension is Embedded**
   ```bash
   ls -la /Applications/PDFCombineStamp.app/Contents/PlugIns/
   
   # Should show: PDFCombineStampExtension.appex
   ```

6. **Test Extension Registration**
   ```bash
   pluginkit -m -v | grep PDFCombineStamp
   
   # Should show the extension details
   ```

---

### Option 3: Build Script with Automatic Installation

Create a helper script for easy local installation:

```bash
#!/bin/bash
# install-local.sh

echo "Building PDFCombineStamp..."
./build.sh --clean

if [ ! -d "build/PDFCombineStamp.app" ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "Installing to /Applications..."
rm -rf /Applications/PDFCombineStamp.app
cp -R build/PDFCombineStamp.app /Applications/

echo "Launching to register extension..."
open /Applications/PDFCombineStamp.app

echo ""
echo "✅ Installation complete!"
echo ""
echo "Test it:"
echo "  1. Open Finder"
echo "  2. Select PDF files"
echo "  3. Right-click → Quick Actions → 'Combine PDFs and Stamp'"
echo ""
echo "If extension doesn't appear, try:"
echo "  • Log out and back in"
echo "  • Run: /System/Library/CoreServices/pbs -flush && killall Finder"
```

Save as `install-local.sh`, make executable, and run:

```bash
chmod +x install-local.sh
./install-local.sh
```

---

## 🖥️ Test Machine Installation

### Preparation: Build for Distribution

Before installing on test machines, create a proper build:

#### Method 1: Unsigned Build (Quick, Dev Only)

**Best for**: Testing on your own machines where you trust the source

```bash
./build.sh --clean
```

The app will be in: `build/PDFCombineStamp.app`

#### Method 2: Signed Build (Recommended)

**Best for**: Testing on multiple machines, mimicking real distribution

**Prerequisites**:
- Developer ID Application certificate installed
- Certificate from Apple Developer account

```bash
# Sign with your Developer ID:
./build.sh --clean --sign "Developer ID Application: Your Name (TEAMID)"

# The signed app will be in: build/PDFCombineStamp.app
```

#### Method 3: Create DMG (Most Professional)

**Best for**: Sharing with testers, mimicking App Store experience

```bash
./build.sh --clean --sign "Developer ID Application: Your Name" --dmg

# DMG will be in: build/PDFCombineStamp.dmg
```

---

### Transfer Methods

Choose one method to get the app to your test machine:

#### Option A: AirDrop (Easiest)

1. **On Development Mac**:
   - Open Finder
   - Navigate to `build/` folder
   - Right-click `PDFCombineStamp.app` (or `.dmg`)
   - Share → AirDrop → Select test Mac

2. **On Test Mac**:
   - Accept AirDrop
   - File appears in Downloads

#### Option B: Network Share

```bash
# On Development Mac:
# 1. System Settings → General → Sharing → File Sharing → On
# 2. Add build/ folder to shared folders

# On Test Mac:
# 1. Finder → Go → Network
# 2. Connect to development Mac
# 3. Copy PDFCombineStamp.app
```

#### Option C: USB Drive

```bash
# On Development Mac:
cp -R build/PDFCombineStamp.app /Volumes/USB_DRIVE/

# On Test Mac:
cp -R /Volumes/USB_DRIVE/PDFCombineStamp.app ~/Downloads/
```

#### Option D: Cloud Storage

```bash
# Upload to Dropbox, Google Drive, iCloud, etc.
cp -R build/PDFCombineStamp.app ~/Dropbox/

# Download on test Mac from cloud service
```

#### Option E: Git (for team testing)

```bash
# On Development Mac:
# Create a releases branch or tag
git tag -a v1.0-test -m "Test build"

# Build and store in separate repo or use GitHub Releases
# Then download on test Mac
```

---

### Installation on Test Machine

Once you have the app on the test machine:

#### Step 1: Remove Quarantine (Important!)

macOS marks downloaded apps as "quarantined". Remove this:

```bash
# If using DMG:
open PDFCombineStamp.dmg
xattr -cr /Volumes/PDFCombineStamp/PDFCombineStamp.app

# If app is in Downloads:
xattr -cr ~/Downloads/PDFCombineStamp.app
```

**Why this is needed**: Quarantined apps may not register extensions properly.

#### Step 2: Install to Applications

**From DMG**:
```bash
open PDFCombineStamp.dmg
# Drag app to Applications folder icon in DMG window
```

**From Downloads**:
```bash
cp -R ~/Downloads/PDFCombineStamp.app /Applications/
```

**Verify installation**:
```bash
ls -la /Applications/PDFCombineStamp.app
```

#### Step 3: Launch the App

```bash
open /Applications/PDFCombineStamp.app
```

**What happens**:
- App launches and shows info window
- Extension registers with system
- Info window explains how to use it

You can close the window - the extension is now active.

#### Step 4: Verify Extension

**Check system registration**:
```bash
pluginkit -m -v | grep PDFCombineStamp
```

**Expected output**:
```
com.yourcompany.PDFCombineStamp.Extension(1.0)
    Path: /Applications/PDFCombineStamp.app/Contents/PlugIns/PDFCombineStampExtension.appex
    State: Enabled
```

#### Step 5: Test It!

1. Open Finder
2. Navigate to any folder with PDFs
3. Select 2-3 PDF files
4. Right-click on selection
5. Look for: **Quick Actions → Combine PDFs and Stamp**
6. Click it - extension UI should appear

---

### If Extension Doesn't Appear

Try these steps in order:

#### 1. Refresh Extension Cache
```bash
/System/Library/CoreServices/pbs -flush
killall Finder
```

#### 2. Check System Settings
```bash
open "x-apple.systempreferences:com.apple.preferences.extensions"
```

Navigate to: **Extensions → Finder Extensions**

Ensure "Combine PDFs and Stamp" is checked.

#### 3. Log Out and Back In

Sometimes macOS needs a fresh login session:
```bash
# Log out from Apple menu
# Log back in
# Try again
```

#### 4. Re-launch the App
```bash
open /Applications/PDFCombineStamp.app
```

#### 5. Check Gatekeeper (if app is unsigned)
```bash
# If you see "App can't be opened" error:
xattr -cr /Applications/PDFCombineStamp.app

# Then try:
open /Applications/PDFCombineStamp.app
```

#### 6. Verify Extension Bundle
```bash
ls -la /Applications/PDFCombineStamp.app/Contents/PlugIns/

# Should show:
# PDFCombineStampExtension.appex
```

If missing, the extension wasn't embedded during build. Rebuild with:
```bash
./build.sh --clean
```

---

## 🧪 Testing Checklist

Use this checklist on your test machine:

### Installation Testing
- [ ] App copied to /Applications
- [ ] App launches without error
- [ ] Info window displays correctly
- [ ] No Gatekeeper warnings (if signed)
- [ ] Extension embedded in app bundle

### Extension Testing
- [ ] Extension appears in Quick Actions
- [ ] Can invoke from Finder
- [ ] Extension UI displays
- [ ] Can select options (prefix, number)
- [ ] Can toggle Bates stamp
- [ ] Process button works
- [ ] Cancel button works

### Functionality Testing
- [ ] Combines PDF files
- [ ] Combines image files
- [ ] Combines mixed files
- [ ] Skips unsupported files
- [ ] Adds Bates stamps correctly
- [ ] Sequential numbering works
- [ ] Output file created
- [ ] Output file opens in Finder

### Edge Cases
- [ ] Single file
- [ ] Many files (10+)
- [ ] Large files (warning appears)
- [ ] Very large files (force proceed)
- [ ] Unsupported files (shows warning)

### Performance
- [ ] Processing completes
- [ ] No crashes
- [ ] No hangs
- [ ] Memory usage acceptable

---

## 🗑️ Uninstallation

To completely remove the app and extension:

### 1. Quit the App (if running)
```bash
killall PDFCombineStamp
```

### 2. Remove from Applications
```bash
rm -rf /Applications/PDFCombineStamp.app
```

### 3. Clear Extension Cache
```bash
/System/Library/CoreServices/pbs -flush
killall Finder
```

### 4. Remove Extension Registration
```bash
# Find the extension UUID
pluginkit -m -v | grep PDFCombineStamp

# Remove it (use the UUID from above)
pluginkit -r /Applications/PDFCombineStamp.app/Contents/PlugIns/PDFCombineStampExtension.appex
```

### 5. Verify Removal
```bash
# Should return nothing:
pluginkit -m -v | grep PDFCombineStamp

# Extension should not appear in Finder Quick Actions
```

---

## 🔍 Troubleshooting

### "App is damaged and can't be opened"

**Cause**: Gatekeeper quarantine or unsigned app

**Solution**:
```bash
xattr -cr /Applications/PDFCombineStamp.app
```

### "The application cannot be opened"

**Cause**: Missing code signature or wrong architecture

**Solution**:
```bash
# Check architecture:
file /Applications/PDFCombineStamp.app/Contents/MacOS/PDFCombineStamp

# Should show: Mach-O universal binary with 2 architectures
# If not, rebuild with universal binary setting

# Check code signature:
codesign -dv /Applications/PDFCombineStamp.app
```

### Extension Not Appearing After Installation

**Quick Fix**:
```bash
# 1. Remove quarantine
xattr -cr /Applications/PDFCombineStamp.app

# 2. Re-launch
open /Applications/PDFCombineStamp.app

# 3. Flush cache
/System/Library/CoreServices/pbs -flush
killall Finder

# 4. Log out and back in
```

### "Operation not permitted" When Processing Files

**Cause**: Sandbox permissions issue

**Solution**:
- Try with files from Desktop or Documents
- Avoid network drives or restricted folders
- Check entitlements are configured correctly

### Extension Shows but Does Nothing

**Cause**: Extension may be crashing silently

**Debug**:
```bash
# Watch system logs:
log stream --predicate 'subsystem contains "PDFCombineStamp"' --level debug

# In another terminal, trigger the extension
# Look for errors in the log output
```

### Multiple Versions Conflict

**Cause**: Old version still registered

**Solution**:
```bash
# Remove all versions
rm -rf /Applications/PDFCombineStamp.app
mdfind -name PDFCombineStamp.app | xargs rm -rf

# Clear cache
/System/Library/CoreServices/pbs -flush

# Reinstall clean version
```

---

## 📊 Installation Methods Comparison

| Method | Best For | Pros | Cons |
|--------|----------|------|------|
| **Xcode Run** | Quick testing | Fast, automatic | Temporary location |
| **Copy to /Applications** | Daily use | Persistent | Manual process |
| **Install Script** | Frequent rebuilds | Automated | Requires script |
| **DMG** | Distribution | Professional | Extra build step |
| **Signed Build** | Multiple testers | Trusted by macOS | Needs certificate |

---

## 🎯 Recommended Workflow

### For Local Development:
1. Use **Xcode Run** for rapid iteration
2. Occasionally install to `/Applications` to test "real" install
3. Use `install-local.sh` script for convenience

### For Test Machines:
1. Create **signed DMG** with `./build.sh --clean --sign "..." --dmg`
2. Transfer via **AirDrop** or cloud storage
3. Test full installation process
4. Verify extension works correctly
5. Get feedback from testers

### For Distribution:
1. Create **notarized DMG**
2. Host on website or GitHub Releases
3. Provide clear installation instructions
4. Include troubleshooting guide

---

## 📦 Quick Reference Commands

```bash
# Local installation:
./build.sh --clean && cp -R build/PDFCombineStamp.app /Applications/

# Remove quarantine:
xattr -cr /Applications/PDFCombineStamp.app

# Launch:
open /Applications/PDFCombineStamp.app

# Verify extension:
pluginkit -m -v | grep PDFCombineStamp

# Refresh cache:
/System/Library/CoreServices/pbs -flush && killall Finder

# Uninstall:
rm -rf /Applications/PDFCombineStamp.app && /System/Library/CoreServices/pbs -flush

# Watch logs:
log stream --predicate 'subsystem contains "PDFCombineStamp"' --level debug
```

---

## ✅ Installation Complete!

After following these steps, you should have:
- ✅ PDFCombineStamp installed on development machine
- ✅ Extension registered and appearing in Finder
- ✅ Tested on local machine
- ✅ Distributed to test machine(s)
- ✅ Verified functionality on test machines

**Need Help?** Check `BUILD_ERROR_FIXES.md` or `TROUBLESHOOTING.md`

---

**Last Updated**: February 10, 2026  
**Applies To**: PDFCombineStamp v1.0+  
**macOS**: 12.0 (Monterey) and later
