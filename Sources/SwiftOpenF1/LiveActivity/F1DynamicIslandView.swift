import SwiftUI

// MARK: - Compact Leading (Left of Camera Notch/Pill)
public struct F1CompactLeadingView: View {
    public let driverNumber: Int
    public let driverCode: String
    public let teamColor: Color

    public init(driverNumber: Int, driverCode: String, teamColor: Color) {
        self.driverNumber = driverNumber
        self.driverCode = driverCode
        self.teamColor = teamColor
    }

    public var body: some View {
        HStack(spacing: 4) {
            Text("\(driverNumber)")
                .font(.system(size: 11, weight: .black, design: .monospaced))
                .foregroundColor(.black)
                .padding(.horizontal, 4)
                .padding(.vertical, 1)
                .background(teamColor)
                .clipShape(RoundedRectangle(cornerRadius: 3))

            Text(driverCode)
                .font(.system(size: 12, weight: .heavy, design: .rounded))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Compact Trailing (Right of Camera Notch/Pill)
public struct F1CompactTrailingView: View {
    public let position: Int
    public let gapText: String

    public init(position: Int, gapText: String) {
        self.position = position
        self.gapText = gapText
    }

    public var body: some View {
        HStack(spacing: 3) {
            Text("P\(position)")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(position == 1 ? Color.yellow : Color.gray)

            Text(gapText)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Minimal View (When another app also has an activity)
public struct F1MinimalView: View {
    public let driverCode: String
    public let teamColor: Color

    public init(driverCode: String, teamColor: Color) {
        self.driverCode = driverCode
        self.teamColor = teamColor
    }

    public var body: some View {
        HStack(spacing: 2) {
            Circle()
                .fill(teamColor)
                .frame(width: 5, height: 5)
            Text(driverCode)
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.white)
        }
    }
}

// MARK: - Expanded Island View
public struct F1ExpandedIslandView: View {
    public let attributes: F1LiveActivityAttributes
    public let state: F1LiveActivityContentState

    public init(attributes: F1LiveActivityAttributes, state: F1LiveActivityContentState) {
        self.attributes = attributes
        self.state = state
    }

    private var teamColor: Color {
        Color(hex: attributes.teamColorHex) ?? .red
    }

    private var tireColor: Color {
        switch state.tireCompound {
        case "S": return Color(hex: "#E80020")!
        case "M": return Color(hex: "#FFF500")!
        case "H": return .white
        case "I": return Color(hex: "#39B54A")!
        default: return .white
        }
    }

    public var body: some View {
        VStack(spacing: 10) {
            // Header Row: Driver & Position
            HStack {
                HStack(spacing: 6) {
                    Text("\(attributes.driverNumber)")
                        .font(.system(size: 12, weight: .black, design: .monospaced))
                        .foregroundColor(.black)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(teamColor)
                        .clipShape(RoundedRectangle(cornerRadius: 4))

                    VStack(alignment: .leading, spacing: 1) {
                        Text(attributes.driverLastName.uppercased())
                            .font(.system(size: 14, weight: .heavy, design: .rounded))
                            .foregroundColor(.white)
                        Text(attributes.teamName)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                // Tire badge & Lap progress
                HStack(spacing: 6) {
                    HStack(spacing: 3) {
                        Text(state.tireCompound)
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.black)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(tireColor)
                            .clipShape(Circle())
                        Text("\(state.tireAgeLaps)L")
                            .font(.system(size: 10, weight: .bold, design: .monospaced))
                            .foregroundColor(.gray)
                    }

                    Text("P\(state.position)")
                        .font(.system(size: 16, weight: .black, design: .rounded))
                        .foregroundColor(state.position == 1 ? .yellow : .white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.12))
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }

            // Interval Battle Bar (Car ahead vs Current vs Car behind)
            HStack(spacing: 8) {
                if let ahead = state.carAheadCode {
                    VStack(spacing: 2) {
                        Text(ahead)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.gray)
                        Text(state.intervalToAhead)
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(.green)
                    }
                }

                VStack(spacing: 2) {
                    Rectangle()
                        .fill(teamColor)
                        .frame(height: 3)
                        .clipShape(Capsule())
                    Text(state.gapToLeader)
                        .font(.system(size: 11, weight: .black, design: .monospaced))
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)

                if let behind = state.carBehindCode {
                    VStack(spacing: 2) {
                        Text(behind)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.gray)
                        Text(state.intervalToBehind ?? "+1.0s")
                            .font(.system(size: 10, weight: .medium, design: .monospaced))
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 8))

            // Bottom telemetry & alert strip
            HStack {
                HStack(spacing: 12) {
                    Text("\(state.speedKmh) KM/H")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)

                    if state.drsEnabled {
                        Text("DRS")
                            .font(.system(size: 10, weight: .black))
                            .foregroundColor(.black)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.green)
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                    }

                    Text(state.lapProgressText)
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundColor(.gray)
                }

                Spacer()

                if state.boxBoxAlert {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("BOX BOX")
                    }
                    .font(.system(size: 11, weight: .black))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                } else if state.flagState != "GREEN" {
                    Text(state.flagState)
                        .font(.system(size: 10, weight: .black))
                        .foregroundColor(.black)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
        }
        .padding(14)
        .background(Color.black)
    }
}

// MARK: - Lock Screen Widget View
public struct F1LockScreenWidgetView: View {
    public let attributes: F1LiveActivityAttributes
    public let state: F1LiveActivityContentState

    public init(attributes: F1LiveActivityAttributes, state: F1LiveActivityContentState) {
        self.attributes = attributes
        self.state = state
    }

    public var body: some View {
        F1ExpandedIslandView(attributes: attributes, state: state)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
            )
    }
}

// MARK: - Color Hex Helper
extension Color {
    public init?(hex: String) {
        var cleanHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cleanHex.hasPrefix("#") { cleanHex.removeFirst() }
        guard cleanHex.count == 6, let rgb = UInt64(cleanHex, radix: 16) else { return nil }
        self.init(
            .sRGB,
            red: Double((rgb >> 16) & 0xFF) / 255.0,
            green: Double((rgb >> 8) & 0xFF) / 255.0,
            blue: Double(rgb & 0xFF) / 255.0,
            opacity: 1.0
        )
    }
}
