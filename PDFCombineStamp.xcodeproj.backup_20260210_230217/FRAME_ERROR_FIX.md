# Build Error Fix - Frame Syntax

## ✅ Fixed!

**Error:** `Extra argument 'minHeight' in call`

**Location:** `BatesStampView.swift`

---

## What Was Wrong

The frame modifier syntax was incorrect:

```swift
// ❌ Wrong - This syntax doesn't exist
.frame(width: 440, minHeight: 350)
.frame(minHeight: 150)  // Can't use minHeight alone
```

---

## What I Fixed

Changed to the correct SwiftUI frame syntax:

```swift
// ✅ Correct
.frame(minWidth: 440, maxWidth: 440, minHeight: 350)
```

Also removed:
- `.frame(minHeight: 150)` from Form (not needed)
- `.fixedSize(horizontal: false, vertical: true)` (not needed with proper frame)

---

## Changes Made

**BatesStampView.swift:**

1. **Removed from Form:**
   ```swift
   // Removed this line:
   .frame(minHeight: 150)
   ```

2. **Fixed main frame:**
   ```swift
   // Changed from:
   .frame(width: 440, minHeight: 350)
   .fixedSize(horizontal: false, vertical: true)
   
   // To:
   .frame(minWidth: 440, maxWidth: 440, minHeight: 350)
   ```

---

## ✅ Should Build Now

Press **⌘B** to build - the error should be gone!

The dialog will still have proper height because:
- `minHeight: 350` ensures minimum vertical space
- `minWidth: 440, maxWidth: 440` keeps consistent width
- SwiftUI will expand vertically if content needs more space

---

## 🧪 Test Again

1. Build (⌘B) - Should succeed ✅
2. Run (⌘R)
3. Add files and click "Process Files"
4. Dialog should open with proper height ✅

---

**Status:** ✅ Fixed and ready to build!
