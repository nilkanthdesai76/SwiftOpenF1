import Foundation

public struct Lap: Sendable, Codable, Hashable, Identifiable {
    public var id: Int { lapNumber }
    public let lapNumber: Int
    public let lapDurationSeconds: Double?
    public let sector1Seconds: Double?
    public let sector2Seconds: Double?
    public let sector3Seconds: Double?
    public let isPersonalFastest: Bool
    public let isSessionFastest: Bool

    public var formattedDuration: String {
        guard let d = lapDurationSeconds else { return "--:--.---" }
        let minutes = Int(d) / 60
        let seconds = Int(d) % 60
        let millis = Int((d.truncatingRemainder(dividingBy: 1.0)) * 1000)
        return String(format: "%d:%02d.%03d", minutes, seconds, millis)
    }

    public init(
        lapNumber: Int,
        lapDurationSeconds: Double?,
        sector1Seconds: Double? = nil,
        sector2Seconds: Double? = nil,
        sector3Seconds: Double? = nil,
        isPersonalFastest: Bool = false,
        isSessionFastest: Bool = false
    ) {
        self.lapNumber = lapNumber
        self.lapDurationSeconds = lapDurationSeconds
        self.sector1Seconds = sector1Seconds
        self.sector2Seconds = sector2Seconds
        self.sector3Seconds = sector3Seconds
        self.isPersonalFastest = isPersonalFastest
        self.isSessionFastest = isSessionFastest
    }
}
