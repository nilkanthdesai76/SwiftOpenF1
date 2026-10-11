# 🏎️ SwiftOpenF1 — Swift 6 Formula 1 SPM & ActivityKit Dynamic Island

A modern, high-performance Swift 6 package and ActivityKit engine for Formula 1 live timing, telemetry analysis, and Dynamic Island widgets. Powered by [OpenF1](https://openf1.org) and [Ergast/Jolpi](https://api.jolpi.ca).

---

## 🌟 Highlights

- **Swift 6 Strict Concurrency**: All models conform to `Sendable`, `Identifiable`, `Codable`, and `Hashable`.
- **ActivityKit & Dynamic Island**:
  - **Compact Leading**: Driver number badge (`44`) + driver code (`HAM`).
  - **Compact Trailing**: Live track position (`P1`) and gap to leader (`+1.42s`).
  - **Expanded Island**: 3-car battle interval bar, tire compound indicator (`Soft`, `Medium`, `Hard`) with lap age, telemetry speedometer, and pulsing `BOX BOX` alerts.
  - **Lock Screen Live Activity**: Full-width broadcast widget with Safety Car (`SC`), Virtual Safety Car (`VSC`), and Red Flag banners.
- **Offline Playback & Simulation Engine (`F1PlaybackEngine`)**:
  - Full actor-based race playback engine that runs offline without waiting for Grand Prix weekends.
  - Interactive simulation triggers: overtakes, pit stops, tire changes, safety cars, and lap advances.
- **Official 2026 Grid Presets**: Hamilton (Ferrari), Leclerc (Ferrari), Antonelli (Mercedes), Russell (Mercedes), Verstappen (Red Bull), Norris (McLaren), Piastri (McLaren), Alonso (Aston Martin).

---

## 📦 Installation (Swift Package Manager)

Add `SwiftOpenF1` to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/nilkanthdesai76/SwiftOpenF1.git", from: "1.0.0")
]
```

Or add it directly via Xcode:
`File` $\to$ `Add Package Dependencies...` $\to$ Paste repository URL.

---

## 🚀 Quick Usage

### 1. ActivityKit Dynamic Island

```swift
import SwiftUI
import ActivityKit
import SwiftOpenF1

struct F1Widget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: F1LiveActivityAttributes.self) { context in
            // Lock Screen Banner
            F1LockScreenWidgetView(attributes: context.attributes, state: context.state)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded Island
                DynamicIslandExpandedRegion(.bottom) {
                    F1ExpandedIslandView(attributes: context.attributes, state: context.state)
                }
            } compactLeading: {
                F1CompactLeadingView(
                    driverNumber: context.attributes.driverNumber,
                    driverCode: context.attributes.driverCode,
                    teamColor: Color(hex: context.attributes.teamColorHex) ?? .red
                )
            } compactTrailing: {
                F1CompactTrailingView(
                    position: context.state.position,
                    gapText: context.state.gapToLeader
                )
            } minimal: {
                F1MinimalView(
                    driverCode: context.attributes.driverCode,
                    teamColor: Color(hex: context.attributes.teamColorHex) ?? .red
                )
            }
        }
    }
}
```

### 2. Live Simulation & Race Control

```swift
import SwiftOpenF1

let engine = F1PlaybackEngine()
let currentState = await engine.getCurrentState()

// Trigger Lewis Hamilton overtaking into P1
let overtakeState = await engine.triggerOvertake(overtakingCode: "HAM")

// Trigger a BOX BOX pit stop alert
let boxState = await engine.triggerBoxBox(driverCode: "HAM", alert: true)

// Deploy Safety Car
let scState = await engine.triggerFlag(flag: .safetyCar)
```

---

## 🧪 Testing

```bash
swift test
```

All 8 tests pass with Swift 6 strict concurrency checks enabled.
