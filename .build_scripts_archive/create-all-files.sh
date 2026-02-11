#!/bin/bash
# Create all v1.1 files and regenerate project

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Creating v1.1 Files ===${NC}"
echo ""

# Create FileItem.swift
echo "Creating FileItem.swift..."
cat > FileItem.swift << 'EOF'
import Foundation

/// Represents a file selected for processing
struct FileItem: Identifiable, Equatable {
    let id = UUID()
    let url: URL
    
    var name: String {
        url.lastPathComponent
    }
    
    var size: Int64?
    var pageCount: Int?
    
    init(url: URL, size: Int64? = nil, pageCount: Int? = nil) {
        self.url = url
        self.size = size
        self.pageCount = pageCount
    }
    
    static func == (lhs: FileItem, rhs: FileItem) -> Bool {
        lhs.id == rhs.id
    }
}
EOF

# Create FileValidator.swift
echo "Creating FileValidator.swift..."
cat > FileValidator.swift << 'EOF'
import Foundation
import UniformTypeIdentifiers
import PDFKit
import AppKit

class FileValidator {
    static let supportedExtensions = ["pdf", "jpg", "jpeg", "png", "tif", "tiff"]
    
    static func isValidFile(_ url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        return supportedExtensions.contains(ext)
    }
    
    static func validateFiles(_ urls: [URL]) -> ([URL], [URL]) {
        var valid: [URL] = []
        var invalid: [URL] = []
        
        for url in urls {
            if isValidFile(url) {
                valid.append(url)
            } else {
                invalid.append(url)
            }
        }
        
        return (valid, invalid)
    }
    
    static func getFileSize(_ url: URL) -> Int64? {
        let resources = try? url.resourceValues(forKeys: [.fileSizeKey])
        return resources?.fileSize.map { Int64($0) }
    }
    
    static func getPageCount(_ url: URL) -> Int? {
        let ext = url.pathExtension.lowercased()
        
        if ext == "pdf" {
            guard let pdfDocument = PDFDocument(url: url) else {
                return nil
            }
            return pdfDocument.pageCount
        } else if ["jpg", "jpeg", "png", "tif", "tiff"].contains(ext) {
            guard NSImage(contentsOf: url) != nil else {
                return nil
            }
            return 1
        }
        
        return nil
    }
    
    static func getFileMetadata(_ url: URL) -> (size: Int64?, pageCount: Int?) {
        return (getFileSize(url), getPageCount(url))
    }
}
EOF

# Create DropZoneView.swift
echo "Creating DropZoneView.swift..."
cat > DropZoneView.swift << 'EOF'
import SwiftUI

struct DropZoneView: View {
    @Binding var droppedFiles: [FileItem]
    @State private var isTargeted = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.on.doc")
                .font(.system(size: 64))
                .foregroundColor(isTargeted ? .accentColor : .secondary)
                .animation(.easeInOut(duration: 0.2), value: isTargeted)
            
            Text("Drop PDFs and Images Here")
                .font(.title2)
                .foregroundColor(.primary)
            
            Text("Supported: PDF, JPG, PNG, TIFF")
                .font(.caption)
                .foregroundColor(.secondary)
            
            if !droppedFiles.isEmpty {
                Text("or drop more files to add them")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    style: StrokeStyle(lineWidth: 2, dash: [10])
                )
                .foregroundColor(isTargeted ? .accentColor : .secondary)
                .animation(.easeInOut(duration: 0.2), value: isTargeted)
        )
        .padding(40)
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            handleDrop(providers: providers)
            return true
        }
        .alert("Invalid Files", isPresented: $showingError) {
            Button("OK") { }
        } message: {
            Text(errorMessage)
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) {
        var urls: [URL] = []
        
        let group = DispatchGroup()
        
        for provider in providers {
            group.enter()
            _ = provider.loadObject(ofClass: URL.self) { url, error in
                defer { group.leave() }
                
                if let url = url {
                    urls.append(url)
                }
            }
        }
        
        group.notify(queue: .main) {
            let (valid, invalid) = FileValidator.validateFiles(urls)
            
            if !invalid.isEmpty {
                errorMessage = "The following files are not supported:\n\n" + 
                              invalid.map { "• " + $0.lastPathComponent }.joined(separator: "\n") +
                              "\n\nSupported formats: PDF, JPG, PNG, TIFF"
                showingError = true
            }
            
            if !valid.isEmpty {
                DispatchQueue.global(qos: .userInitiated).async {
                    let newFiles = valid.map { url -> FileItem in
                        let metadata = FileValidator.getFileMetadata(url)
                        return FileItem(
                            url: url,
                            size: metadata.size,
                            pageCount: metadata.pageCount
                        )
                    }
                    
                    DispatchQueue.main.async {
                        droppedFiles.append(contentsOf: newFiles)
                    }
                }
            }
        }
    }
}
EOF

# Create FileListView.swift
echo "Creating FileListView.swift..."
cat > FileListView.swift << 'EOF'
import SwiftUI

struct FileListView: View {
    let files: [FileItem]
    
    var body: some View {
        List(files) { file in
            HStack(spacing: 12) {
                Image(systemName: iconName(for: file.url))
                    .foregroundColor(.accentColor)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(file.name)
                        .font(.body)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        if let size = file.size {
                            Text(formatBytes(size))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if let pages = file.pageCount {
                            if file.size != nil {
                                Text("•")
                                    .foregroundColor(.secondary)
                            }
                            Text("\(pages) page\(pages == 1 ? "" : "s")")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .listStyle(.inset)
    }
    
    private func iconName(for url: URL) -> String {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "pdf":
            return "doc.fill"
        case "jpg", "jpeg", "png", "tif", "tiff":
            return "photo.fill"
        default:
            return "doc"
        }
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}
EOF

echo ""
echo -e "${GREEN}✓ All files created!${NC}"
echo ""

# Copy the complete project.yml
echo "Setting up project.yml..."
cp project_complete.yml project.yml

# Generate project
echo ""
echo -e "${BLUE}Generating Xcode project...${NC}"
xcodegen generate

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Success! Project ready.${NC}"
    echo ""
    echo "Files created:"
    echo "  ✓ FileItem.swift"
    echo "  ✓ FileValidator.swift"
    echo "  ✓ DropZoneView.swift"
    echo "  ✓ FileListView.swift"
    echo ""
    echo "Project generated with:"
    echo "  ✓ Info.plist auto-generation"
    echo "  ✓ All v1.1 features"
    echo ""
    echo "Next:"
    echo "  open PDFCombineStamp.xcodeproj"
    echo "  Build (⌘B)"
    echo ""
else
    echo ""
    echo "❌ Generation failed"
fi
