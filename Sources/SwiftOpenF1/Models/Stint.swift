import Foundation

public enum TireCompound: String, Sendable, Codable, CaseIterable {
    case soft = "SOFT"
    case medium = "MEDIUM"
    case hard = "HARD"
    case intermediate = "INTERMEDIATE"
    case wet = "WET"

    public var shortBadge: String {
        switch self {
        case .soft: return "S"
        case .medium: return "M"
        case .hard: return "H"
        case .intermediate: return "I"
        case .wet: return "W"
        }
    }

    public var badgeColorHex: String {
        switch self {
        case .soft: return "#E80020"       // Red
        case .medium: return "#FFF500"     // Yellow
        case .hard: return "#FFFFFF"       // White
        case .intermediate: return "#39B54A" // Green
        case .wet: return "#00AEEF"        // Blue
        }
    }
}

public struct TireStint: Sendable, Codable, Hashable {
    public let compound: TireCompound
    public var lapsDriven: Int
    public let pitStopDurationSeconds: Double?

    public init(compound: TireCompound, lapsDriven: Int, pitStopDurationSeconds: Double? = nil) {
        self.compound = compound
        self.lapsDriven = lapsDriven
        self.pitStopDurationSeconds = pitStopDurationSeconds
    }
}
