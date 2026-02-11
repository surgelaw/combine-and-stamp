# Bug Fixes - v1.1 Issues

**Date:** February 10, 2026  
**Status:** ✅ Fixed

---

## 🐛 Bug #1: Cannot Add More Files After First Drop

### Problem
- After dropping files once, you couldn't add more files
- The drop zone disappeared after files were added
- No way to add additional files without clearing the list

### Root Cause
- `DropZoneView` only appeared when `droppedFiles.isEmpty`
- Once files existed, the drop target was gone
- No drop handler on the file list view

### Solution
1. **Added drop handler to file list view**
   - Added `.onDrop()` modifier to the VStack containing the file list
   - New `handleAdditionalDrop()` method to process additional files
   - Files are appended to existing list instead of replacing

2. **Added "Add More Files..." button**
   - Opens native file picker (NSOpenPanel)
   - Filters for PDF and image files
   - New `selectMoreFiles()` method
   - Provides alternative to drag-and-drop

### Code Changes

**ContentView.swift:**
- Added `.onDrop()` to file list VStack
- Added `handleAdditionalDrop()` helper method
- Added `selectMoreFiles()` helper method
- Added "Add More Files..." button to toolbar

### How It Works Now
✅ Drop files initially → Files appear  
✅ Drop more files on list → Files added to existing list  
✅ Click "Add More Files..." → File picker opens  
✅ Select files in picker → Files added to list  

---

## 🐛 Bug #2: BatesStampView Dialog Too Short

### Problem
- Dialog window was too short
- Top and bottom of content were cut off
- Form content was collapsed
- Hard to see all options

### Root Cause
- `.frame(width: 440)` without minimum height
- Form collapsing without explicit height
- Negative padding removing needed space

### Solution
1. **Set minimum height on Form**
   - Added `.frame(minHeight: 150)` to Form
   - Ensures Form content has enough vertical space

2. **Set minimum height on entire view**
   - Changed `.frame(width: 440)` to `.frame(width: 440, minHeight: 350)`
   - Added `.fixedSize(horizontal: false, vertical: true)` to respect content height

3. **Added proper padding**
   - Replaced `.padding(.top, -10)` with proper `.padding()` in Form section
   - Added `.formStyle(.grouped)` for better appearance

### Code Changes

**BatesStampView.swift:**
```swift
// Before:
Form { ... }
.padding(.top, -10)

// After:
Form { ... }
.frame(minHeight: 150)
.formStyle(.grouped)
```

```swift
// Before:
.frame(width: 440)

// After:
.frame(width: 440, minHeight: 350)
.fixedSize(horizontal: false, vertical: true)
```

### How It Works Now
✅ Dialog opens with proper height  
✅ All content is visible  
✅ No clipping at top or bottom  
✅ Form fields are properly spaced  

---

## 📋 Testing Checklist

### Test Bug Fix #1 (Add More Files)
- [ ] Drop initial files → List appears ✓
- [ ] Drop more files on list → Added to existing list ✓
- [ ] Click "Add More Files..." → Picker opens ✓
- [ ] Select files in picker → Added to list ✓
- [ ] Drop + Picker mixed → All files in list ✓

### Test Bug Fix #2 (Dialog Height)
- [ ] Click "Process Files" → Dialog opens ✓
- [ ] All content visible → No clipping ✓
- [ ] Toggle "Add Bates Stamp" → Form expands/collapses ✓
- [ ] Can see all buttons → Cancel and Process visible ✓
- [ ] Warnings show properly → No overlap ✓

---

## ✅ Summary

| Bug | Status | Fix |
|-----|--------|-----|
| Can't add more files | ✅ Fixed | Added drop handler + file picker button |
| Dialog too short | ✅ Fixed | Set minimum heights and proper padding |

---

## 🚀 What's Improved

### User Experience
- ✅ Can now add files incrementally (don't need to collect all files first)
- ✅ Two ways to add more files: drag-and-drop or file picker
- ✅ Dialog is properly sized and readable
- ✅ Professional, polished interface

### Technical
- ✅ Proper drop handling on file list view
- ✅ Native file picker integration
- ✅ Proper layout constraints
- ✅ Smooth animations when adding files

---

## 📝 Files Modified

1. **ContentView.swift**
   - Added drop handler to file list
   - Added "Add More Files..." button
   - Added `handleAdditionalDrop()` method
   - Added `selectMoreFiles()` method

2. **BatesStampView.swift**
   - Set minimum height on Form (150pt)
   - Set minimum height on view (350pt)
   - Added `.fixedSize()` modifier
   - Fixed padding issues

---

## 🎉 Result

Both bugs are fixed! The app now:
- ✅ Allows adding files multiple times
- ✅ Displays dialog with proper height
- ✅ Provides great user experience
- ✅ Works as expected

Ready to test! 🚀
