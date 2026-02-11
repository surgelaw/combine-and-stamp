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
    
    // Running total tracking
    var nextNumber: Int // The next number to use (auto-incremented)
    var lastUsedNumber: Int? // Track what number was actually used
    
    init(
        id: UUID = UUID(),
        name: String,
        prefix: String = "BATES-",
        startingNumber: Int = 1,
        outputFilename: String = "Combined",
        isBatesEnabled: Bool = true,
        createdDate: Date = Date(),
        modifiedDate: Date = Date(),
        nextNumber: Int? = nil,
        lastUsedNumber: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.prefix = prefix
        self.startingNumber = startingNumber
        self.outputFilename = outputFilename
        self.isBatesEnabled = isBatesEnabled
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
        self.nextNumber = nextNumber ?? startingNumber
        self.lastUsedNumber = lastUsedNumber
    }
    
    static func == (lhs: StampPreset, rhs: StampPreset) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Update the preset after processing files
    /// - Parameters:
    ///   - startNumber: The number that was actually used to start stamping
    ///   - pageCount: The number of pages that were stamped
    mutating func recordUsage(startNumber: Int, pageCount: Int) {
        self.lastUsedNumber = startNumber
        self.nextNumber = startNumber + pageCount
        self.modifiedDate = Date()
    }
    
    /// Get the suggested starting number (nextNumber or startingNumber if never used)
    var suggestedStartingNumber: Int {
        return nextNumber
    }
    
    /// Reset the running total back to the original starting number
    mutating func resetRunningTotal() {
        self.nextNumber = startingNumber
        self.lastUsedNumber = nil
        self.modifiedDate = Date()
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
