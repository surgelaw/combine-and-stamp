# PDF Combine & Stamp

A native macOS Quick Action for combining PDFs and images with optional Bates stamp numbering.

## Features

- ✅ **Combine Multiple PDFs and Images**: Merge PDFs, PNGs, JPEGs, TIFFs, and more
- ✅ **Bates Stamping**: Add sequential numbering with customizable prefix
- ✅ **Finder Integration**: Right-click on files to access
- ✅ **Order Preservation**: Maintains your Finder selection order
- ✅ **File Validation**: Automatically skips unsupported files
- ✅ **Large File Support**: Handles multi-gigabyte operations with warnings
- ✅ **Native & Secure**: Sandboxed macOS extension with no external dependencies

## System Requirements

- macOS 12.0 (Monterey) or later
- Apple Silicon (M1/M2/M3) or Intel processor

## Installation

1. Download `PDFCombineStamp.app`
2. Move to your Applications folder
3. Launch the app once to register the extension
4. Grant any requested permissions
5. Done! The Quick Action is now available in Finder

**Note**: You may need to log out and back in for the extension to appear.

## Usage

### Quick Action (Recommended)

1. **Select files** in Finder (PDFs and/or images)
2. **Right-click** on the selection
3. Choose **Quick Actions → Combine PDFs and Stamp**
4. Configure your options:
   - Toggle Bates stamping on/off
   - Set prefix (e.g., "BATES-", "DOC-")
   - Set starting number
5. Click **Combine and Stamp**
6. The combined PDF is saved in the same folder and revealed in Finder

### Services Menu Alternative

You can also access the action via:
- Right-click → **Services → Combine PDFs and Stamp**

### Supported File Types

**Fully Supported**:
- PDF (`.pdf`)
- PNG (`.png`)
- JPEG (`.jpg`, `.jpeg`)
- TIFF (`.tif`, `.tiff`)
- GIF (`.gif`)
- BMP (`.bmp`)

**Unsupported files** are automatically detected and skipped with a warning.

## Bates Stamping

Bates stamps appear in the bottom-right corner of each page with:
- **White background** for readability
- **Red text** for visibility
- **Sequential numbering** in 6-digit format (e.g., BATES-000001)

### Example Stamps:
- `BATES-000001`, `BATES-000002`, `BATES-000003`...
- `DOC-000001`, `DOC-000002`, `DOC-000003`...
- `CASE2024-001234`, `CASE2024-001235`...

**Note**: You can disable stamping to just combine files without numbering.

## File Size Warnings

The extension monitors total file size and provides warnings:

- **500 MB - 1.5 GB**: Warning that processing may take a few minutes
- **Over 1.5 GB**: Requires explicit confirmation with "Force Proceed" toggle

## Output

Combined PDFs are saved as:
```
Combined_<timestamp>.pdf
```

**Location**:
1. Same folder as selected files (preferred)
2. Desktop folder (if first option fails)

The file is automatically revealed in Finder after creation.

## Privacy & Security

- ✅ **Sandboxed**: Runs in a secure macOS sandbox
- ✅ **No Network Access**: All processing is local
- ✅ **No Data Collection**: No telemetry or analytics
- ✅ **File Access**: Only to user-selected files and Desktop
- ✅ **Code Signed**: Verified by Apple

## Troubleshooting

### Extension Not Appearing

1. Launch the app at least once
2. Check **System Settings → Extensions → Finder Extensions**
3. Ensure "PDF Combine & Stamp" is enabled
4. Try logging out and back in
5. If downloaded from the web, remove quarantine:
   ```bash
   xattr -cr /Applications/PDFCombineStamp.app
   ```

### Permission Errors

If you see permission errors:
1. Check **System Settings → Privacy & Security → Files and Folders**
2. Ensure PDFCombineStamp has necessary access
3. Try selecting files from a different location (Documents, Desktop)

### Large File Issues

For very large operations:
- Close other apps to free memory
- Process files in smaller batches
- Use "Force Proceed" option for 1.5GB+ operations

### Out of Memory

If processing fails due to memory:
- Reduce number of files
- Split into multiple operations
- Close background applications

## Uninstallation

1. Quit the app if running
2. Delete from Applications folder
3. The extension will be automatically removed

## Version History

### Version 1.0 (Current)
- Native macOS extension architecture
- Removed Automator dependency
- Added Quick Actions integration
- Added file size warnings
- Improved error handling
- Universal binary (Apple Silicon + Intel)

## Support & Feedback

For issues, questions, or feedback:
- Check this README and troubleshooting section
- Review macOS extension permissions
- Ensure you're running macOS 12.0 or later

## Legal

### License
[Specify your license here - e.g., MIT, Proprietary, etc.]

### Copyright
Copyright © 2026 [Your Company/Name]. All rights reserved.

### Trademarks
macOS and Finder are trademarks of Apple Inc.

---

**Enjoy combining PDFs with ease!** 🎉
