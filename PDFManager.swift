import Foundation
import PDFKit
import CoreGraphics
import AppKit

class PDFManager {
    static let shared = PDFManager()
    
    static func isSupported(url: URL) -> Bool {
        if PDFDocument(url: url) != nil { return true }
        if NSImage(contentsOf: url) != nil { return true }
        return false
    }
    
    func combineAndStamp(urls: [URL], prefix: String, startingNumber: Int, batesEnabled: Bool, outputURL: URL) throws {
        let destinationDocument = PDFDocument()
        var batesCounter = startingNumber
        
        // Use URLs in the order they are received (respects Finder selection order)
        for url in urls {
            if let sourceDocument = PDFDocument(url: url) {
                for i in 0..<sourceDocument.pageCount {
                    if let page = sourceDocument.page(at: i) {
                        let stamp = batesEnabled ? "\(prefix)\(String(format: "%06d", batesCounter))" : nil
                        if let stampedPage = createStampedPage(from: .pdf(page), text: stamp) {
                            destinationDocument.insert(stampedPage, at: destinationDocument.pageCount)
                            if batesEnabled { batesCounter += 1 }
                        }
                    }
                }
            } else if let image = NSImage(contentsOf: url) {
                let stamp = batesEnabled ? "\(prefix)\(String(format: "%06d", batesCounter))" : nil
                if let stampedPage = createStampedPage(from: .image(image), text: stamp) {
                    destinationDocument.insert(stampedPage, at: destinationDocument.pageCount)
                    if batesEnabled { batesCounter += 1 }
                }
            }
        }
        
        destinationDocument.write(to: outputURL)
    }
    
    enum PageSource {
        case pdf(PDFPage)
        case image(NSImage)
    }
    
    private func createStampedPage(from source: PageSource, text: String?) -> PDFPage? {
        let mediaBox: CGRect
        switch source {
        case .pdf(let page):
            mediaBox = page.bounds(for: .mediaBox)
        case .image(let image):
            mediaBox = calculateImageMediaBox(for: image)
        }
        
        // If no stamp is needed, we still might need to create a PDFPage for images with the new size
        if text == nil {
            switch source {
            case .pdf(let page): return page.copy() as? PDFPage
            case .image(_): 
                // We still go through the CGContext path to ensure the mediaBox is respected
                break 
            }
        }
        
        let data = NSMutableData()
        guard let consumer = CGDataConsumer(data: data as CFMutableData),
              let context = CGContext(consumer: consumer, mediaBox: nil, nil) else {
            return nil
        }
        
        var box = mediaBox
        context.beginPage(mediaBox: &box)
        
        // Draw original content
        switch source {
        case .pdf(let page):
            page.draw(with: .mediaBox, to: context)
        case .image(let image):
            let graphicsContext = NSGraphicsContext(cgContext: context, flipped: false)
            NSGraphicsContext.current = graphicsContext
            image.draw(in: mediaBox)
            NSGraphicsContext.current = nil
        }
        
        // Draw stamp text with white background for readability
        if let text = text {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: 12),
                .foregroundColor: NSColor.red
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            let line = CTLineCreateWithAttributedString(attributedString)
            
            let textSize = attributedString.size()
            let padding: CGFloat = 20
            let textPadding: CGFloat = 4
            
            let x = mediaBox.width - textSize.width - padding
            let y = padding
            
            // Draw background rectangle
            let backgroundRect = CGRect(
                x: x - textPadding,
                y: y - textPadding,
                width: textSize.width + (textPadding * 2),
                height: textSize.height + (textPadding * 2)
            )
            
            context.setFillColor(NSColor.white.cgColor)
            context.fill(backgroundRect)
            
            // Draw text
            context.textPosition = CGPoint(x: x, y: y)
            CTLineDraw(line, context)
        }
        
        context.endPage()
        context.closePDF()
        
        if let newDoc = PDFDocument(data: data as Data), let newPage = newDoc.page(at: 0) {
            return newPage
        }
        
        return nil
    }

    private func calculateImageMediaBox(for image: NSImage) -> CGRect {
        // Try to find the pixel dimensions to calculate a 300 DPI size
        if let rep = image.representations.first {
            let pxWide = CGFloat(rep.pixelsWide)
            let pxHigh = CGFloat(rep.pixelsHigh)
            
            if pxWide > 0 && pxHigh > 0 {
                // Assume 300 DPI as a standard "high-quality" density.
                // PDF points are always 1/72 inch.
                let dpi: CGFloat = 300.0
                let width = (pxWide / dpi) * 72.0
                let height = (pxHigh / dpi) * 72.0
                return CGRect(x: 0, y: 0, width: width, height: height)
            }
        }
        // Fallback to default size (usually 72 DPI if no metadata)
        return CGRect(origin: .zero, size: image.size)
    }
}
