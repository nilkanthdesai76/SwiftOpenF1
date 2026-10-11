import Foundation

#if os(iOS)
import ActivityKit
#endif

public struct F1LiveActivityAttributes: Sendable, Codable, Hashable {
    #if os(iOS)
    public typealias ContentState = F1LiveActivityContentState
    #endif

    public let grandPrixName: String
    public let circuitName: String
    public let driverNumber: Int
    public let driverCode: String
    public let driverLastName: String
    public let teamName: String
    public let teamColorHex: String

    public init(
        grandPrixName: String,
        circuitName: String,
        driverNumber: Int,
        driverCode: String,
        driverLastName: String,
        teamName: String,
        teamColorHex: String
    ) {
        self.grandPrixName = grandPrixName
        self.circuitName = circuitName
        self.driverNumber = driverNumber
        self.driverCode = driverCode
        self.driverLastName = driverLastName
        self.teamName = teamName
        self.teamColorHex = teamColorHex
    }
}

#if os(iOS)
extension F1LiveActivityAttributes: ActivityAttributes {}
#endif

public struct F1LiveActivityContentState: Sendable, Codable, Hashable {
    public let position: Int
    public let currentLap: Int
    public let totalLaps: Int
    public let gapToLeader: String
    public let intervalToAhead: String
    public let carAheadCode: String?
    public let carBehindCode: String?
    public let intervalToBehind: String?
    public let tireCompound: String
    public let tireAgeLaps: Int
    public let flagState: String
    public let boxBoxAlert: Bool
    public let speedKmh: Int
    public let drsEnabled: Bool

    public var lapProgressText: String {
        "L\(currentLap)/\(totalLaps)"
    }

    public init(
        position: Int,
        currentLap: Int,
        totalLaps: Int,
        gapToLeader: String,
        intervalToAhead: String,
        carAheadCode: String? = nil,
        carBehindCode: String? = nil,
        intervalToBehind: String? = nil,
        tireCompound: String = "M",
        tireAgeLaps: Int = 14,
        flagState: String = "GREEN",
        boxBoxAlert: Bool = false,
        speedKmh: Int = 285,
        drsEnabled: Bool = false
    ) {
        self.position = position
        self.currentLap = currentLap
        self.totalLaps = totalLaps
        self.gapToLeader = gapToLeader
        self.intervalToAhead = intervalToAhead
        self.carAheadCode = carAheadCode
        self.carBehindCode = carBehindCode
        self.intervalToBehind = intervalToBehind
        self.tireCompound = tireCompound
        self.tireAgeLaps = tireAgeLaps
        self.flagState = flagState
        self.boxBoxAlert = boxBoxAlert
        self.speedKmh = speedKmh
        self.drsEnabled = drsEnabled
    }
}
