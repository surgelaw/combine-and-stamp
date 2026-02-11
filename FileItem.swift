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
