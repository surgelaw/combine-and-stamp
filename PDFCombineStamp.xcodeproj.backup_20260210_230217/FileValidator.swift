import Foundation
import UniformTypeIdentifiers
import PDFKit
import AppKit

/// Validates files for PDF processing
class FileValidator {
    /// Supported file extensions
    static let supportedExtensions = ["pdf", "jpg", "jpeg", "png", "tif", "tiff"]
    
    /// Check if a single file is valid
    /// - Parameter url: The file URL to validate
    /// - Returns: True if the file is supported
    static func isValidFile(_ url: URL) -> Bool {
        let ext = url.pathExtension.lowercased()
        return supportedExtensions.contains(ext)
    }
    
    /// Validate multiple files and separate into valid and invalid
    /// - Parameter urls: Array of file URLs to validate
    /// - Returns: Tuple of (valid URLs, invalid URLs)
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
    
    /// Get file size for a URL
    /// - Parameter url: The file URL
    /// - Returns: File size in bytes, or nil if unavailable
    static func getFileSize(_ url: URL) -> Int64? {
        let resources = try? url.resourceValues(forKeys: [.fileSizeKey])
        return resources?.fileSize.map { Int64($0) }
    }
    
    /// Get page count for a file (PDF or image)
    /// - Parameter url: The file URL
    /// - Returns: Number of pages, or nil if unavailable
    static func getPageCount(_ url: URL) -> Int? {
        let ext = url.pathExtension.lowercased()
        
        if ext == "pdf" {
            // For PDF files, get actual page count
            guard let pdfDocument = PDFDocument(url: url) else {
                return nil
            }
            return pdfDocument.pageCount
        } else if ["jpg", "jpeg", "png", "tif", "tiff"].contains(ext) {
            // For image files, it's always 1 page
            guard NSImage(contentsOf: url) != nil else {
                return nil
            }
            return 1
        }
        
        return nil
    }
    
    /// Get both file size and page count (useful for batch processing)
    /// - Parameter url: The file URL
    /// - Returns: Tuple of (size in bytes, page count)
    static func getFileMetadata(_ url: URL) -> (size: Int64?, pageCount: Int?) {
        return (getFileSize(url), getPageCount(url))
    }
}
