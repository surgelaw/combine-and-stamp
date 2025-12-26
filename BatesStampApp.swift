import SwiftUI

@main
struct BatesStampApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings { } // Dummy scene to prevent default window behavior
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: NSPanel?
    var urls: [URL] = []
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let args = ProcessInfo.processInfo.arguments
        if args.count > 1 {
            urls = args.dropFirst().map { URL(fileURLWithPath: $0) }
        }
        
        if urls.isEmpty {
            NSApplication.shared.terminate(nil)
            return
        }

        setupPanel()
        
        // Ensure the app and panel come to foreground
        NSApp.setActivationPolicy(.accessory) // Agent mode
        NSApp.activate(ignoringOtherApps: true)
        panel?.makeKeyAndOrderFront(nil)
    }
    
    private func setupPanel() {
        let contentView = BatesStampView(urls: urls)
        
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 440, height: 300),
            styleMask: [.titled, .closable, .fullSizeContentView, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.standardWindowButton(.miniaturizeButton)?.isHidden = true
        panel.standardWindowButton(.zoomButton)?.isHidden = true
        panel.isMovableByWindowBackground = true
        
        panel.contentView = NSHostingView(rootView: contentView)
        panel.center()
        
        self.panel = panel
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
