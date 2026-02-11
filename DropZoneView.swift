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
