import SwiftUI

struct BatesStampView: View {
    let urls: [URL]
    @State private var prefix: String = "BATES-"
    @State private var startingNumber: Int = 1
    @State private var isBatesEnabled: Bool = true
    @State private var isProcessing: Bool = false
    
    private var supportedURLs: [URL] {
        urls.filter { PDFManager.isSupported(url: $0) }
    }
    
    private var unsupportedURLs: [URL] {
        urls.filter { !PDFManager.isSupported(url: $0) }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Warning View at the very top
            if !unsupportedURLs.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("Unsupported files will be skipped")
                            .font(.headline)
                    }
                    .foregroundColor(.orange)
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 2) {
                            ForEach(unsupportedURLs, id: \.self) { url in
                                Text(url.lastPathComponent)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .frame(maxHeight: 60)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                Divider()
            }
            
            Form {
                Section {
                    Toggle("Add Bates Stamp", isOn: $isBatesEnabled)
                        .font(.body)
                        .padding(.bottom, 8)
                    
                    if isBatesEnabled {
                        TextField("Prefix:", text: $prefix)
                            .font(.body)
                        
                        TextField("Start Number:", value: $startingNumber, format: .number)
                            .font(.body)
                    }
                }
            }
            .formStyle(.grouped)
            .padding(.top, -10) // Tighter integration
            
            Divider()
            
            // Footer Buttons
            HStack(spacing: 12) {
                if supportedURLs.isEmpty {
                    Text("No supported files selected")
                        .font(.caption)
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                Button("Cancel") {
                    NSApplication.shared.terminate(nil)
                }
                .keyboardShortcut(.cancelAction)
                .font(.body)
                
                Button("Combine and Stamp") {
                    processFiles()
                }
                .buttonStyle(.borderedProminent)
                .disabled(isProcessing || supportedURLs.isEmpty)
                .keyboardShortcut(.defaultAction)
                .font(.body)
            }
            .padding()
            .background(Color(NSColor.windowBackgroundColor))
        }
        .frame(width: 440)
        .overlay {
            if isProcessing {
                ZStack {
                    Color.black.opacity(0.15)
                    VStack {
                        ProgressView()
                        Text("Processing...")
                            .font(.headline)
                            .padding(.top)
                    }
                    .padding(30)
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                }
            }
        }
    }
    
    func processFiles() {
        isProcessing = true
        let filesToProcess = supportedURLs
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // Use the directory of the first file
                let outputDirectory = filesToProcess.first?.deletingLastPathComponent() ?? 
                                     FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
                
                let name = "Combined_\(Int(Date().timeIntervalSince1970)).pdf"
                let outputURL = outputDirectory.appendingPathComponent(name)
                
                try PDFManager.shared.combineAndStamp(
                    urls: filesToProcess,
                    prefix: prefix,
                    startingNumber: startingNumber,
                    batesEnabled: isBatesEnabled,
                    outputURL: outputURL
                )
                
                DispatchQueue.main.async {
                    isProcessing = false
                    
                    // Hide the app windows immediately so the UI is gone
                    NSApp.hide(nil)
                    
                    // Reveal and select in Finder
                    NSWorkspace.shared.activateFileViewerSelecting([outputURL])
                    
                    // Trigger rename in Finder after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        triggerFinderRename(for: outputURL)
                        
                        // Small delay before termination to ensure script hits
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            NSApplication.shared.terminate(nil)
                        }
                    }
                }
            } catch {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    isProcessing = false
                }
            }
        }
    }
    
    private func triggerFinderRename(for url: URL) {
        // More robust AppleScript to trigger rename mode
        let scriptSource = """
        tell application "Finder"
            activate
            set theItem to POSIX file "\(url.path)" as alias
            select theItem
        end tell
        delay 0.1
        tell application "System Events"
            tell process "Finder"
                keystroke return
            end tell
        end tell
        """
        
        if let script = NSAppleScript(source: scriptSource) {
            var error: NSDictionary?
            script.executeAndReturnError(&error)
            if let err = error {
                print("AppleScript Error: \(err)")
            }
        }
    }
}
