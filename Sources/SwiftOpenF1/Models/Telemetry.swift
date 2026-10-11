import Foundation

public struct CarTelemetry: Sendable, Codable, Hashable {
    public let speedKmh: Int
    public let throttlePercent: Int     // 0 - 100
    public let brakePercent: Int        // 0 - 100
    public let gear: Int                // 1 - 8, 0 for Neutral, -1 for Reverse
    public let rpm: Int
    public let drsEnabled: Bool

    public init(
        speedKmh: Int,
        throttlePercent: Int,
        brakePercent: Int,
        gear: Int,
        rpm: Int,
        drsEnabled: Bool
    ) {
        self.speedKmh = speedKmh
        self.throttlePercent = throttlePercent
        self.brakePercent = brakePercent
        self.gear = gear
        self.rpm = rpm
        self.drsEnabled = drsEnabled
    }
}
