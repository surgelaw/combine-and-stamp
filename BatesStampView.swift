import SwiftUI

struct BatesStampView: View {
    let urls: [URL]
    @State private var prefix: String = "BATES-"
    @State private var startingNumber: Int = 1
    @State private var isBatesEnabled: Bool = true
    @State private var isProcessing: Bool = false
    @State private var forceProceed: Bool = false
    
    // Presets
    @StateObject private var presetManager = PresetManager()
    @State private var showingPresetPicker = false
    @State private var showingPresetSaver = false
    @State private var currentPresetId: UUID? // Track which preset is currently loaded
    
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
                // Presets Section
                Section {
                    Button {
                        showingPresetPicker = true
                    } label: {
                        HStack {
                            Image(systemName: "bookmark")
                            Text("Load Preset")
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                    .help("Load a saved preset configuration")
                    
                    Button {
                        showingPresetSaver = true
                    } label: {
                        HStack {
                            Image(systemName: "bookmark.fill")
                            Text("Save as Preset")
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                    .help("Save current settings as a new preset")
                }
                .padding()
                
                Divider()
                
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
                .padding()
            }
            .formStyle(.grouped)
            .sheet(isPresented: $showingPresetPicker) {
                PresetPickerView(
                    presetManager: presetManager,
                    selectedPreset: Binding<StampPreset?>(
                        get: { nil },
                        set: { (preset: StampPreset?) in
                            if let preset = preset {
                                loadPreset(preset)
                            }
                        }
                    )
                )
            }
            .sheet(isPresented: $showingPresetSaver) {
                PresetEditorView(
                    presetManager: presetManager,
                    preset: nil as StampPreset?
                )
            }
            
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
        .frame(minWidth: 440, maxWidth: 440, minHeight: 350)
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
    
    // MARK: - Preset Management
    
    private func loadPreset(_ preset: StampPreset) {
        prefix = preset.prefix
        startingNumber = preset.suggestedStartingNumber // Use the running total
        isBatesEnabled = preset.isBatesEnabled
        currentPresetId = preset.id // Track which preset is loaded
    }
    
    // MARK: - File Processing
    
    func processFiles() {
        isProcessing = true
        let filesToProcess = supportedURLs
        let startNum = startingNumber // Capture the starting number used
        let presetId = currentPresetId // Capture preset ID
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let outputDirectory = filesToProcess.first?.deletingLastPathComponent() ?? 
                                     FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
                
                let name = "Combined_\(Int(Date().timeIntervalSince1970)).pdf"
                let outputURL = outputDirectory.appendingPathComponent(name)
                
                // Get total page count for running total
                let totalPages = self.getTotalPageCount(for: filesToProcess)
                
                try PDFManager.shared.combineAndStamp(
                    urls: filesToProcess,
                    prefix: prefix,
                    startingNumber: startNum,
                    batesEnabled: isBatesEnabled,
                    outputURL: outputURL
                )
                
                DispatchQueue.main.async {
                    // Record preset usage if a preset was loaded
                    if let presetId = presetId, totalPages > 0 {
                        self.presetManager.recordPresetUsage(
                            presetId: presetId,
                            startNumber: startNum,
                            pageCount: totalPages
                        )
                    }
                    
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
    
    /// Get total page count for all files
    private func getTotalPageCount(for urls: [URL]) -> Int {
        var total = 0
        for url in urls {
            if let pageCount = FileValidator.getPageCount(url) {
                total += pageCount
            }
        }
        return total
    }
}
