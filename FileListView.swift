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
