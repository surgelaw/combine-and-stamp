import SwiftUI

struct ContentView: View {
    @State private var droppedFiles: [FileItem] = []
    @State private var showingOptions = false
    
    /// Calculate total page count from all files
    private var totalPageCount: Int? {
        let counts = droppedFiles.compactMap { $0.pageCount }
        guard counts.count == droppedFiles.count else {
            return nil // Some files don't have page counts yet
        }
        return counts.reduce(0, +)
    }
    
    var body: some View {
        NavigationStack {
            if droppedFiles.isEmpty {
                // Show drop zone and instructions when no files
                VStack(spacing: 30) {
                    DropZoneView(droppedFiles: $droppedFiles)
                        .frame(maxHeight: 300)
                    
                    // Instructions
                    VStack(alignment: .leading, spacing: 12) {
                        Text("How to use:")
                            .font(.headline)
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("1.")
                                .fontWeight(.bold)
                            Text("Drag PDF or image files into the drop zone above")
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("2.")
                                .fontWeight(.bold)
                            Text("Configure your Bates stamp options")
                        }
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("3.")
                                .fontWeight(.bold)
                            Text("Click \"Process Files\" to combine and stamp")
                        }
                        
                        Divider()
                            .padding(.vertical, 4)
                        
                        Text("Or use the Quick Action:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        HStack(alignment: .top, spacing: 8) {
                            Text("•")
                            Text("Right-click files in Finder → Quick Actions → Combine PDFs and Stamp")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: 500, alignment: .leading)
                    .padding()
                    .background(Color.secondary.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding()
                .navigationTitle("PDF Combine & Stamp")
            } else {
                // Show file list when files are present
                VStack(spacing: 0) {
                    ReorderableFileListView(files: $droppedFiles)
                    
                    Divider()
                    
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(droppedFiles.count) file\(droppedFiles.count == 1 ? "" : "s") selected")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            if let totalPages = totalPageCount {
                                Text("\(totalPages) page\(totalPages == 1 ? "" : "s") total")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        Button("Add More Files...") {
                            selectMoreFiles()
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Clear All") {
                            withAnimation {
                                droppedFiles = []
                            }
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Process Files") {
                            showingOptions = true
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(droppedFiles.isEmpty)
                    }
                    .padding()
                    .background(Color(NSColor.windowBackgroundColor))
                }
                .navigationTitle("PDF Combine & Stamp")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            withAnimation {
                                droppedFiles = []
                            }
                        } label: {
                            Label("Clear All", systemImage: "trash")
                        }
                    }
                }
                .sheet(isPresented: $showingOptions) {
                    BatesStampView(urls: droppedFiles.map { $0.url })
                }
                // Allow dropping more files even when list is showing
                .onDrop(of: [.fileURL], isTargeted: .constant(false)) { providers in
                    handleAdditionalDrop(providers: providers)
                    return true
                }
            }
        }
        .frame(minWidth: 600, minHeight: 500)
    }
    
    // MARK: - Helper Methods
    
    /// Handle additional files dropped when list is already showing
    private func handleAdditionalDrop(providers: [NSItemProvider]) {
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
            let (valid, _) = FileValidator.validateFiles(urls)
            
            // Add valid files to existing list with metadata
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
                        withAnimation {
                            droppedFiles.append(contentsOf: newFiles)
                        }
                    }
                }
            }
        }
    }
    
    /// Show file picker to add more files
    private func selectMoreFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.pdf, .jpeg, .png, .tiff]
        panel.message = "Select PDF or image files to add"
        
        panel.begin { response in
            if response == .OK {
                DispatchQueue.global(qos: .userInitiated).async {
                    let newFiles = panel.urls.map { url -> FileItem in
                        let metadata = FileValidator.getFileMetadata(url)
                        return FileItem(
                            url: url,
                            size: metadata.size,
                            pageCount: metadata.pageCount
                        )
                    }
                    
                    DispatchQueue.main.async {
                        withAnimation {
                            droppedFiles.append(contentsOf: newFiles)
                        }
                    }
                }
            }
        }
    }
}

#Preview("Empty State") {
    ContentView()
}


