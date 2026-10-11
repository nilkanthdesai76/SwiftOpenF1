import Foundation

public struct DriverRaceState: Sendable, Codable, Hashable, Identifiable {
    public var id: Int { driver.id }
    public let position: Int
    public let driver: Driver
    public let gapToLeaderSeconds: Double?
    public let intervalToAheadSeconds: Double?
    public let currentTireStint: TireStint
    public let telemetry: CarTelemetry
    public let lastLap: Lap?
    public let bestLap: Lap?
    public let pitStopCount: Int
    public let isInPitLane: Bool
    public let boxBoxAlert: Bool

    public var formattedGap: String {
        if position == 1 {
            return "LEADER"
        }
        guard let gap = gapToLeaderSeconds else { return "+0.0s" }
        return String(format: "+%.2fs", gap)
    }

    public var formattedInterval: String {
        if position == 1 {
            return "INTERVAL"
        }
        guard let interval = intervalToAheadSeconds else { return "+0.0s" }
        return String(format: "+%.2fs", interval)
    }

    public init(
        position: Int,
        driver: Driver,
        gapToLeaderSeconds: Double?,
        intervalToAheadSeconds: Double?,
        currentTireStint: TireStint,
        telemetry: CarTelemetry,
        lastLap: Lap? = nil,
        bestLap: Lap? = nil,
        pitStopCount: Int = 1,
        isInPitLane: Bool = false,
        boxBoxAlert: Bool = false
    ) {
        self.position = position
        self.driver = driver
        self.gapToLeaderSeconds = gapToLeaderSeconds
        self.intervalToAheadSeconds = intervalToAheadSeconds
        self.currentTireStint = currentTireStint
        self.telemetry = telemetry
        self.lastLap = lastLap
        self.bestLap = bestLap
        self.pitStopCount = pitStopCount
        self.isInPitLane = isInPitLane
        self.boxBoxAlert = boxBoxAlert
    }
}

public struct GrandPrixSessionState: Sendable, Codable, Hashable {
    public let circuitName: String
    public let grandPrixName: String
    public let currentLap: Int
    public let totalLaps: Int
    public let flagState: FlagState
    public let standings: [DriverRaceState]

    public var leader: DriverRaceState? {
        standings.first { $0.position == 1 }
    }

    public func state(for driverNumber: Int) -> DriverRaceState? {
        standings.first { $0.driver.driverNumber == driverNumber }
    }

    public init(
        circuitName: String,
        grandPrixName: String,
        currentLap: Int,
        totalLaps: Int,
        flagState: FlagState,
        standings: [DriverRaceState]
    ) {
        self.circuitName = circuitName
        self.grandPrixName = grandPrixName
        self.currentLap = currentLap
        self.totalLaps = totalLaps
        self.flagState = flagState
        self.standings = standings
    }
}
