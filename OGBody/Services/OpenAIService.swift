import Foundation

/// Service für OpenAI-API-Aufrufe
public final class OpenAIService {
    public static let shared = OpenAIService()

    private let apiKey: String

    private init() {
        // API-Key aus Info.plist laden
        if let key = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String,
           !key.isEmpty {
            self.apiKey = key
        } else {
            fatalError("❌ OPENAI_API_KEY fehlt in der Info.plist!")
        }
        print("🔑 Loaded API Key: \(apiKey)")
    }

    /// Generiert einen Wochen-Trainings- und Ernährungsplan per Chat-Endpoint
    /// - Parameter profile: Die Nutzerdaten
    /// - Returns: Den generierten Plan als String
    func generatePlan(for profile: UserProfile) async throws -> String {
        // 1) Prompt zusammenbauen
        let prompt = """
        Erstelle einen realistischen, anfänger-gerechten Wochen-Trainings- und Ernährungsplan basierend auf:
        • Gewicht: \(profile.weight) kg
        • Größe: \(profile.height) cm
        • Alter: \(profile.age)
        • Geschlecht: \(profile.gender.rawValue)
        • Aktivitätslevel: \(profile.activityLevel.rawValue)
        • Ziel: \(profile.goal.rawValue)
        """

        // 2) URLRequest konfigurieren
        let url = URL(string: "https://api.openai.com/v1/chat/completions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json",      forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "Du bist ein Fitness-Coach."],
                ["role": "user",   "content": prompt]
            ],
            "max_tokens": 800,
            "temperature": 0.7
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: body)

        // 3) Einfacher URLSession-Aufruf
        let (data, response) = try await URLSession.shared.data(for: request)

        // 4) HTTP-Status prüfen
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            let msg = String(data: data, encoding: .utf8) ?? "– kein Body –"
            throw NSError(
                domain: "OpenAIService",
                code: (response as? HTTPURLResponse)?.statusCode ?? -1,
                userInfo: [NSLocalizedDescriptionKey: "HTTP \( (response as? HTTPURLResponse)?.statusCode ?? -1 ): \(msg)"]
            )
        }
        
        if let raw = String(data: data, encoding: .utf8) {
                   print("🔵 Raw OpenAI Response JSON:\n\(raw)")
               } else {
                   print("⚠️ OpenAI Response konnte nicht als String decodiert werden.")
               }


        // 5) JSON-Response parsen
        struct ChatResponse: Decodable {
            struct Choice: Decodable {
                struct Message: Decodable { let content: String }
                let message: Message
            }
            let choices: [Choice]
        }
        let chat = try JSONDecoder().decode(ChatResponse.self, from: data)

        // 6) Plan-Text ausgeben
        return chat.choices
            .first?
            .message
            .content
            .trimmingCharacters(in: .whitespacesAndNewlines)
            ?? "❌ Keine Antwort erhalten."
    }
}
