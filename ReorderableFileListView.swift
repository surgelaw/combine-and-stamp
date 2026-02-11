import SwiftUI

/// A list view that allows drag-to-reorder files
struct ReorderableFileListView: View {
    @Binding var files: [FileItem]
    
    var body: some View {
        List {
            ForEach(files.indices, id: \.self) { index in
                FileRowView(file: files[index], position: index + 1)
            }
            .onMove { source, destination in
                files.move(fromOffsets: source, toOffset: destination)
            }
        }
        .listStyle(.inset)
    }
}
