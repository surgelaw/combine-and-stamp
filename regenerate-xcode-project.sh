#!/bin/bash
# Simple script to regenerate Xcode project with all v1.1 files

echo "Regenerating Xcode project with xcodegen..."
xcodegen generate

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Success! Project regenerated with all v1.1 files."
    echo ""
    echo "📋 Files included:"
    echo "  • All F-01, F-02, F-03 features"
    echo "  • StampPreset.swift"
    echo "  • PresetManager.swift"
    echo "  • PresetPickerView.swift"
    echo "  • PresetEditorView.swift"
    echo ""
    echo "⚠️  Next: Enable App Groups in Xcode"
    echo ""
    echo "1. open PDFCombineStamp.xcodeproj"
    echo "2. Select PDFCombineStamp target"
    echo "3. Signing & Capabilities → '+ Capability' → 'App Groups'"
    echo "4. Add: group.com.yourcompany.pdfcombinestamp"
    echo "5. Repeat for PDFCombineStampExtension target"
    echo ""
    echo "Then build (⌘B) and run (⌘R)!"
    echo ""
else
    echo "❌ xcodegen failed. Make sure all Swift files exist."
fi

