#!/bin/bash
# Create all preset-related files

echo "Creating StampPreset.swift..."
cat > StampPreset.swift << 'SWIFTCODE'
import Foundation
import SwiftUI

/// Represents a saved preset for Bates stamp configuration
struct StampPreset: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var prefix: String
    var startingNumber: Int
    var outputFilename: String
    var isBatesEnabled: Bool
    var createdDate: Date
    var modifiedDate: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        prefix: String = "BATES-",
        startingNumber: Int = 1,
        outputFilename: String = "Combined",
        isBatesEnabled: Bool = true,
        createdDate: Date = Date(),
        modifiedDate: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.prefix = prefix
        self.startingNumber = startingNumber
        self.outputFilename = outputFilename
        self.isBatesEnabled = isBatesEnabled
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
    
    static func == (lhs: StampPreset, rhs: StampPreset) -> Bool {
        lhs.id == rhs.id
    }
}

extension StampPreset {
    static let defaultPresets: [StampPreset] = [
        StampPreset(
            name: "Simple Bates",
            prefix: "",
            startingNumber: 1
        ),
        StampPreset(
            name: "Court Filing",
            prefix: "EX-",
            startingNumber: 1,
            outputFilename: "Exhibit"
        ),
        StampPreset(
            name: "Legal Discovery",
            prefix: "DISC-",
            startingNumber: 1,
            outputFilename: "Discovery"
        )
    ]
}
SWIFTCODE

echo "Creating PresetManager.swift..."
cat > PresetManager.swift << 'SWIFTCODE'
import Foundation
import Combine

class PresetManager: ObservableObject {
    @Published var presets: [StampPreset] = []
    
    private let userDefaultsKey = "stampPresets"
    private let appGroupIdentifier = "group.com.yourcompany.pdfcombinestamp"
    
    private var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }
    
    init() {
        loadPresets()
    }
    
    func loadPresets() {
        guard let defaults = sharedDefaults else {
            presets = StampPreset.defaultPresets
            return
        }
        
        guard let data = defaults.data(forKey: userDefaultsKey) else {
            presets = StampPreset.defaultPresets
            savePresets()
            return
        }
        
        do {
            let decoded = try JSONDecoder().decode([StampPreset].self, from: data)
            presets = decoded
        } catch {
            print("Error decoding presets: \(error)")
            presets = StampPreset.defaultPresets
        }
    }
    
    func savePresets() {
        guard let defaults = sharedDefaults else {
            return
        }
        
        do {
            let encoded = try JSONEncoder().encode(presets)
            defaults.set(encoded, forKey: userDefaultsKey)
            defaults.synchronize()
        } catch {
            print("Error encoding presets: \(error)")
        }
    }
    
    func addPreset(_ preset: StampPreset) {
        presets.append(preset)
        savePresets()
    }
    
    func updatePreset(_ preset: StampPreset) {
        if let index = presets.firstIndex(where: { $0.id == preset.id }) {
            var updated = preset
            updated.modifiedDate = Date()
            presets[index] = updated
            savePresets()
        }
    }
    
    func deletePreset(_ preset: StampPreset) {
        presets.removeAll { $0.id == preset.id }
        savePresets()
    }
    
    func deletePresets(at offsets: IndexSet) {
        presets.remove(atOffsets: offsets)
        savePresets()
    }
    
    func exportPreset(_ preset: StampPreset) -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            return try encoder.encode(preset)
        } catch {
            return nil
        }
    }
    
    func exportAllPresets() -> Data? {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            return try encoder.encode(presets)
        } catch {
            return nil
        }
    }
    
    func importPresets(from data: Data, merge: Bool = true) -> Result<[StampPreset], Error> {
        do {
            let decoder = JSONDecoder()
            
            if let importedArray = try? decoder.decode([StampPreset].self, from: data) {
                if merge {
                    let existingNames = Set(presets.map { $0.name })
                    let newPresets = importedArray.filter { !existingNames.contains($0.name) }
                    presets.append(contentsOf: newPresets)
                } else {
                    presets = importedArray
                }
                savePresets()
                return .success(importedArray)
            }
            
            if let importedPreset = try? decoder.decode(StampPreset.self, from: data) {
                if merge && !presets.contains(where: { $0.name == importedPreset.name }) {
                    presets.append(importedPreset)
                } else if !merge {
                    presets = [importedPreset]
                }
                savePresets()
                return .success([importedPreset])
            }
            
            throw PresetError.invalidFormat
        } catch {
            return .failure(error)
        }
    }
    
    func validate(_ preset: StampPreset) -> ValidationResult {
        if preset.name.trimmingCharacters(in: .whitespaces).isEmpty {
            return .invalid("Preset name cannot be empty")
        }
        
        if presets.contains(where: { $0.name == preset.name && $0.id != preset.id }) {
            return .invalid("A preset with this name already exists")
        }
        
        if preset.startingNumber < 1 {
            return .invalid("Starting number must be at least 1")
        }
        
        return .valid
    }
}

enum PresetError: LocalizedError {
    case invalidFormat
    case duplicateName
    case emptyName
    
    var errorDescription: String? {
        switch self {
        case .invalidFormat: return "Invalid preset file format"
        case .duplicateName: return "A preset with this name already exists"
        case .emptyName: return "Preset name cannot be empty"
        }
    }
}

enum ValidationResult {
    case valid
    case invalid(String)
    
    var isValid: Bool {
        if case .valid = self { return true }
        return false
    }
    
    var errorMessage: String? {
        if case .invalid(let message) = self { return message }
        return nil
    }
}
SWIFTCODE

echo ""
echo "✅ Created StampPreset.swift"
echo "✅ Created PresetManager.swift"
echo ""
echo "Now run: ./regenerate-xcode-project.sh"

