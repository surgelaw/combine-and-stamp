# Migration from Automator to Native Extension

This document outlines the steps to remove Automator-based workflow artifacts from your project and system.

## Files to Remove from Project

If your project previously included Automator workflows, remove these:

### 1. Workflow Files
```
PDFCombineStamp.workflow/
├── Contents/
│   ├── Info.plist
│   ├── QuickLook/
│   └── document.wflow
```

**Action**: Delete the entire `.workflow` directory

### 2. Build Scripts
Remove any build scripts that:
- Package the .workflow file
- Copy workflows to ~/Library/Services
- Install workflows during build

Look for:
- Build Phases → Run Script sections
- Shell scripts in project root
- Makefile entries for workflow installation

### 3. Documentation References
Update or remove references to Automator in:
- README files
- User guides
- Installation instructions
- Build documentation
- Comments in code

Search for terms:
- "Automator"
- ".workflow"
- "Services"
- "manual installation"
- "workflow installation"

## System Cleanup (Development Machine)

### Remove Installed Workflows

1. **Check for installed workflows**:
   ```bash
   ls -la ~/Library/Services/*.workflow
   ```

2. **Remove old PDF Combine workflows**:
   ```bash
   rm -rf ~/Library/Services/PDFCombineStamp.workflow
   rm -rf ~/Library/Services/"Combine PDFs"*.workflow
   ```

3. **Clear Automator caches**:
   ```bash
   rm -rf ~/Library/Caches/com.apple.Automator*
   rm -rf ~/Library/Saved\ Application\ State/com.apple.Automator*
   ```

### Rebuild Services Menu

After removing workflows:
```bash
/System/Library/CoreServices/pbs -flush
killall Finder
```

Or simply log out and back in.

## Git Repository Cleanup

### 1. Remove Files from Git History (Optional)

If you want to completely remove workflow files from git history:

```bash
# Make sure your repo is clean first
git status

# Remove workflow directory from history
git filter-branch --tree-filter 'rm -rf PDFCombineStamp.workflow' HEAD

# Or use git-filter-repo (recommended, faster)
git filter-repo --path PDFCombineStamp.workflow --invert-paths

# Force push if needed (be careful!)
git push origin --force --all
```

### 2. Update .gitignore

Remove or update Automator-related entries:

```gitignore
# Old Automator entries (can be removed)
*.workflow/

# Keep if you have other macOS artifacts
.DS_Store
*.xcuserstate
```

### 3. Clean Working Directory

```bash
# Remove untracked workflow files
git clean -fdx "*.workflow"

# Remove from staging if accidentally added
git rm -r --cached PDFCombineStamp.workflow
git commit -m "Remove Automator workflow files"
```

## Update Build Process

### Xcode Project Changes

1. **Remove Workflow Copy Phases**:
   - Select your target
   - Build Phases tab
   - Remove any "Copy Files" phases that reference .workflow

2. **Remove Workflow from Bundle Resources**:
   - Build Phases → Copy Bundle Resources
   - Remove any .workflow items

3. **Update Archive Scripts**:
   - Remove workflow packaging from archive scripts
   - Update export scripts to only package the .app

### Build Scripts to Update

If you have custom build/deployment scripts, update:

**Before**:
```bash
# Package workflow
ditto -c -k PDFCombineStamp.workflow PDFCombineStamp.workflow.zip

# Install workflow
cp -R PDFCombineStamp.workflow ~/Library/Services/
```

**After**:
```bash
# Just build and package the app
xcodebuild -scheme PDFCombineStamp -configuration Release
codesign --deep --force --sign "Developer ID" PDFCombineStamp.app
```

## Distribution Changes

### Installation Instructions

**Old Process**:
1. Download app
2. Download workflow separately
3. Double-click workflow to install
4. Launch app

**New Process**:
1. Download app
2. Move to Applications
3. Launch once
4. Ready to use

### Update Distribution Package

If you created .pkg installers or .dmg images:

**Remove**:
- Workflow installation payload
- Post-install scripts that copy workflows
- Multiple installation steps

**Keep**:
- App bundle only
- Simple drag-to-Applications setup
- First-launch instructions

### Update Website/Download Page

Update documentation that mentions:
- Manual workflow installation
- Two-part installation process
- ~/Library/Services/ directory
- Double-clicking .workflow files

## User Migration

### For Existing Users

Provide migration instructions:

```markdown
## Upgrading from Previous Version

If you previously installed PDFCombineStamp with Automator:

1. **Remove old workflow**:
   - Open ~/Library/Services/ in Finder (Go → Go to Folder)
   - Delete PDFCombineStamp.workflow
   
2. **Install new version**:
   - Replace old app with new version
   - Launch once to register extension
   - Log out and back in

3. **Verify installation**:
   - Select PDFs in Finder
   - Right-click → Quick Actions
   - Look for "Combine PDFs and Stamp"
```

### Automator App References

Update any code that checked for workflow installation:

**Before**:
```swift
func isWorkflowInstalled() -> Bool {
    let path = "~/Library/Services/PDFCombineStamp.workflow"
    return FileManager.default.fileExists(atPath: NSString(string: path).expandingTildeInPath)
}
```

**After**:
```swift
// Extension is automatically available when app is installed
// No need to check - the system handles registration
```

## Testing Checklist

After migration, verify:

- [ ] No .workflow files in project
- [ ] No workflow references in code
- [ ] Build succeeds without workflow steps
- [ ] App launches and shows information view
- [ ] Extension appears in Finder Quick Actions
- [ ] Extension works with file selection
- [ ] No old workflow appears in Services menu
- [ ] Documentation updated
- [ ] README updated
- [ ] Git history cleaned (if desired)
- [ ] Distribution package updated

## Rollback Plan

If you need to temporarily revert:

1. **Keep old workflow in separate branch**:
   ```bash
   git checkout -b automator-legacy
   git checkout main -- PDFCombineStamp.workflow
   git commit -m "Preserve old workflow"
   ```

2. **Tag the last Automator version**:
   ```bash
   git tag -a v0.9-automator -m "Last version with Automator"
   ```

3. **Document both versions**:
   - Maintain separate installation guides
   - Note system requirements differences
   - Clarify which version to use

## Benefits of Native Extension

Document the improvements for stakeholders:

### Technical Benefits
- ✅ No manual installation steps
- ✅ Automatic system registration
- ✅ Proper sandboxing
- ✅ Better security model
- ✅ Easier code signing
- ✅ Simpler distribution

### User Benefits
- ✅ One-click installation
- ✅ Automatic updates possible
- ✅ More reliable activation
- ✅ Better system integration
- ✅ Modern macOS design

### Development Benefits
- ✅ Single deployment artifact
- ✅ Unified codebase
- ✅ Better debugging tools
- ✅ Standard Xcode workflow
- ✅ Easier testing

## Support Transition

Update support documentation:

### Deprecate Old Instructions
- Mark Automator guides as "Legacy"
- Add "Updated for [version]" notices
- Link to new installation guide

### Update FAQs
- Remove workflow troubleshooting
- Add extension troubleshooting
- Update screenshots

### Create Comparison Guide
Help users understand the change:

| Aspect | Automator (Old) | Extension (New) |
|--------|-----------------|-----------------|
| Installation | 2 steps | 1 step |
| Location | ~/Library/Services | App bundle |
| Updates | Manual | Automatic |
| Security | Limited sandbox | Full sandbox |
| Debugging | Difficult | Standard tools |

---

**Migration Complete!** 🎉

Your project is now using modern macOS extension APIs and provides a better experience for both developers and users.
