# Adding New Files to Xcode Project

## 🎯 Quick Instructions

You now have 4 new Swift files and 1 updated file. Here's how to add them to your Xcode project:

---

## Step 1: Open Xcode Project

```bash
cd /path/to/PDFCombineStamp
open PDFCombineStamp.xcodeproj
```

---

## Step 2: Add New Files to Project

### Method 1: Drag and Drop (Recommended)
1. In Finder, locate these new files:
   - `FileItem.swift`
   - `FileValidator.swift`
   - `DropZoneView.swift`
   - `FileListView.swift`

2. Drag them into Xcode's Project Navigator
3. When the dialog appears, make sure:
   - ✅ "Copy items if needed" is **checked**
   - ✅ "PDFCombineStamp" target is **selected**
   - ✅ "Create groups" is selected
   - ❌ PDFCombineStampExtension is **not** selected (for now)

### Method 2: File > Add Files (Alternative)
1. Right-click on "PDFCombineStamp" group in Project Navigator
2. Select "Add Files to 'PDFCombineStamp'..."
3. Select all 4 new Swift files
4. Click "Add"
5. Make sure target membership is correct (see below)

---

## Step 3: Verify Target Membership

1. Select each new file in Project Navigator
2. Open File Inspector (⌘⌥1 or View > Inspectors > File)
3. Under "Target Membership", verify:
   - ✅ **PDFCombineStamp** is checked
   - ❌ **PDFCombineStampExtension** is unchecked

Files to check:
- FileItem.swift → PDFCombineStamp only
- FileValidator.swift → PDFCombineStamp only
- DropZoneView.swift → PDFCombineStamp only
- FileListView.swift → PDFCombineStamp only

---

## Step 4: Organize Files (Optional)

For better organization, create groups:

1. Right-click "PDFCombineStamp" in Project Navigator
2. Select "New Group"
3. Name it "Models"
4. Drag `FileItem.swift` into Models group

Repeat to create:
- **Utilities** group → Move `FileValidator.swift`
- **Views** group → Move `DropZoneView.swift`, `FileListView.swift`, `ContentView.swift`

Your structure should look like:
```
PDFCombineStamp/
├── Models/
│   └── FileItem.swift
├── Utilities/
│   └── FileValidator.swift
├── Views/
│   ├── ContentView.swift
│   ├── DropZoneView.swift
│   └── FileListView.swift
├── BatesStampView.swift
├── BatesStampApp.swift
└── ...
```

---

## Step 5: Build the Project

1. Select "PDFCombineStamp" scheme (not the extension)
2. Press **⌘B** to build
3. Fix any errors (there shouldn't be any!)

Expected result: **Build Succeeded** ✅

---

## Step 6: Run and Test

1. Press **⌘R** to run the app
2. You should see the new drop zone UI
3. Test dragging files:
   - Drag a PDF file from Finder
   - Should appear in file list
   - Click "Process Files" to see options

---

## 🧪 Testing Checklist

Once the app is running:

- [ ] App opens with drop zone visible
- [ ] Drop zone shows instructions
- [ ] Drag a PDF file → appears in list
- [ ] Drag multiple PDFs → all appear
- [ ] Drag an image (JPG/PNG) → appears
- [ ] Drag invalid file (txt) → shows error alert
- [ ] Click "Clear All" → returns to drop zone
- [ ] Click "Process Files" → BatesStampView appears
- [ ] Close options → returns to file list

---

## 🐛 Troubleshooting

### Build Error: "Cannot find 'FileItem' in scope"
**Solution:** Make sure `FileItem.swift` is added to PDFCombineStamp target
- Select file in Project Navigator
- Check File Inspector → Target Membership

### Build Error: "Use of unresolved identifier 'DropZoneView'"
**Solution:** Make sure `DropZoneView.swift` is in the same target as `ContentView.swift`

### App crashes when dropping files
**Solution:** 
1. Check Console for error messages
2. Verify app has file access permissions
3. Check that `FileValidator.swift` is included

### Drop zone doesn't accept files
**Solution:**
1. Make sure `.onDrop(of: [.fileURL])` is in DropZoneView
2. Test with different file types
3. Check macOS privacy settings

---

## ✅ Success Criteria

You'll know everything is working when:
- ✅ App builds without errors
- ✅ Drop zone appears on launch
- ✅ Files can be dragged and dropped
- ✅ File list shows file details
- ✅ "Process Files" opens BatesStampView
- ✅ No crashes or errors

---

## 📝 Next Steps

After you've confirmed everything works:

1. **Commit your changes:**
   ```bash
   git add FileItem.swift FileValidator.swift DropZoneView.swift FileListView.swift ContentView.swift
   git commit -m "Implement F-01 Day 1: Add drag-and-drop foundation
   
   - Add FileItem model
   - Add FileValidator utility
   - Create DropZoneView with file validation
   - Create FileListView for displaying files
   - Update ContentView with drop zone UI
   
   Part of F-01: Drag-and-Drop Interface"
   ```

2. **Test thoroughly** using the checklist above

3. **Ready for Day 2** - We'll add more polish and complete the integration!

---

## 🎉 Great Job!

You've completed Day 1 of F-01! The foundation is in place for the drag-and-drop interface.

**Time spent:** ~1-2 hours  
**Progress:** F-01 Day 1 Complete (25% of F-01)  
**Next:** Day 2 - Polish and Testing
