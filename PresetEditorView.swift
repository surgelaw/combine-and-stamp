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
