import Cocoa
import SwiftUI
import UniformTypeIdentifiers

class ShareViewController: NSViewController {
    
    private var hostingController: NSHostingController<ExtensionView>?
    private var extensionContext: NSExtensionContext?
    
    override func loadView() {
        self.view = NSView()
        self.view.frame = NSRect(x: 0, y: 0, width: 460, height: 400)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        extractURLsFromExtensionContext { [weak self] urls in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                let extensionView = ExtensionView(
                    urls: urls,
                    onComplete: { outputURL in
                        self.completeRequest(outputURL: outputURL)
                    },
                    onCancel: {
                        self.cancelRequest()
                    }
                )
                
                let hostingController = NSHostingController(rootView: extensionView)
                self.addChild(hostingController)
                hostingController.view.frame = self.view.bounds
                hostingController.view.autoresizingMask = [.width, .height]
                self.view.addSubview(hostingController.view)
                self.hostingController = hostingController
                
                // Set preferred size
                self.preferredContentSize = NSSize(width: 460, height: 400)
            }
        }
    }
    
    private func extractURLsFromExtensionContext(completion: @escaping ([URL]) -> Void) {
        guard let context = self.extensionContext,
              let items = context.inputItems as? [NSExtensionItem] else {
            completion([])
            return
        }
        
        var urls: [URL] = []
        let group = DispatchGroup()
        
        for item in items {
            guard let attachments = item.attachments else { continue }
            
            for provider in attachments {
                // Check for file URLs
                if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
                    group.enter()
                    provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (item, error) in
                        defer { group.leave() }
                        
                        if let url = item as? URL {
                            urls.append(url)
                        } else if let data = item as? Data,
                                  let url = URL(dataRepresentation: data, relativeTo: nil) {
                            urls.append(url)
                        }
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(urls)
        }
    }
    
    private func completeRequest(outputURL: URL?) {
        if let outputURL = outputURL {
            // Reveal in Finder
            NSWorkspace.shared.activateFileViewerSelecting([outputURL])
        }
        
        // Complete the extension request
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
    }
    
    private func cancelRequest() {
        let error = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext?.cancelRequest(withError: error)
    }
}
