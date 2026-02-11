#!/bin/bash
# Create PresetPickerView and PresetEditorView

echo "Creating PresetPickerView.swift..."
cat > PresetPickerView.swift << 'SWIFTCODE'
import SwiftUI

struct PresetPickerView: View {
    @ObservedObject var presetManager: PresetManager
    @Binding var selectedPreset: StampPreset?
    @Environment(\.dismiss) var dismiss
    
    @State private var showingEditor = false
    @State private var showingImporter = false
    @State private var presetToEdit: StampPreset?
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Presets")
                    .font(.headline)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            Divider()
            
            if presetManager.presets.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "tray")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No Presets")
                        .font(.headline)
                    Text("Create your first preset to get started")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(presetManager.presets) { preset in
                        PresetRowView(preset: preset)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedPreset = preset
                                dismiss()
                            }
                            .contextMenu {
                                Button("Edit") {
                                    presetToEdit = preset
                                    showingEditor = true
                                }
                                Button("Export...") {
                                    exportPreset(preset)
                                }
                                Divider()
                                Button("Delete", role: .destructive) {
                                    presetManager.deletePreset(preset)
                                }
                            }
                    }
                    .onDelete { offsets in
                        presetManager.deletePresets(at: offsets)
                    }
                }
                .listStyle(.inset)
            }
            
            Divider()
            
            HStack(spacing: 12) {
                Menu {
                    Button("Import Preset...") {
                        showingImporter = true
                    }
                    Button("Export All...") {
                        exportAllPresets()
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .menuStyle(.borderlessButton)
                
                Spacer()
                
                Button("New Preset") {
                    presetToEdit = nil
                    showingEditor = true
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .frame(width: 400, height: 500)
        .sheet(isPresented: $showingEditor) {
            PresetEditorView(
                presetManager: presetManager,
                preset: presetToEdit
            )
        }
        .fileImporter(
            isPresented: $showingImporter,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false
        ) { result in
            handleImport(result)
        }
    }
    
    private func exportPreset(_ preset: StampPreset) {
        guard let data = presetManager.exportPreset(preset) else { return }
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.json]
        panel.nameFieldStringValue = "\(preset.name).json"
        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? data.write(to: url)
            }
        }
    }
    
    private func exportAllPresets() {
        guard let data = presetManager.exportAllPresets() else { return }
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.json]
        panel.nameFieldStringValue = "Presets.json"
        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? data.write(to: url)
            }
        }
    }
    
    private func handleImport(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            do {
                let data = try Data(contentsOf: url)
                _ = presetManager.importPresets(from: data, merge: true)
            } catch {
                print("Import failed: \(error)")
            }
        case .failure(let error):
            print("File selection failed: \(error)")
        }
    }
}

struct PresetRowView: View {
    let preset: StampPreset
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(preset.name)
                .font(.body)
            HStack(spacing: 8) {
                if !preset.prefix.isEmpty {
                    Label(preset.prefix, systemImage: "textformat")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Label("#\(preset.startingNumber)", systemImage: "number")
                    .font(.caption)
                    .foregroundColor(.secondary)
                if !preset.isBatesEnabled {
                    Label("No Stamp", systemImage: "xmark.circle")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
SWIFTCODE

echo "Creating PresetEditorView.swift..."
cat > PresetEditorView.swift << 'SWIFTCODE'
import SwiftUI

struct PresetEditorView: View {
    @ObservedObject var presetManager: PresetManager
    let preset: StampPreset?
    
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var prefix: String = "BATES-"
    @State private var startingNumber: String = "1"
    @State private var outputFilename: String = "Combined"
    @State private var isBatesEnabled: Bool = true
    @State private var validationError: String?
    
    private var isEditing: Bool { preset != nil }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(isEditing ? "Edit Preset" : "New Preset")
                    .font(.headline)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            Divider()
            
            Form {
                Section {
                    TextField("Preset Name", text: $name)
                        .help("Give this preset a descriptive name")
                }
                
                Section("Stamp Configuration") {
                    Toggle("Add Bates Stamp", isOn: $isBatesEnabled)
                    
                    if isBatesEnabled {
                        TextField("Prefix", text: $prefix)
                            .help("Optional text before the page number")
                        TextField("Starting Number", text: $startingNumber)
                            .help("The first page number to use")
                    }
                }
                
                Section("Output") {
                    TextField("Output Filename", text: $outputFilename)
                        .help("Base filename for the combined PDF")
                }
            }
            .formStyle(.grouped)
            .scrollContentBackground(.hidden)
            
            if let error = validationError {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
            }
            
            Divider()
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Spacer()
                
                Button(isEditing ? "Update" : "Create") {
                    savePreset()
                }
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
            .padding()
        }
        .frame(width: 400, height: 450)
        .onAppear {
            loadPresetData()
        }
    }
    
    private func loadPresetData() {
        if let preset = preset {
            name = preset.name
            prefix = preset.prefix
            startingNumber = String(preset.startingNumber)
            outputFilename = preset.outputFilename
            isBatesEnabled = preset.isBatesEnabled
        }
    }
    
    private func savePreset() {
        guard let number = Int(startingNumber), number > 0 else {
            validationError = "Starting number must be a positive integer"
            return
        }
        
        let newPreset = StampPreset(
            id: preset?.id ?? UUID(),
            name: name,
            prefix: prefix,
            startingNumber: number,
            outputFilename: outputFilename,
            isBatesEnabled: isBatesEnabled,
            createdDate: preset?.createdDate ?? Date(),
            modifiedDate: Date()
        )
        
        let validation = presetManager.validate(newPreset)
        if case .invalid(let message) = validation {
            validationError = message
            return
        }
        
        if isEditing {
            presetManager.updatePreset(newPreset)
        } else {
            presetManager.addPreset(newPreset)
        }
        
        dismiss()
    }
}
SWIFTCODE

echo ""
echo "✅ Created PresetPickerView.swift"
echo "✅ Created PresetEditorView.swift"
echo ""
echo "Now run: ./complete-rebuild.sh"

