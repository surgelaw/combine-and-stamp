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
