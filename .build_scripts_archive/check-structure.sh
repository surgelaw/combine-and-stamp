#!/bin/bash
# Check what files and folders we have

echo "=== Current Directory ==="
pwd
echo ""

echo "=== Folders ==="
ls -d */ 2>/dev/null | head -20
echo ""

echo "=== Swift Files (root) ==="
ls -1 *.swift 2>/dev/null | head -20
echo ""

echo "=== Files in PDFCombineStamp folder ==="
if [ -d "PDFCombineStamp" ]; then
    ls -1 PDFCombineStamp/*.swift 2>/dev/null | head -20
else
    echo "❌ PDFCombineStamp folder not found!"
fi
echo ""

echo "=== Files in PDFCombineStampExtension folder ==="
if [ -d "PDFCombineStampExtension" ]; then
    ls -1 PDFCombineStampExtension/*.swift 2>/dev/null | head -20
else
    echo "❌ PDFCombineStampExtension folder not found!"
fi
echo ""

echo "=== Cleanup folder ==="
if [ -d ".xcodegen_cleanup" ]; then
    echo "Contents:"
    ls -1 .xcodegen_cleanup/ 2>/dev/null | head -20
else
    echo "(not found)"
fi
