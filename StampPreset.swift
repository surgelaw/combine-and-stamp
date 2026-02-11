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
