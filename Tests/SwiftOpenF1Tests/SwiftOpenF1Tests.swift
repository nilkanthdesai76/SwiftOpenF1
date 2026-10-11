import Testing
import Foundation
@testable import SwiftOpenF1

@Suite("SwiftOpenF1 Tests")
struct SwiftOpenF1Tests {

    @Test("Driver 2026 Grid Presets")
    func testDriverGrid() {
        #expect(!Driver.grid2026.isEmpty)
        #expect(Driver.hamilton.code == "HAM")
        #expect(Driver.hamilton.teamName == "Ferrari")
        #expect(Driver.verstappen.code == "VER")
        #expect(Driver.antonelli.code == "ANT")
        #expect(Driver.antonelli.teamName == "Mercedes")
    }

    @Test("Tire Compounds and Badges")
    func testTireCompounds() {
        #expect(TireCompound.soft.shortBadge == "S")
        #expect(TireCompound.medium.shortBadge == "M")
        #expect(TireCompound.hard.shortBadge == "H")
        #expect(TireCompound.soft.badgeColorHex == "#E80020")
    }

    @Test("Playback Engine Initial State")
    func testEngineInit() async {
        let engine = F1PlaybackEngine()
        let state = await engine.getCurrentState()

        #expect(state.circuitName == "Marina Bay Street Circuit")
        #expect(state.currentLap == 42)
        #expect(state.totalLaps == 62)
        #expect(state.leader?.driver.code == "HAM")
        #expect(state.standings.count >= 5)
    }

    @Test("Simulation Overtake Trigger")
    func testOvertakeTrigger() async {
        let engine = F1PlaybackEngine()
        // Antonelli is P2, trigger overtake to pass Hamilton into P1
        let newState = await engine.triggerOvertake(overtakingCode: "ANT")

        #expect(newState.standings[0].driver.code == "ANT")
        #expect(newState.standings[0].position == 1)
        #expect(newState.standings[1].driver.code == "HAM")
        #expect(newState.standings[1].position == 2)
    }

    @Test("BOX BOX Pit Alert Trigger")
    func testBoxBoxAlert() async {
        let engine = F1PlaybackEngine()
        let alertState = await engine.triggerBoxBox(driverCode: "HAM", alert: true)
        let hamState = alertState.state(for: 44)

        #expect(hamState?.boxBoxAlert == true)

        let pitState = await engine.triggerBoxBox(driverCode: "HAM", alert: false)
        let hamPitted = pitState.state(for: 44)
        #expect(hamPitted?.boxBoxAlert == false)
        #expect(hamPitted?.pitStopCount == 2)
    }

    @Test("Safety Car Deployment")
    func testSafetyCar() async {
        let engine = F1PlaybackEngine()
        let scState = await engine.triggerFlag(flag: .safetyCar)
        #expect(scState.flagState == .safetyCar)
        #expect(scState.flagState.bannerTitle == "SAFETY CAR DEPLOYED")

        let greenState = await engine.triggerFlag(flag: .green)
        #expect(greenState.flagState == .green)
    }

    @Test("Live Activity Content State Lap Progress")
    func testContentState() {
        let content = F1LiveActivityContentState(
            position: 2,
            currentLap: 43,
            totalLaps: 62,
            gapToLeader: "+1.2s",
            intervalToAhead: "+1.2s",
            tireCompound: "M",
            tireAgeLaps: 15
        )
        #expect(content.lapProgressText == "L43/62")
        #expect(content.position == 2)
    }

    @Test("OpenF1 Client Fallback")
    func testOpenF1Client() async {
        let client = OpenF1Client()
        let drivers = try? await client.fetchDrivers(sessionKey: 9999999)
        #expect(drivers != nil)
        #expect(drivers!.count >= 5)
    }
}
