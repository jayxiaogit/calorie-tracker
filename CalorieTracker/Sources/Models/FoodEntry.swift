import Foundation
import SwiftData

@Model
final class FoodEntry {
    var id: UUID
    var name: String
    var calories: Int
    var protein: Double
    var fat: Double
    var carbohydrates: Double
    var mealType: String
    var date: Date
    var recipeText: String?

    init(
        id: UUID = UUID(),
        name: String,
        calories: Int,
        protein: Double,
        fat: Double,
        carbohydrates: Double,
        mealType: String,
        date: Date = Date(),
        recipeText: String? = nil
    ) {
        self.id = id
        self.name = name
        self.calories = calories
        self.protein = protein
        self.fat = fat
        self.carbohydrates = carbohydrates
        self.mealType = mealType
        self.date = date
        self.recipeText = recipeText
    }
}

struct NutritionInfo: Codable {
    let calories: Int
    let protein: Double
    let fat: Double
    let carbohydrates: Double
}

enum MealType: String, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}

extension FoodEntry {
    static var sampleEntries: [FoodEntry] {
        [
            FoodEntry(name: "Grilled Chicken Salad", calories: 350, protein: 30, fat: 12, carbohydrates: 15, mealType: "Lunch"),
            FoodEntry(name: "Oatmeal with Berries", calories: 280, protein: 8, fat: 6, carbohydrates: 50, mealType: "Breakfast"),
            FoodEntry(name: "Salmon with Vegetables", calories: 450, protein: 40, fat: 20, carbohydrates: 25, mealType: "Dinner")
        ]
    }
}
