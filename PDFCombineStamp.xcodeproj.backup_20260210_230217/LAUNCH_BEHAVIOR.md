# App Launch Behavior - Expected vs Actual

## 🎯 Expected Behavior

### Scenario 1: Launch Standalone (Double-Click App)
**What should happen:**
1. App window opens
2. Shows **ContentView** with drop zone
3. Shows instructions
4. User can drag files
5. After dragging files → File list appears
6. Click "Process Files" → **BatesStampView** sheet appears
7. User configures options → Processes files

**Key Point:** BatesStampView should NOT appear until user clicks "Process Files"

### Scenario 2: Launch from Command Line (Backward Compatibility)
**What should happen:**
1. App receives file paths as arguments
2. Shows **BatesStampView** panel directly (floating panel)
3. User configures options → Processes files
4. App terminates after processing

**Key Point:** Skips ContentView entirely, goes straight to options

### Scenario 3: Launch from Quick Action (Extension)
**What should happen:**
1. User right-clicks files in Finder
2. Selects "Quick Actions → Combine PDFs and Stamp"
3. **Extension** shows BatesStampView
4. User configures options → Processes files
5. Extension terminates

**Key Point:** Uses ShareViewController, not main app

---

## 🔍 Current Implementation

### Main App Entry Point (BatesStampApp.swift)

```swift
func applicationDidFinishLaunching(_ notification: Notification) {
    let args = ProcessInfo.processInfo.arguments
    if args.count > 1 {
        // Command-line mode: Show BatesStampView panel
        urls = args.dropFirst().map { URL(fileURLWithPath: $0) }
        if !urls.isEmpty {
            setupPanel()  // Shows BatesStampView directly
            NSApp.setActivationPolicy(.accessory)
            panel?.makeKeyAndOrderFront(nil)
        }
    }
    // Otherwise: Shows ContentView (default WindowGroup)
}
```

### ContentView (Standalone Mode)

```swift
struct ContentView: View {
    @State private var droppedFiles: [FileItem] = []
    @State private var showingOptions = false  // ← Starts as FALSE
    
    var body: some View {
        NavigationStack {
            if droppedFiles.isEmpty {
                // Shows drop zone
                DropZoneView(droppedFiles: $droppedFiles)
            } else {
                // Shows file list
                // ...
                .sheet(isPresented: $showingOptions) {
                    BatesStampView(...)  // ← Only shown when true
                }
            }
        }
    }
}
```

---

## ✅ Verification Checklist

### Test 1: Double-Click App Icon
- [ ] App opens with main window
- [ ] Shows drop zone (not BatesStampView)
- [ ] Shows "How to use" instructions
- [ ] Can drag files into drop zone
- [ ] Files appear in list
- [ ] BatesStampView does NOT appear yet
- [ ] Click "Process Files" → Now BatesStampView appears

**Expected Result:** Drop zone first, BatesStampView only after clicking button

### Test 2: Command Line Launch
```bash
/Applications/PDFCombineStamp.app/Contents/MacOS/PDFCombineStamp file1.pdf file2.pdf
```
- [ ] App shows floating panel immediately
- [ ] Panel contains BatesStampView
- [ ] No drop zone shown
- [ ] Can configure and process

**Expected Result:** BatesStampView panel appears immediately

### Test 3: Quick Action
- [ ] Right-click files in Finder
- [ ] Select Quick Action
- [ ] Extension shows BatesStampView
- [ ] Can configure and process

**Expected Result:** BatesStampView in extension

---

## 🐛 Possible Issues

### Issue: BatesStampView appears immediately when double-clicking
**Symptoms:**
- Open app by double-clicking
- BatesStampView sheet appears without clicking "Process Files"

**Diagnosis:**
- Check if `showingOptions` is being set to `true` somewhere
- Check if there's another code path showing BatesStampView

**Solution:**
Ensure `showingOptions` only becomes `true` when "Process Files" is clicked

---

## 📝 Current Code Status

Based on the current implementation:
- ✅ `showingOptions` starts as `false`
- ✅ Only set to `true` when "Process Files" button clicked
- ✅ Command-line mode shows panel directly (correct)
- ✅ Standalone mode shows ContentView first (correct)

**The code should already work as expected!**

---

## 🔧 If You're Still Seeing Issues

Please specify:
1. How are you launching the app? (Double-click, command line, Quick Action)
2. What do you see when it launches?
3. When does BatesStampView appear?
4. What did you expect to see instead?

---

## 💡 Recommendation

The current implementation should be correct. Test with:

1. **Double-click app** → Should show drop zone
2. **Drag files** → Should show file list
3. **Click "Process Files"** → Should show BatesStampView sheet

If BatesStampView is appearing at step 1, there may be an issue, but based on the code review, it should work correctly.

---

**Status:** Code appears correct. Awaiting clarification on specific issue.
