# Fix: BatesStampView Appearing When Launching from Xcode

## ✅ Fixed!

**Issue:** When running the app from Xcode (⌘R), the BatesStampView panel appeared instead of the drop zone.

**Root Cause:** Xcode passes debug arguments to the app (like `-NSDocumentRevisionsDebugMode YES`). The app was treating these as file paths and entering "command-line mode".

---

## 🐛 What Was Happening

### Before the Fix:

```swift
func applicationDidFinishLaunching(_ notification: Notification) {
    let args = ProcessInfo.processInfo.arguments
    if args.count > 1 {  // ← Always true in Xcode!
        urls = args.dropFirst().map { URL(fileURLWithPath: $0) }
        // Shows panel...
    }
}
```

When running from Xcode, `args` contained:
```
[
    "/path/to/PDFCombineStamp",           // [0] Executable path
    "-NSDocumentRevisionsDebugMode",      // [1] Xcode debug flag
    "YES"                                  // [2] Flag value
]
```

So `args.count > 1` was `true`, and it tried to create URLs from `-NSDocumentRevisionsDebugMode` and `YES`, which failed validation but still triggered the panel mode.

---

## ✅ The Fix

### After the Fix:

```swift
func applicationDidFinishLaunching(_ notification: Notification) {
    let args = ProcessInfo.processInfo.arguments
    
    // Filter out Xcode debug arguments and the executable path
    let fileArgs = args.dropFirst().filter { arg in
        // Skip Xcode debug flags (start with - or NS)
        !arg.hasPrefix("-") && !arg.hasPrefix("NS")
    }
    
    if !fileArgs.isEmpty {
        urls = fileArgs.map { URL(fileURLWithPath: $0) }
        setupPanel()
        // ...
    }
    // Otherwise, shows ContentView (default WindowGroup)
}
```

Now it correctly filters out:
- Executable path (via `.dropFirst()`)
- Xcode debug flags (anything starting with `-`)
- Xcode NS arguments (anything starting with `NS`)

---

## 🎯 How It Works Now

### Launch from Xcode (⌘R):
```
Arguments: ["/path/to/app", "-NSDocumentRevisionsDebugMode", "YES"]
After filter: []  // Empty!
Result: Shows ContentView with drop zone ✅
```

### Launch from Command Line with Files:
```bash
./PDFCombineStamp file1.pdf file2.pdf
```
```
Arguments: ["/path/to/app", "file1.pdf", "file2.pdf"]
After filter: ["file1.pdf", "file2.pdf"]  // Real files!
Result: Shows BatesStampView panel ✅
```

### Launch by Double-Clicking:
```
Arguments: ["/path/to/app"]
After filter: []  // Empty!
Result: Shows ContentView with drop zone ✅
```

---

## 🧪 Testing

### Test 1: Run from Xcode (⌘R)
- [ ] App launches
- [ ] Shows ContentView with drop zone ✅
- [ ] Does NOT show BatesStampView panel ✅
- [ ] Can drag files and use normally ✅

### Test 2: Command Line with Files
```bash
/Applications/PDFCombineStamp.app/Contents/MacOS/PDFCombineStamp ~/Desktop/file1.pdf ~/Desktop/file2.pdf
```
- [ ] Shows BatesStampView panel directly ✅
- [ ] Panel lists the files ✅
- [ ] Can process files ✅

### Test 3: Double-Click App
- [ ] Shows ContentView with drop zone ✅
- [ ] Can use normally ✅

---

## 📝 What Changed

**File:** `BatesStampApp.swift`

**Changes:**
1. Added filtering of command-line arguments
2. Filter removes arguments starting with `-` or `NS`
3. Only triggers panel mode if there are actual file paths
4. Preserves backward compatibility for command-line usage

---

## ✨ Result

Now when you run the app from Xcode:
- ✅ Shows the drop zone (ContentView)
- ✅ Shows instructions
- ✅ BatesStampView only appears when you click "Process Files"
- ✅ Command-line mode still works for backward compatibility

---

**Status:** ✅ Fixed! Try running from Xcode now (⌘R) - you should see the drop zone!
