# Using xcodegen to Fix Duplicate Files

## ✅ Automated Solution!

Instead of manually fixing duplicate files, we can use `xcodegen` to regenerate a clean Xcode project automatically!

---

## 🚀 Quick Start (30 seconds)

```bash
# Make the script executable
chmod +x regenerate-project.sh

# Run it!
./regenerate-project.sh
```

That's it! Your project will be regenerated with all duplicates cleaned up.

---

## 📋 What It Does

The `regenerate-project.sh` script will:

1. ✅ Check that xcodegen is installed
2. ✅ Backup your current .xcodeproj
3. ✅ Move duplicate files to `.xcodegen_cleanup/` folder
4. ✅ Rename `_FINAL` and `_Fixed` files to standard names
5. ✅ Generate a clean Xcode project from `project.yml`
6. ✅ Configure all targets correctly

---

## 🎯 After Running

1. **Open the project:**
   ```bash
   open PDFCombineStamp.xcodeproj
   ```

2. **Build:**
   - Press **⌘B**
   - Should build without errors! ✅

3. **Run:**
   - Press **⌘R**
   - Test the app

---

## 📁 What Gets Created

### Files Moved to `.xcodegen_cleanup/`:
- Old duplicate Swift files
- Any `_Fixed` or `_v2` variants
- Safe to delete after confirming the project works

### Files Renamed:
- `FileRowView_FINAL.swift` → `FileRowView.swift`
- `ReorderableFileListView_Fixed.swift` → `ReorderableFileListView.swift`

### Backup:
- Your original `.xcodeproj` backed up as `PDFCombineStamp.xcodeproj.backup_TIMESTAMP`

---

## 🔧 Manual Alternative

If you don't want to use the script, you can run xcodegen manually:

```bash
# 1. Rename files
mv FileRowView_FINAL.swift FileRowView.swift
mv ReorderableFileListView_Fixed.swift ReorderableFileListView.swift

# 2. Delete duplicates
rm -f FileRowView_Fixed.swift FileRowView_v2.swift

# 3. Generate project
xcodegen generate

# 4. Open in Xcode
open PDFCombineStamp.xcodeproj
```

---

## 💡 Benefits of Using xcodegen

### Before (Manual):
- ❌ Add files one by one to Xcode
- ❌ Set target membership manually
- ❌ Deal with duplicate file errors
- ❌ Merge conflicts in .pbxproj files
- ❌ Hard to review project changes in Git

### After (xcodegen):
- ✅ Add files anywhere, run `xcodegen`
- ✅ Targets configured automatically
- ✅ No duplicates (regenerates clean)
- ✅ `project.yml` is human-readable
- ✅ Easy to review in Git

---

## 📝 Future Workflow

After this initial cleanup, your workflow becomes:

```bash
# 1. Create new Swift file
touch MyNewFile.swift

# 2. Add it to project.yml
# (Under sources for the appropriate target)

# 3. Regenerate project
xcodegen generate

# Done! File is in your Xcode project
```

No more manual "Add Files to Project" in Xcode!

---

## 🎓 Understanding project.yml

The `project.yml` file I created defines:

```yaml
targets:
  PDFCombineStamp:
    sources:
      - path: PDFCombineStamp    # Main app folder
      - path: Shared             # Shared code
      - FileItem.swift           # Individual files at root
      - FileValidator.swift
      # ... etc
```

This tells xcodegen which files belong to which target.

---

## ⚠️ Important Notes

1. **Backup Created:** Your original project is backed up before regeneration
2. **Duplicates Saved:** Moved to `.xcodegen_cleanup/`, not deleted
3. **Git-Friendly:** `project.yml` is much easier to review than `.pbxproj`
4. **Customizable:** Edit `project.yml` to add/remove files or change settings

---

## 🆘 Troubleshooting

### "xcodegen: command not found"
```bash
brew install xcodegen
```

### "project.yml not found"
Make sure you're in the project root directory (where `project.yml` is).

### Want to undo?
```bash
# Remove the generated project
rm -rf PDFCombineStamp.xcodeproj

# Restore from backup
cp -R PDFCombineStamp.xcodeproj.backup_* PDFCombineStamp.xcodeproj
```

---

## ✨ Summary

**Before:** Manual file management, duplicate errors  
**After:** Automated project generation, no duplicates  

**Command:** `./regenerate-project.sh`  
**Time:** 30 seconds  
**Result:** Clean, working Xcode project ✅

---

**Ready to try it?** Run `./regenerate-project.sh` and watch the magic happen! 🎉
