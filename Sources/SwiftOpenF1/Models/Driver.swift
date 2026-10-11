import Foundation

public struct Driver: Sendable, Identifiable, Codable, Hashable {
    public let id: Int
    public let driverNumber: Int
    public let code: String
    public let firstName: String
    public let lastName: String
    public let teamName: String
    public let teamColorHex: String
    public let headshotUrl: URL?

    public var fullName: String {
        "\(firstName) \(lastName)"
    }

    public init(
        id: Int,
        driverNumber: Int,
        code: String,
        firstName: String,
        lastName: String,
        teamName: String,
        teamColorHex: String,
        headshotUrl: URL? = nil
    ) {
        self.id = id
        self.driverNumber = driverNumber
        self.code = code
        self.firstName = firstName
        self.lastName = lastName
        self.teamName = teamName
        self.teamColorHex = teamColorHex
        self.headshotUrl = headshotUrl
    }
}

// MARK: - 2026 Official Grid Presets
extension Driver {
    public static let grid2026: [Driver] = [
        Driver(id: 1, driverNumber: 1, code: "VER", firstName: "Max", lastName: "Verstappen", teamName: "Red Bull Racing", teamColorHex: "#3671C6"),
        Driver(id: 4, driverNumber: 4, code: "NOR", firstName: "Lando", lastName: "Norris", teamName: "McLaren", teamColorHex: "#FF8000"),
        Driver(id: 12, driverNumber: 12, code: "ANT", firstName: "Kimi", lastName: "Antonelli", teamName: "Mercedes", teamColorHex: "#27F4D2"),
        Driver(id: 14, driverNumber: 14, code: "ALO", firstName: "Fernando", lastName: "Alonso", teamName: "Aston Martin", teamColorHex: "#229971"),
        Driver(id: 16, driverNumber: 16, code: "LEC", firstName: "Charles", lastName: "Leclerc", teamName: "Ferrari", teamColorHex: "#E80020"),
        Driver(id: 23, driverNumber: 23, code: "ALB", firstName: "Alexander", lastName: "Albon", teamName: "Williams", teamColorHex: "#64C4FF"),
        Driver(id: 27, driverNumber: 27, code: "HUL", firstName: "Nico", lastName: "Hulkenberg", teamName: "Kick Sauber", teamColorHex: "#52E252"),
        Driver(id: 31, driverNumber: 31, code: "OCO", firstName: "Esteban", lastName: "Ocon", teamName: "Haas F1 Team", teamColorHex: "#B6BABD"),
        Driver(id: 44, driverNumber: 44, code: "HAM", firstName: "Lewis", lastName: "Hamilton", teamName: "Ferrari", teamColorHex: "#E80020"),
        Driver(id: 55, driverNumber: 55, code: "SAI", firstName: "Carlos", lastName: "Sainz", teamName: "Williams", teamColorHex: "#64C4FF"),
        Driver(id: 63, driverNumber: 63, code: "RUS", firstName: "George", lastName: "Russell", teamName: "Mercedes", teamColorHex: "#27F4D2"),
        Driver(id: 81, driverNumber: 81, code: "PIA", firstName: "Oscar", lastName: "Piastri", teamName: "McLaren", teamColorHex: "#FF8000"),
        Driver(id: 87, driverNumber: 87, code: "BEA", firstName: "Oliver", lastName: "Bearman", teamName: "Haas F1 Team", teamColorHex: "#B6BABD")
    ]

    public static let hamilton = grid2026.first { $0.code == "HAM" }!
    public static let verstappen = grid2026.first { $0.code == "VER" }!
    public static let leclerc = grid2026.first { $0.code == "LEC" }!
    public static let antonelli = grid2026.first { $0.code == "ANT" }!
    public static let russell = grid2026.first { $0.code == "RUS" }!
}
