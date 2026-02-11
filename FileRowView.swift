import SwiftUI

/// A row view for displaying a single file with reordering capability
struct FileRowView: View {
    let file: FileItem
    let position: Int
    
    init(file: FileItem, position: Int) {
        self.file = file
        self.position = position
    }
    
    var body: some View {
        HStack(spacing: 12) {
            // Position number
            Text("\(position)")
                .font(.caption.bold())
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(Circle().fill(Color.accentColor))
            
            // File icon
            Image(systemName: iconName(for: file.url))
                .foregroundColor(.accentColor)
                .font(.title3)
            
            // File info
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
            
            // Drag indicator
            Image(systemName: "line.3.horizontal")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
    }
    
    private func iconName(for url: URL) -> String {
        let ext = url.pathExtension.lowercased()
        return ext == "pdf" ? "doc.fill" : "photo.fill"
    }
    
    private func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}
