#!/bin/bash
# Fix duplicate ContentView issue

set -e

echo "Removing duplicate ContentView 2.swift..."
rm -f "ContentView 2.swift"

echo "Updating project.yml..."
# Update project_complete.yml to remove ContentView 2 reference
sed -i '' '/ContentView 2.swift/d' project_complete.yml

echo "Copying updated project.yml..."
cp project_complete.yml project.yml

echo "Regenerating project..."
xcodegen generate

echo ""
echo "✅ Fixed! Now build in Xcode (⌘B)"
echo ""

