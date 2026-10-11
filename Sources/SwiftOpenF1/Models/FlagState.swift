import Foundation

public enum FlagState: String, Sendable, Codable {
    case green = "GREEN"
    case yellow = "YELLOW"
    case doubleYellow = "DOUBLE_YELLOW"
    case red = "RED"
    case safetyCar = "SC"
    case virtualSafetyCar = "VSC"
    case chequered = "CHEQUERED"

    public var bannerTitle: String {
        switch self {
        case .green: return "TRACK CLEAR"
        case .yellow: return "YELLOW FLAG - SECTOR SLOW"
        case .doubleYellow: return "DOUBLE YELLOW - PREPARE TO STOP"
        case .red: return "RED FLAG - SESSION SUSPENDED"
        case .safetyCar: return "SAFETY CAR DEPLOYED"
        case .virtualSafetyCar: return "VIRTUAL SAFETY CAR"
        case .chequered: return "FINISH - CHEQUERED FLAG"
        }
    }

    public var colorHex: String {
        switch self {
        case .green: return "#39B54A"
        case .yellow, .doubleYellow: return "#FFF500"
        case .red: return "#E80020"
        case .safetyCar, .virtualSafetyCar: return "#FF8000"
        case .chequered: return "#FFFFFF"
        }
    }
}
