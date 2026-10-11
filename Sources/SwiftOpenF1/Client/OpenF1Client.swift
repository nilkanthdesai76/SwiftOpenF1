import Foundation

public actor OpenF1Client {
    private let session: URLSession
    private let baseUrl = URL(string: "https://api.openf1.org/v1")!

    public init(session: URLSession = .shared) {
        self.session = session
    }

    public func fetchLatestSession() async throws -> [String: Any]? {
        let url = baseUrl.appendingPathComponent("sessions")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "year", value: "2024"),
            URLQueryItem(name: "session_name", value: "Qualifying")
        ]
        guard let finalUrl = components?.url else { return nil }

        let (data, response) = try await session.data(from: finalUrl)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            return nil
        }

        let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        return json?.last
    }

    public func fetchDrivers(sessionKey: Int) async throws -> [Driver] {
        let url = baseUrl.appendingPathComponent("drivers")
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "session_key", value: "\(sessionKey)")
        ]
        guard let finalUrl = components?.url else { return Driver.grid2026 }

        do {
            let (data, response) = try await session.data(from: finalUrl)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                return Driver.grid2026
            }
            guard let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
                return Driver.grid2026
            }

            var drivers: [Driver] = []
            for item in json {
                if let num = item["driver_number"] as? Int,
                   let code = item["name_acronym"] as? String,
                   let first = item["first_name"] as? String,
                   let last = item["last_name"] as? String,
                   let team = item["team_name"] as? String,
                   let colorHex = item["team_colour"] as? String {
                    drivers.append(Driver(
                        id: num,
                        driverNumber: num,
                        code: code,
                        firstName: first,
                        lastName: last,
                        teamName: team,
                        teamColorHex: "#\(colorHex)"
                    ))
                }
            }
            return drivers.isEmpty ? Driver.grid2026 : drivers
        } catch {
            return Driver.grid2026
        }
    }
}
