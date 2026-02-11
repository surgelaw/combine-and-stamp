# Build Error Fixes

## Issues Found

The build errors you encountered are due to:

1. ❌ **Old PDFManager.swift still in target** - Conflicting with Shared/PDFManager.swift
2. ❌ **extensionContext property conflict** - Fixed in ShareViewController
3. ❌ **Missing target membership** - Files not added to correct targets

## Quick Fix Steps

### 1. Remove Old PDFManager from Targets

**Option A: In Xcode (Recommended)**
1. Select `PDFManager.swift` (root level, NOT in Shared/)
2. Open File Inspector (⌘⌥1)
3. Under "Target Membership":
   - ❌ Uncheck `PDFCombineStamp`
   - ❌ Uncheck `PDFCombineStampExtension`
4. (Optional) Delete the file completely

**Option B: Delete the File**
1. Select `PDFManager.swift` (root level)
2. Right-click → Delete
3. Choose "Move to Trash"

### 2. Verify Shared/PDFManager.swift Target Membership

1. Select `Shared/PDFManager.swift`
2. Open File Inspector (⌘⌥1)
3. Under "Target Membership":
   - ✅ Check `PDFCombineStamp`
   - ✅ Check `PDFCombineStampExtension`

### 3. Add Extension Files to Extension Target

**ShareViewController.swift:**
1. Select `PDFCombineStampExtension/ShareViewController.swift`
2. File Inspector → Target Membership:
   - ❌ Uncheck `PDFCombineStamp` (if checked)
   - ✅ Check `PDFCombineStampExtension`

**ExtensionView.swift:**
1. Select `PDFCombineStampExtension/ExtensionView.swift`
2. File Inspector → Target Membership:
   - ❌ Uncheck `PDFCombineStamp` (if checked)
   - ✅ Check `PDFCombineStampExtension`

### 4. Verify Main App Files

**BatesStampApp.swift:**
1. Target Membership:
   - ✅ Check `PDFCombineStamp`
   - ❌ Uncheck `PDFCombineStampExtension`

**BatesStampView.swift:**
1. Target Membership:
   - ✅ Check `PDFCombineStamp`
   - ❌ Uncheck `PDFCombineStampExtension` (not needed)

**ContentView.swift:**
1. Target Membership:
   - ✅ Check `PDFCombineStamp`
   - ❌ Uncheck `PDFCombineStampExtension` (not needed)

### 5. Clean and Build

```bash
# Clean
Shift + Cmd + K

# Build
Cmd + B
```

## Target Membership Summary

Here's what should be in each target:

### PDFCombineStamp (Main App)
```
✅ BatesStampApp.swift
✅ ContentView.swift
✅ BatesStampView.swift
✅ Shared/PDFManager.swift
❌ ShareViewController.swift
❌ ExtensionView.swift
```

### PDFCombineStampExtension (Extension)
```
❌ BatesStampApp.swift
❌ ContentView.swift
❌ BatesStampView.swift
✅ Shared/PDFManager.swift
✅ ShareViewController.swift
✅ ExtensionView.swift
```

### Neither Target (Removed)
```
❌ PDFManager.swift (root level - should be removed)
```

## Verification Checklist

After making changes:

- [ ] Old `PDFManager.swift` removed from all targets (or deleted)
- [ ] `Shared/PDFManager.swift` in BOTH targets
- [ ] Extension files ONLY in extension target
- [ ] Main app files ONLY in main app target
- [ ] Clean build succeeds (Shift+Cmd+K, then Cmd+B)
- [ ] No duplicate symbol errors
- [ ] No ambiguous reference errors

## If You Still Have Errors

### "Cannot find 'PDFManager' in scope"

**Solution**: Make sure `Shared/PDFManager.swift` is in the target that's failing:
- Failing in main app? Add to `PDFCombineStamp` target
- Failing in extension? Add to `PDFCombineStampExtension` target

### "Duplicate symbol '_$s14PDFManager...'"

**Solution**: The old `PDFManager.swift` is still in a target:
- Find it in Project Navigator
- Remove from Target Membership
- Or delete the file

### "Type 'PDFManager' has no member 'shared'"

**Solution**: Check that `Shared/PDFManager.swift` has:
```swift
public class PDFManager {
    public static let shared = PDFManager()
    public init() {}
    // ...
}
```

### Build Still Failing?

Try a deep clean:
```bash
# In Xcode:
1. Product → Clean Build Folder (Shift+Cmd+K)
2. Close Xcode
3. Delete derived data:
   rm -rf ~/Library/Developer/Xcode/DerivedData/PDFCombineStamp-*
4. Reopen Xcode
5. Build (Cmd+B)
```

## Visual Guide: File Structure

```
Project Navigator Should Look Like:

PDFCombineStamp (project)
├── PDFCombineStamp (main app group)
│   ├── BatesStampApp.swift          [✓ PDFCombineStamp]
│   ├── ContentView.swift             [✓ PDFCombineStamp]
│   ├── BatesStampView.swift          [✓ PDFCombineStamp]
│   └── PDFCombineStamp.entitlements
│
├── PDFCombineStampExtension (extension group)
│   ├── ShareViewController.swift     [✓ Extension]
│   ├── ExtensionView.swift           [✓ Extension]
│   ├── Info.plist
│   └── PDFCombineStampExtension.entitlements
│
├── Shared (shared group)
│   └── PDFManager.swift              [✓ PDFCombineStamp ✓ Extension]
│
└── PDFManager.swift (OLD - DELETE!)  [  no targets  ]
```

## Expected Build Output

After fixes, you should see:

```
✓ Build target PDFCombineStamp
  Compile 4 sources (BatesStampApp, ContentView, BatesStampView, PDFManager)
  Link PDFCombineStamp

✓ Build target PDFCombineStampExtension
  Compile 3 sources (ShareViewController, ExtensionView, PDFManager)
  Link PDFCombineStampExtension.appex

✓ Embed PDFCombineStampExtension.appex in PDFCombineStamp.app

✓ Build Succeeded
```

## Need More Help?

Run the diagnostics script:
```bash
./configure_project.sh
```

This will check your file structure and identify missing files.

---

**Most Common Fix**: Just remove the old `PDFManager.swift` from targets and add `Shared/PDFManager.swift` to both targets!
