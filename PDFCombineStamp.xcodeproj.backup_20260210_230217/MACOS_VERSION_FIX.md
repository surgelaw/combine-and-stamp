# Fix macOS Version Compatibility

## 🎯 Issue

**Error:** `'NavigationStack' is only available in macOS 13.0 or newer`

**Solution:** Update the minimum macOS deployment target to 13.0 (Ventura)

---

## ✅ Quick Fix (5 minutes)

### Step 1: Open Project Settings

1. In Xcode, click on your **project** (blue icon) at the top of Project Navigator
2. Make sure **PROJECT** "PDFCombineStamp" is selected (not a target)
3. Go to the **Info** tab

### Step 2: Update Minimum Deployment

1. Find **"macOS Deployment Target"** or **"Minimum Deployment"**
2. Change from **macOS 12.0** to **macOS 13.0**

### Step 3: Update Targets

You need to update **both targets**:

#### For PDFCombineStamp (Main App):
1. Select **PDFCombineStamp** target (under TARGETS)
2. Go to **Build Settings** tab
3. Search for "deployment"
4. Find **"macOS Deployment Target"**
5. Set to **macOS 13.0**

#### For PDFCombineStampExtension:
1. Select **PDFCombineStampExtension** target
2. Go to **Build Settings** tab
3. Search for "deployment"
4. Find **"macOS Deployment Target"**
5. Set to **macOS 13.0**

### Step 4: Build Again

Press **⌘B** to build. The error should be gone! ✅

---

## 📋 Detailed Steps with Screenshots Guide

### Method 1: Via Project Settings (Recommended)

1. **Select Project**
   ```
   Project Navigator → Click "PDFCombineStamp" (blue icon at top)
   ```

2. **Project-Level Settings**
   - Select "PDFCombineStamp" under PROJECT (not TARGETS)
   - Click "Info" or "Build Settings" tab
   - Find "macOS Deployment Target"
   - Set to: **13.0**

3. **Target-Level Settings (Both Targets)**
   
   **Main App Target:**
   - Select "PDFCombineStamp" under TARGETS
   - Build Settings tab
   - Search: "deployment"
   - macOS Deployment Target → **13.0**
   
   **Extension Target:**
   - Select "PDFCombineStampExtension" under TARGETS
   - Build Settings tab
   - Search: "deployment"
   - macOS Deployment Target → **13.0**

### Method 2: Via Build Settings Search

1. Select your **project** or **target**
2. Go to **Build Settings** tab
3. In the search box, type: `deployment`
4. Find **"macOS Deployment Target"** or **"MACOSX_DEPLOYMENT_TARGET"**
5. Double-click the value
6. Change to **13.0**
7. Press Enter

---

## 🔍 Verification

After making the changes, verify:

1. **Project Settings:**
   - Project → Info → macOS Deployment Target = **13.0** ✅

2. **Main App Target:**
   - PDFCombineStamp Target → Build Settings → macOS Deployment Target = **13.0** ✅

3. **Extension Target:**
   - PDFCombineStampExtension Target → Build Settings → macOS Deployment Target = **13.0** ✅

4. **Build Succeeds:**
   - Press ⌘B
   - No errors! ✅

---

## 📱 Why macOS 13.0?

**NavigationStack** is a modern SwiftUI component introduced in macOS 13.0 (Ventura). It provides:
- Better navigation performance
- Cleaner API
- More flexibility

**Is this OK?**
- ✅ **Yes!** macOS 13.0 was released in October 2022
- ✅ Most users have updated to Ventura or newer
- ✅ Gives us access to modern SwiftUI features

**Alternative:** We could use the older `NavigationView` if you need to support macOS 12, but `NavigationStack` is the modern approach.

---

## 🛠️ If You Want to Support macOS 12

If you absolutely need macOS 12 support, we can replace `NavigationStack` with `NavigationView`:

```swift
// Instead of:
NavigationStack {
    // content
}

// Use:
NavigationView {
    // content
}
.navigationViewStyle(.stack)
```

But I recommend sticking with **macOS 13.0** and `NavigationStack` for better compatibility with modern SwiftUI.

---

## 📝 Summary

| Setting | Old Value | New Value |
|---------|-----------|-----------|
| Project Deployment Target | macOS 12.0 | macOS 13.0 |
| Main App Target | macOS 12.0 | macOS 13.0 |
| Extension Target | macOS 12.0 | macOS 13.0 |

**After Update:**
- ✅ NavigationStack will work
- ✅ Modern SwiftUI features available
- ✅ App requires macOS 13.0 (Ventura) or newer

---

## ✅ Checklist

- [ ] Open project in Xcode
- [ ] Select PROJECT "PDFCombineStamp"
- [ ] Set macOS Deployment Target to 13.0
- [ ] Select TARGET "PDFCombineStamp"
- [ ] Set macOS Deployment Target to 13.0
- [ ] Select TARGET "PDFCombineStampExtension"
- [ ] Set macOS Deployment Target to 13.0
- [ ] Press ⌘B to build
- [ ] Verify no errors ✅

---

## 🎉 Done!

Once you've updated all three deployment targets to macOS 13.0, the build error will be resolved and you can continue testing!

**Next:** Run the app (⌘R) and test the drag-and-drop functionality!
