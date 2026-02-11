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
                                
                                // Show reset option if running total has been incremented
                                if preset.nextNumber != preset.startingNumber {
                                    Divider()
                                    Button("Reset to #\(preset.startingNumber)") {
                                        presetManager.resetPresetRunningTotal(presetId: preset.id)
                                    }
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
                
                // Show next number if it's different from starting number
                if preset.nextNumber != preset.startingNumber {
                    Label("Next: #\(preset.nextNumber)", systemImage: "arrow.right.circle.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                } else {
                    Label("#\(preset.startingNumber)", systemImage: "number")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
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
