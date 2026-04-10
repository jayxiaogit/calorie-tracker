import Foundation
import GoogleGenerativeAI

actor GeminiService {
    private var model: GenerativeModel?

    init() {
        setupModel()
    }

    private func setupModel() {
        if let apiKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] ?? Bundle.main.infoDictionary?["API_KEY"] as? String,
           !apiKey.isEmpty {
            let configuration = GenerationConfig(temperature: 0.7, maxOutputTokens: 1024)
            model = GenerativeModel(name: "gemini-2.0-flash", apiKey: apiKey, generationConfig: configuration)
        }
    }

    func analyzeRecipe(_ recipe: String) async throws -> NutritionInfo {
        guard let model = model else {
            return NutritionInfo(calories: 0, protein: 0, fat: 0, carbohydrates: 0)
        }

        let prompt = """
        You are a nutrition expert. Analyze the following recipe and return ONLY a JSON object with the total nutrition facts.
        Format your response as:
        {"calories": number, "protein": number, "fat": number, "carbohydrates": number}
        
        Recipe:
        \(recipe)
        
        Return ONLY the JSON object, no additional text.
        """

        let response = try await model.generateContent(prompt)
        let text = response.text ?? "{}"

        return try parseNutritionResponse(text)
    }

    private func parseNutritionResponse(_ text: String) throws -> NutritionInfo {
        let cleanedText = text
            .replacingOccurrences(of: "```json", with: "")
            .replacingOccurrences(of: "```", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard let data = cleanedText.data(using: .utf8) else {
            return NutritionInfo(calories: 0, protein: 0, fat: 0, carbohydrates: 0)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(NutritionInfo.self, from: data)
    }
}
