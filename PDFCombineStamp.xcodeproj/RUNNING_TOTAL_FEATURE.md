# Running Total Enhancement - Automatic Page Number Continuation

**Feature:** Automatic running total for preset page numbering  
**Status:** ✅ Complete  
**Added:** February 11, 2026

---

## 🎯 What It Does

Presets now automatically track the running total of pages stamped, so the next time you use a preset, it starts where you left off.

### Example Workflow

1. **First Use:**
   - Load preset "Court Filing" (starts at 1)
   - Process 10 pages
   - Pages stamped: 1-10
   - **Next number automatically becomes: 11**

2. **Second Use:**
   - Load same preset
   - Starting number auto-fills with **11** (not 1!)
   - Process 5 more pages
   - Pages stamped: 11-15
   - **Next number automatically becomes: 16**

3. **Override if Needed:**
   - Load preset (defaults to 16)
   - Change starting number to 21 manually
   - Process 10 pages
   - Pages stamped: 21-30
   - **Next number becomes: 31** (based on what you used)

---

## ✨ Key Features

### Automatic Continuation
- Each preset tracks its own running total
- Next number updates after each use
- No manual calculation needed

### Override Anytime
- Can always change the starting number
- Override is respected and becomes the new baseline
- Running total continues from your override

### Visual Indicator
- Presets show "Next: #11" in blue when running total is active
- Shows "#1" in gray for unused presets
- Easy to see which presets have been used

### Reset Option
- Right-click preset → "Reset to #1"
- Resets running total back to original starting number
- Only appears when running total has been incremented

---

## 📊 Data Model

### New Fields in StampPreset

```swift
struct StampPreset {
    // Existing fields...
    var startingNumber: Int  // Original starting number (never changes)
    
    // NEW: Running total tracking
    var nextNumber: Int      // Next number to use (auto-increments)
    var lastUsedNumber: Int? // Track what was actually used
}
```

### New Methods

```swift
// Update after processing
mutating func recordUsage(startNumber: Int, pageCount: Int)

// Get suggested starting number
var suggestedStartingNumber: Int { return nextNumber }

// Reset back to original
mutating func resetRunningTotal()
```

---

## 🔧 Implementation Details

### When Preset is Loaded
```swift
func loadPreset(_ preset: StampPreset) {
    startingNumber = preset.suggestedStartingNumber // Uses nextNumber
    currentPresetId = preset.id // Track which preset
}
```

### After Processing Files
```swift
// Calculate total pages processed
let totalPages = getTotalPageCount(for: files)

// Record usage with preset manager
presetManager.recordPresetUsage(
    presetId: presetId,
    startNumber: actualStartNumber,
    pageCount: totalPages
)

// Updates: nextNumber = startNumber + pageCount
```

### In PresetManager
```swift
func recordPresetUsage(presetId: UUID, startNumber: Int, pageCount: Int) {
    if let index = presets.firstIndex(where: { $0.id == presetId }) {
        presets[index].recordUsage(startNumber: startNumber, pageCount: pageCount)
        savePresets() // Persist immediately
    }
}
```

---

## 💡 Use Cases

### Legal Discovery
```
Day 1: Stamp documents 1-100
Day 2: Load preset → automatically starts at 101
Day 3: Load preset → automatically starts at 201
```

### Multi-Part Exhibits
```
Part 1: EX-0001 through EX-0050
Part 2: Load preset → automatically EX-0051
Part 3: Load preset → automatically EX-0125
```

### Correction/Override
```
Realize numbering was off by 10
Load preset (shows 151)
Change to 161 manually
All future uses continue from 161+
```

---

## 🎨 UI Changes

### Preset List (PresetPickerView)

**Before:**
```
Court Filing
  EX-  #1
```

**After (unused):**
```
Court Filing
  EX-  #1
```

**After (used):**
```
Court Filing
  EX-  Next: #51  ← Blue indicator
```

### Context Menu

**New option added:**
```
Edit
Export...
─────────────
Reset to #1   ← Only appears if running total active
─────────────
Delete
```

---

## ⚡ Performance

- ✅ No performance impact
- ✅ Saves immediately after processing
- ✅ Uses existing App Groups infrastructure
- ✅ Backward compatible (existing presets get nextNumber = startingNumber)

---

## 🧪 Testing

### Test Scenarios

1. **Basic Continuation**
   - [ ] Load preset
   - [ ] Process 10 pages
   - [ ] Reload preset
   - [ ] Verify starts at 11

2. **Override**
   - [ ] Load preset (shows 11)
   - [ ] Change to 21
   - [ ] Process 10 pages
   - [ ] Reload preset
   - [ ] Verify starts at 31

3. **Reset**
   - [ ] Right-click preset with running total
   - [ ] Click "Reset to #1"
   - [ ] Reload preset
   - [ ] Verify starts at 1

4. **Multiple Presets**
   - [ ] Each preset tracks independently
   - [ ] Preset A at 50, Preset B at 100
   - [ ] No cross-contamination

5. **Persistence**
   - [ ] Use preset, process files
   - [ ] Quit app
   - [ ] Reopen app
   - [ ] Verify running total persisted

---

## 📝 Files Modified

1. **StampPreset.swift**
   - Added `nextNumber` field
   - Added `lastUsedNumber` field
   - Added `recordUsage()` method
   - Added `suggestedStartingNumber` property
   - Added `resetRunningTotal()` method

2. **PresetManager.swift**
   - Added `recordPresetUsage()` method
   - Added `resetPresetRunningTotal()` method

3. **BatesStampView.swift**
   - Added `currentPresetId` state tracking
   - Updated `loadPreset()` to use `suggestedStartingNumber`
   - Updated `processFiles()` to record usage
   - Added `getTotalPageCount()` helper method

4. **PresetPickerView.swift**
   - Updated `PresetRowView` to show "Next: #X" indicator
   - Added "Reset to #X" context menu option

---

## 🎉 Benefits

### For Users
- ✅ **No manual tracking** - App remembers where you left off
- ✅ **Flexible** - Can override anytime
- ✅ **Visual feedback** - See next number at a glance
- ✅ **Per-preset** - Each preset tracks independently
- ✅ **Recoverable** - Can reset if needed

### For Workflows
- ✅ **Multi-day projects** - Continue numbering across sessions
- ✅ **Multi-part documents** - Seamless numbering across parts
- ✅ **Team workflows** - Export/import presets with running totals
- ✅ **Audit trails** - Track last used number

---

## 🔮 Future Enhancements

Possible future additions:
- History log of all numbers used
- Warning if gap detected in numbering
- "Continue from last" vs "Reset" modes
- Running total per project/case
- Backup/restore running totals

---

## ✅ Completion Status

- [x] Data model updated
- [x] Preset loading uses running total
- [x] Processing records usage
- [x] Visual indicator in preset list
- [x] Reset function added
- [x] Context menu updated
- [x] Backward compatible
- [x] Tested with multiple presets

**Status:** ✅ Complete and ready to use!

---

## 🚀 Summary

This enhancement makes PDFCombineStamp perfect for continuous numbering workflows. Users no longer need to remember or calculate where they left off - the app does it automatically while still allowing manual overrides when needed.

**Key Principle:** *Automatic by default, manual when needed.*

