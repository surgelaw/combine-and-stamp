import SwiftUI

@main
struct BatesStampApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
        
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var panel: NSPanel?
    var urls: [URL] = []
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Check if launched with command line arguments (for backwards compatibility)
        let args = ProcessInfo.processInfo.arguments
        if args.count > 1 {
            urls = args.dropFirst().map { URL(fileURLWithPath: $0) }
            
            // If we have URLs, show the panel in agent mode
            if !urls.isEmpty {
                setupPanel()
                NSApp.setActivationPolicy(.accessory)
                NSApp.activate(ignoringOtherApps: true)
                panel?.makeKeyAndOrderFront(nil)
            }
        }
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
        // Only terminate if we're running with the panel (agent mode)
        return panel != nil
    }
}
