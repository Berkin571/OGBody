/*
import Foundation

final class OpenAIService {
    static let shared = OpenAIService()
    private init() {}

    private var apiKey: String {
        Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? ""
    }
    
    let key = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String
    func print("🔑 Loaded API Key:", key ?? "(nil)")


    func generatePlan(for profile: UserProfile) async throws -> String {
        // 1) Erstelle Session mit waitsForConnectivity
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30  // 30 s Timeout
        config.timeoutIntervalForResource = 60 // 60 s Gesamt
        let session = URLSession(configuration: config)

        // 2) Baue Request
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        Erstelle basierend auf:
        Gewicht: \(profile.weight)kg,
        Größe: \(profile.height)cm,
        Alter: \(profile.age),
        Geschlecht: \(profile.gender.rawValue),
        Aktivitätslevel: \(profile.activityLevel.rawValue),
        Ziel: \(profile.goal.rawValue)
        einen Wochen-Trainings- und Ernährungsplan.
        """

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role":"system", "content":"Du bist ein Fitness-Coach."],
                ["role":"user",   "content":prompt]
            ],
            "max_tokens": 800,
            "temperature": 0.7
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        // 3) Sende Request mit Retry
        let maxAttempts = 2
        var lastError: Error!
        for attempt in 1...maxAttempts {
            do {
                let (data, response) = try await session.data(for: request)

                // HTTP-Status prüfen
                if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                    let msg = String(data: data, encoding: .utf8) ?? "– kein Body –"
                    throw NSError(domain: "", code: http.statusCode,
                                  userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode): \(msg)"])
                }

                // Debug-Log
                if let dump = String(data: data, encoding: .utf8) {
                    print("🔵 OpenAI response:\n\(dump)")
                }

                // JSON parsen
                struct ChatResponse: Decodable {
                    struct Choice: Decodable {
                        struct Message: Decodable { let content: String }
                        let message: Message
                    }
                    let choices: [Choice]
                }
                let chat = try JSONDecoder().decode(ChatResponse.self, from: data)
                return chat.choices.first?.message.content
                      .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

            } catch {
                lastError = error
                print("Attempt \(attempt) fehlgeschlagen: \(error.localizedDescription)")
                // Wenn’s die letzte Runde ist, wirf den Fehler weiter
                if attempt == maxAttempts {
                    throw error
                }
                // Sonst kurz warten und erneut versuchen
                try await Task.sleep(nanoseconds: 500 * 1_000_000) // 0.5 s
            }
        }
        // Soll nie erreicht werden
        throw lastError
    }
}


*/
import Foundation

final class OpenAIService {
    static let shared = OpenAIService()
    
    // Wird nur einmal beim ersten Zugriff auf `shared` aufgerufen
    private init() {
        let loadedKey = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? "(nil)"
        print("🔑 Loaded API Key: \(loadedKey)")
    }

    private var apiKey: String {
        // Hier holst Du den Key erneut, um ihn für Requests zu verwenden
        Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String ?? ""
    }

    func generatePlan(for profile: UserProfile) async throws -> String {
        // Hier kannst Du bei Bedarf auch noch einmal loggen:
        print("🔑 Using API Key: \(apiKey)")

        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        let session = URLSession(configuration: config)

       

        let url = URL(string: "https://api.openai.com/v1/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let prompt = """
        Erstelle basierend auf:
        Gewicht: \(profile.weight)kg,
        Größe: \(profile.height)cm,
        Alter: \(profile.age),
        Geschlecht: \(profile.gender.rawValue),
        Aktivitätslevel: \(profile.activityLevel.rawValue),
        Ziel: \(profile.goal.rawValue)
        einen Wochen-Trainings- und Ernährungsplan.
        """

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role":"system", "content":"Du bist ein Fitness-Coach."],
                ["role":"user",   "content":prompt]
            ],
            "max_tokens": 800,
            "temperature": 0.7
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        let maxAttempts = 2
        var lastError: Error!
        for attempt in 1...maxAttempts {
            do {
                let (data, response) = try await session.data(for: request)

                if let http = response as? HTTPURLResponse,
                   http.statusCode != 200 {
                    let msg = String(data: data, encoding: .utf8) ?? "– kein Body –"
                    throw NSError(
                      domain: "",
                      code: http.statusCode,
                      userInfo: [NSLocalizedDescriptionKey: "HTTP \(http.statusCode): \(msg)"]
                    )
                }

                if let dump = String(data: data, encoding: .utf8) {
                    print("🔵 OpenAI response:\n\(dump)")
                }

                struct ChatResponse: Decodable {
                    struct Choice: Decodable {
                        struct Message: Decodable { let content: String }
                        let message: Message
                    }
                    let choices: [Choice]
                }
                let chat = try JSONDecoder().decode(ChatResponse.self, from: data)
                return chat.choices
                    .first?
                    .message
                    .content
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    ?? ""

            } catch {
                lastError = error
                print("Attempt \(attempt) fehlgeschlagen: \(error.localizedDescription)")
                if attempt == maxAttempts { throw error }
                try await Task.sleep(nanoseconds: 500 * 1_000_000)
            }
        }
        throw lastError
    }
}

