import Foundation

public actor F1PlaybackEngine {
    private var currentState: GrandPrixSessionState
    private var isPlaying: Bool = false
    private var playbackSpeedMultiplier: Double = 1.0

    public init(initialState: GrandPrixSessionState? = nil) {
        if let initial = initialState {
            self.currentState = initial
        } else {
            self.currentState = F1PlaybackEngine.createDefaultSingaporeGPState()
        }
    }

    public func getCurrentState() -> GrandPrixSessionState {
        return currentState
    }

    // MARK: - Interactive Simulation Triggers

    public func triggerOvertake(overtakingCode: String) -> GrandPrixSessionState {
        guard let currentIndex = currentState.standings.firstIndex(where: { $0.driver.code == overtakingCode }),
              currentIndex > 0 else {
            return currentState
        }

        var newStandings = currentState.standings
        let overtakingDriver = newStandings.remove(at: currentIndex)
        newStandings.insert(overtakingDriver, at: currentIndex - 1)

        // Re-index positions and recalculate gaps
        let updated = reindexStandings(newStandings)
        currentState = GrandPrixSessionState(
            circuitName: currentState.circuitName,
            grandPrixName: currentState.grandPrixName,
            currentLap: currentState.currentLap,
            totalLaps: currentState.totalLaps,
            flagState: currentState.flagState,
            standings: updated
        )
        return currentState
    }

    public func triggerBoxBox(driverCode: String, alert: Bool = true) -> GrandPrixSessionState {
        var updated = currentState.standings
        if let idx = updated.firstIndex(where: { $0.driver.code == driverCode }) {
            let current = updated[idx]
            let newStint = alert ? current.currentTireStint : TireStint(compound: .soft, lapsDriven: 1, pitStopDurationSeconds: 2.3)
            let newCount = alert ? current.pitStopCount : current.pitStopCount + 1

            updated[idx] = DriverRaceState(
                position: current.position,
                driver: current.driver,
                gapToLeaderSeconds: current.gapToLeaderSeconds,
                intervalToAheadSeconds: current.intervalToAheadSeconds,
                currentTireStint: newStint,
                telemetry: current.telemetry,
                lastLap: current.lastLap,
                bestLap: current.bestLap,
                pitStopCount: newCount,
                isInPitLane: !alert,
                boxBoxAlert: alert
            )
        }

        currentState = GrandPrixSessionState(
            circuitName: currentState.circuitName,
            grandPrixName: currentState.grandPrixName,
            currentLap: currentState.currentLap,
            totalLaps: currentState.totalLaps,
            flagState: currentState.flagState,
            standings: updated
        )
        return currentState
    }

    public func triggerFlag(flag: FlagState) -> GrandPrixSessionState {
        currentState = GrandPrixSessionState(
            circuitName: currentState.circuitName,
            grandPrixName: currentState.grandPrixName,
            currentLap: currentState.currentLap,
            totalLaps: currentState.totalLaps,
            flagState: flag,
            standings: currentState.standings
        )
        return currentState
    }

    public func advanceLap() -> GrandPrixSessionState {
        let nextLap = min(currentState.totalLaps, currentState.currentLap + 1)
        var updated = currentState.standings

        for i in 0..<updated.count {
            let s = updated[i]
            var stint = s.currentTireStint
            stint.lapsDriven += 1

            // Micro-variations in speed and telemetry
            let speed = Int.random(in: 270...325)
            let throttle = Int.random(in: 85...100)
            let brake = Int.random(in: 0...15)
            let gear = Int.random(in: 6...8)
            let rpm = Int.random(in: 11000...12500)
            let drs = i > 0 && (s.intervalToAheadSeconds ?? 2.0) < 1.0

            let telem = CarTelemetry(
                speedKmh: speed,
                throttlePercent: throttle,
                brakePercent: brake,
                gear: gear,
                rpm: rpm,
                drsEnabled: drs
            )

            updated[i] = DriverRaceState(
                position: s.position,
                driver: s.driver,
                gapToLeaderSeconds: s.gapToLeaderSeconds,
                intervalToAheadSeconds: s.intervalToAheadSeconds,
                currentTireStint: stint,
                telemetry: telem,
                lastLap: s.lastLap,
                bestLap: s.bestLap,
                pitStopCount: s.pitStopCount,
                isInPitLane: false,
                boxBoxAlert: false
            )
        }

        currentState = GrandPrixSessionState(
            circuitName: currentState.circuitName,
            grandPrixName: currentState.grandPrixName,
            currentLap: nextLap,
            totalLaps: currentState.totalLaps,
            flagState: nextLap == currentState.totalLaps ? .chequered : currentState.flagState,
            standings: updated
        )
        return currentState
    }

    // MARK: - Helper

    private func reindexStandings(_ drivers: [DriverRaceState]) -> [DriverRaceState] {
        var reindexed: [DriverRaceState] = []
        var cumulativeGap: Double = 0.0

        for (idx, driver) in drivers.enumerated() {
            let pos = idx + 1
            let interval = pos == 1 ? 0.0 : Double.random(in: 0.4...1.8)
            cumulativeGap += interval

            reindexed.append(DriverRaceState(
                position: pos,
                driver: driver.driver,
                gapToLeaderSeconds: pos == 1 ? nil : cumulativeGap,
                intervalToAheadSeconds: pos == 1 ? nil : interval,
                currentTireStint: driver.currentTireStint,
                telemetry: driver.telemetry,
                lastLap: driver.lastLap,
                bestLap: driver.bestLap,
                pitStopCount: driver.pitStopCount,
                isInPitLane: driver.isInPitLane,
                boxBoxAlert: driver.boxBoxAlert
            ))
        }
        return reindexed
    }

    public static func createDefaultSingaporeGPState() -> GrandPrixSessionState {
        let standings: [DriverRaceState] = [
            DriverRaceState(
                position: 1,
                driver: Driver.hamilton,
                gapToLeaderSeconds: nil,
                intervalToAheadSeconds: nil,
                currentTireStint: TireStint(compound: .hard, lapsDriven: 22),
                telemetry: CarTelemetry(speedKmh: 298, throttlePercent: 100, brakePercent: 0, gear: 7, rpm: 11950, drsEnabled: false),
                lastLap: Lap(lapNumber: 41, lapDurationSeconds: 93.854),
                bestLap: Lap(lapNumber: 38, lapDurationSeconds: 92.981, isPersonalFastest: true, isSessionFastest: true),
                pitStopCount: 1
            ),
            DriverRaceState(
                position: 2,
                driver: Driver.antonelli,
                gapToLeaderSeconds: 1.42,
                intervalToAheadSeconds: 1.42,
                currentTireStint: TireStint(compound: .medium, lapsDriven: 14),
                telemetry: CarTelemetry(speedKmh: 308, throttlePercent: 100, brakePercent: 0, gear: 8, rpm: 12200, drsEnabled: true),
                lastLap: Lap(lapNumber: 41, lapDurationSeconds: 93.512),
                bestLap: Lap(lapNumber: 39, lapDurationSeconds: 93.104, isPersonalFastest: true),
                pitStopCount: 1
            ),
            DriverRaceState(
                position: 3,
                driver: Driver.verstappen,
                gapToLeaderSeconds: 2.85,
                intervalToAheadSeconds: 1.43,
                currentTireStint: TireStint(compound: .hard, lapsDriven: 26),
                telemetry: CarTelemetry(speedKmh: 292, throttlePercent: 95, brakePercent: 0, gear: 7, rpm: 11800, drsEnabled: false),
                lastLap: Lap(lapNumber: 41, lapDurationSeconds: 94.120),
                bestLap: Lap(lapNumber: 34, lapDurationSeconds: 93.250),
                pitStopCount: 1
            ),
            DriverRaceState(
                position: 4,
                driver: Driver.leclerc,
                gapToLeaderSeconds: 4.10,
                intervalToAheadSeconds: 1.25,
                currentTireStint: TireStint(compound: .medium, lapsDriven: 12),
                telemetry: CarTelemetry(speedKmh: 305, throttlePercent: 100, brakePercent: 0, gear: 8, rpm: 12150, drsEnabled: true),
                pitStopCount: 1
            ),
            DriverRaceState(
                position: 5,
                driver: Driver.russell,
                gapToLeaderSeconds: 6.80,
                intervalToAheadSeconds: 2.70,
                currentTireStint: TireStint(compound: .hard, lapsDriven: 24),
                telemetry: CarTelemetry(speedKmh: 288, throttlePercent: 90, brakePercent: 0, gear: 7, rpm: 11600, drsEnabled: false),
                pitStopCount: 1
            )
        ]

        return GrandPrixSessionState(
            circuitName: "Marina Bay Street Circuit",
            grandPrixName: "Singapore Grand Prix",
            currentLap: 42,
            totalLaps: 62,
            flagState: .green,
            standings: standings
        )
    }
}
