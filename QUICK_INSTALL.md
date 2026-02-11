# Quick Installation Instructions

## 🏠 Install Locally (Development Machine)

### Easiest Method: One-Line Install
```bash
chmod +x install-local.sh && ./install-local.sh
```

This script will:
1. Build the app
2. Install to `/Applications`
3. Launch it to register the extension
4. Offer to create test files

---

### Manual Method:
```bash
# 1. Build
./build.sh --clean

# 2. Install
cp -R build/PDFCombineStamp.app /Applications/

# 3. Launch
open /Applications/PDFCombineStamp.app
```

---

## 🖥️ Install on Test Machine

### Step 1: Build on Development Mac
```bash
# For unsigned (quick testing):
./build.sh --clean

# For signed (recommended):
./build.sh --clean --sign "Developer ID Application: Your Name"

# For DMG (most professional):
./build.sh --clean --sign "Developer ID Application: Your Name" --dmg
```

### Step 2: Transfer to Test Mac

**Option A - AirDrop (easiest)**:
- Right-click `build/PDFCombineStamp.app` → Share → AirDrop
- Select test Mac
- Accept on test Mac

**Option B - USB Drive**:
```bash
cp -R build/PDFCombineStamp.app /Volumes/USB_DRIVE/
```

**Option C - Cloud Storage**:
- Upload `build/PDFCombineStamp.app` to Dropbox/Drive/iCloud
- Download on test Mac

### Step 3: Install on Test Mac

```bash
# 1. Remove quarantine (important!)
xattr -cr ~/Downloads/PDFCombineStamp.app

# 2. Copy to Applications
cp -R ~/Downloads/PDFCombineStamp.app /Applications/

# 3. Launch
open /Applications/PDFCombineStamp.app
```

### Step 4: Test It

1. Open Finder
2. Select some PDF files
3. Right-click
4. Choose: **Quick Actions → Combine PDFs and Stamp**

---

## ⚠️ If Extension Doesn't Appear

Try these in order:

### Quick Fix:
```bash
/System/Library/CoreServices/pbs -flush
killall Finder
```

### If Still Not Working:
1. **Check System Settings**:
   - System Settings → Extensions → Finder Extensions
   - Enable "Combine PDFs and Stamp"

2. **Log out and back in**

3. **Verify extension is embedded**:
   ```bash
   ls -la /Applications/PDFCombineStamp.app/Contents/PlugIns/
   # Should show: PDFCombineStampExtension.appex
   ```

---

## 🧪 Quick Test

```bash
# Create test files and open in Finder:
./test_extension.sh test
```

---

## 🗑️ Uninstall

```bash
rm -rf /Applications/PDFCombineStamp.app
/System/Library/CoreServices/pbs -flush
```

---

## 📚 More Details

- **Complete Guide**: See `INSTALLATION_GUIDE.md`
- **Build Issues**: See `BUILD_ERROR_FIXES.md`
- **General Help**: See `INDEX.md`

---

## 🎯 Summary

**Local Dev**: `./install-local.sh`  
**Test Machine**: Build → Transfer → Remove quarantine → Install → Launch  
**Troubleshoot**: Flush cache with `/System/Library/CoreServices/pbs -flush`

That's it! 🎉
