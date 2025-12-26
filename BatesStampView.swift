import SwiftUI

struct BatesStampView: View {
    let urls: [URL]
    @State private var prefix: String = "BATES-"
    @State private var startingNumber: Int = 1
    @State private var isBatesEnabled: Bool = true
    @State private var isProcessing: Bool = false
    @State private var forceProceed: Bool = false
    
    private var supportedURLs: [URL] {
        urls.filter { PDFManager.isSupported(url: $0) }
    }
    
    private var unsupportedURLs: [URL] {
        urls.filter { !PDFManager.isSupported(url: $0) }
    }
    
    private var totalFileSize: Int64 {
        PDFManager.totalFileSize(urls: supportedURLs)
    }
    
    private var fileSizeWarning: String? {
        let sizeMB = Double(totalFileSize) / (1024 * 1024)
        if sizeMB > 1500 {
            return "Very Large File Warning: Combined size exceeds 1.5 GB. Process may consume significant resources."
        } else if sizeMB > 500 {
            return "Large File Warning: Combined size exceeds 500 MB. Process might take a few minutes."
        }
        return nil
    }
    
    private var needsForceProceed: Bool {
        Double(totalFileSize) / (1024 * 1024) > 1500
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
            
            // Large File Warning
            if let warning = fileSizeWarning {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "slowmo")
                        Text(warning)
                            .font(.subheadline.bold())
                    }
                    .foregroundColor(.red)
                    
                    if needsForceProceed {
                        Toggle("Force Proceed", isOn: $forceProceed)
                            .font(.caption)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.red.opacity(0.05))
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
            .padding(.top, -10)
            
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
                .disabled(isProcessing || supportedURLs.isEmpty || (needsForceProceed && !forceProceed))
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
                    
                    NSApp.hide(nil)
                    
                    // Reveal and select in Finder
                    NSWorkspace.shared.activateFileViewerSelecting([outputURL])
                    
                    // Small delay before termination
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        NSApplication.shared.terminate(nil)
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
}
