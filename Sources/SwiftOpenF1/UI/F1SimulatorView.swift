import SwiftUI

public struct F1SimulatorView: View {
    @State private var sessionState: GrandPrixSessionState = F1PlaybackEngine.createDefaultSingaporeGPState()
    @State private var selectedDriverCode: String = "HAM"
    @State private var isPlayingAuto: Bool = false
    private let engine = F1PlaybackEngine()

    public init() {}

    private var activeDriverState: DriverRaceState? {
        sessionState.standings.first { $0.driver.code == selectedDriverCode } ?? sessionState.standings.first
    }

    private var liveAttributes: F1LiveActivityAttributes {
        let d = activeDriverState?.driver ?? Driver.hamilton
        return F1LiveActivityAttributes(
            grandPrixName: sessionState.grandPrixName,
            circuitName: sessionState.circuitName,
            driverNumber: d.driverNumber,
            driverCode: d.code,
            driverLastName: d.lastName,
            teamName: d.teamName,
            teamColorHex: d.teamColorHex
        )
    }

    private var liveContentState: F1LiveActivityContentState {
        guard let s = activeDriverState else {
            return F1LiveActivityContentState(position: 1, currentLap: 42, totalLaps: 62, gapToLeader: "LEADER", intervalToAhead: "LEADER")
        }

        let ahead = sessionState.standings.first { $0.position == s.position - 1 }?.driver.code
        let behind = sessionState.standings.first { $0.position == s.position + 1 }?.driver.code

        return F1LiveActivityContentState(
            position: s.position,
            currentLap: sessionState.currentLap,
            totalLaps: sessionState.totalLaps,
            gapToLeader: s.formattedGap,
            intervalToAhead: s.formattedInterval,
            carAheadCode: ahead,
            carBehindCode: behind,
            intervalToBehind: "+1.15s",
            tireCompound: s.currentTireStint.compound.shortBadge,
            tireAgeLaps: s.currentTireStint.lapsDriven,
            flagState: sessionState.flagState.rawValue,
            boxBoxAlert: s.boxBoxAlert,
            speedKmh: s.telemetry.speedKmh,
            drsEnabled: s.telemetry.drsEnabled
        )
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Image(systemName: "flag.checkered.2.crossed")
                            .foregroundColor(.red)
                        Text("SwiftOpenF1 Studio")
                            .font(.system(size: 22, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                    }

                    Text("\(sessionState.grandPrixName) • Lap \(sessionState.currentLap) of \(sessionState.totalLaps)")
                        .font(.system(size: 13, weight: .semibold, design: .monospaced))
                        .foregroundColor(.gray)
                }
                .padding(.top, 16)

                // 1. Dynamic Island Visual Mock (iPhone 16 Pro Style)
                VStack(alignment: .leading, spacing: 12) {
                    Text("1. DYNAMIC ISLAND PREVIEWS")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.gray)

                    // A. Compact Pill
                    VStack(spacing: 8) {
                        Text("Compact Pill (Top of Screen)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)

                        HStack {
                            F1CompactLeadingView(
                                driverNumber: liveAttributes.driverNumber,
                                driverCode: liveAttributes.driverCode,
                                teamColor: Color(hex: liveAttributes.teamColorHex) ?? .red
                            )

                            Spacer()

                            F1CompactTrailingView(
                                position: liveContentState.position,
                                gapText: liveContentState.gapToLeader
                            )
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color.black)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white.opacity(0.2), lineWidth: 1))
                        .frame(maxWidth: 320)
                    }
                    .frame(maxWidth: .infinity)

                    // B. Expanded Dynamic Island
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Expanded Island (Long Press / Live Activity)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.secondary)

                        F1ExpandedIslandView(
                            attributes: liveAttributes,
                            state: liveContentState
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .overlay(
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(Color.white.opacity(0.25), lineWidth: 1.5)
                        )
                    }
                }
                .padding()
                .background(Color(white: 0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // 2. Interactive Simulation Control Pad
                VStack(alignment: .leading, spacing: 14) {
                    Text("2. SIMULATION CONTROLLER")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.gray)

                    // Driver selection
                    HStack {
                        Text("Track Driver:")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)

                        Picker("Driver", selection: $selectedDriverCode) {
                            ForEach(sessionState.standings) { s in
                                Text("\(s.driver.code) - \(s.driver.lastName) (P\(s.position))")
                                    .tag(s.driver.code)
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    // Action Grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        Button {
                            Task {
                                sessionState = await engine.triggerOvertake(overtakingCode: selectedDriverCode)
                            }
                        } label: {
                            Label("Overtake", systemImage: "arrow.up.right.circle.fill")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        Button {
                            Task {
                                let isCurrentlyBox = activeDriverState?.boxBoxAlert ?? false
                                sessionState = await engine.triggerBoxBox(driverCode: selectedDriverCode, alert: !isCurrentlyBox)
                            }
                        } label: {
                            Label("BOX BOX", systemImage: "wrench.and.screwdriver.fill")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        Button {
                            Task {
                                sessionState = await engine.advanceLap()
                            }
                        } label: {
                            Label("Next Lap", systemImage: "forward.fill")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.purple)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        Button {
                            Task {
                                sessionState = await engine.triggerFlag(flag: .safetyCar)
                            }
                        } label: {
                            Label("Safety Car", systemImage: "car.fill")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.orange)
                                .foregroundColor(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        Button {
                            Task {
                                sessionState = await engine.triggerFlag(flag: .virtualSafetyCar)
                            }
                        } label: {
                            Label("VSC", systemImage: "exclamationmark.triangle")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.orange.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        Button {
                            Task {
                                sessionState = await engine.triggerFlag(flag: .green)
                            }
                        } label: {
                            Label("Green Flag", systemImage: "flag.fill")
                                .font(.system(size: 12, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 10)
                                .background(Color.green)
                                .foregroundColor(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding()
                .background(Color(white: 0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))

                // 3. Race Timing Tower
                VStack(alignment: .leading, spacing: 10) {
                    Text("3. LIVE TIMING TOWER")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.gray)

                    ForEach(sessionState.standings) { s in
                        HStack(spacing: 8) {
                            Text("P\(s.position)")
                                .font(.system(size: 12, weight: .black, design: .rounded))
                                .foregroundColor(s.position == 1 ? .yellow : .white)
                                .frame(width: 28, alignment: .leading)

                            Circle()
                                .fill(Color(hex: s.driver.teamColorHex) ?? .gray)
                                .frame(width: 6, height: 6)

                            Text(s.driver.code)
                                .font(.system(size: 13, weight: .heavy))
                                .foregroundColor(s.driver.code == selectedDriverCode ? .yellow : .white)

                            Text(s.driver.lastName)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)

                            Spacer()

                            Text(s.currentTireStint.compound.shortBadge)
                                .font(.system(size: 10, weight: .black))
                                .foregroundColor(.black)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 1)
                                .background(Color(hex: s.currentTireStint.compound.badgeColorHex) ?? .white)
                                .clipShape(Circle())

                            Text(s.formattedGap)
                                .font(.system(size: 12, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .frame(width: 70, alignment: .trailing)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(s.driver.code == selectedDriverCode ? Color.white.opacity(0.08) : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                }
                .padding()
                .background(Color(white: 0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding()
        }
        .background(Color(white: 0.03))
    }
}
