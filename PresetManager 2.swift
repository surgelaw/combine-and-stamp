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
    
    /// Record usage of a preset after processing files
    /// - Parameters:
    ///   - presetId: The ID of the preset that was used
    ///   - startNumber: The actual starting number used
    ///   - pageCount: The number of pages that were stamped
    func recordPresetUsage(presetId: UUID, startNumber: Int, pageCount: Int) {
        if let index = presets.firstIndex(where: { $0.id == presetId }) {
            presets[index].recordUsage(startNumber: startNumber, pageCount: pageCount)
            savePresets()
        }
    }
    
    /// Reset a preset's running total back to its original starting number
    /// - Parameter presetId: The ID of the preset to reset
    func resetPresetRunningTotal(presetId: UUID) {
        if let index = presets.firstIndex(where: { $0.id == presetId }) {
            presets[index].resetRunningTotal()
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
