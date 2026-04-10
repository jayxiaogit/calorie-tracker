import SwiftUI
import SwiftData

struct AddFoodView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var foodName: String = ""
    @State private var calories: String = ""
    @State private var protein: String = ""
    @State private var fat: String = ""
    @State private var carbohydrates: String = ""
    @State private var selectedMealType: MealType = .breakfast
    @State private var recipeText: String = ""
    @State private var useAIAnalysis: Bool = false
    @State private var isAnalyzing: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var geminiService = GeminiService()
    
    var body: some View {
        NavigationStack {
            Form {
                inputSection
                nutritionSection
                mealTypeSection
                aiSection
            }
            .navigationTitle("Add Food")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveFood()
                    }
                    .fontWeight(.semibold)
                    .disabled(!isFormValid)
                }
            }
            .alert("Notice", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
        }
    }

    private var inputSection: some View {
        Section("Food Details") {
            TextField("Food Name", text: $foodName)
                .textContentType(.foodName)
            
            Toggle("Analyze with AI", isOn: $useAIAnalysis)
            
            if useAIAnalysis {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Recipe")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    
                    TextEditor(text: $recipeText)
                        .frame(minHeight: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                    
                    Button {
                        analyzeRecipe()
                    } label: {
                        HStack {
                            if isAnalyzing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                            } else {
                                Image(systemName: "wand.and.stars")
                            }
                            Text(isAnalyzing ? "Analyzing..." : "Analyze Recipe")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .tint(.orange)
                    .disabled(recipeText.isEmpty || isAnalyzing)
                }
            }
        }
    }

    private var nutritionSection: some View {
        Section("Nutrition Facts") {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                TextField("Calories", text: $calories)
                    .keyboardType(.numberPad)
                Text("cal")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "p.circle.fill")
                    .foregroundStyle(.blue)
                TextField("Protein", text: $protein)
                    .keyboardType(.decimalPad)
                Text("g")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "c.circle.fill")
                    .foregroundStyle(.yellow)
                TextField("Fat", text: $fat)
                    .keyboardType(.decimalPad)
                Text("g")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(.green)
                TextField("Carbohydrates", text: $carbohydrates)
                    .keyboardType(.decimalPad)
                Text("g")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var mealTypeSection: some View {
        Section("Meal Type") {
            Picker("Meal", selection: $selectedMealType) {
                ForEach(MealType.allCases, id: \.self) { meal in
                    Text(meal.rawValue).tag(meal)
                }
            }
            .pickerStyle(.segmented)
        }
    }

    private var aiSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 8) {
                Label("AI-Powered Analysis", systemImage: "brain")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("Paste your recipe and let AI calculate the nutrition facts automatically.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var isFormValid: Bool {
        !foodName.isEmpty && !calories.isEmpty
    }

    private func analyzeRecipe() {
        isAnalyzing = true
        
        Task {
            do {
                let nutrition = try await geminiService.analyzeRecipe(recipeText)
                
                await MainActor.run {
                    calories = String(nutrition.calories)
                    protein = String(format: "%.1f", nutrition.protein)
                    fat = String(format: "%.1f", nutrition.fat)
                    carbohydrates = String(format: "%.1f", nutrition.carbohydrates)
                    isAnalyzing = false
                    alertMessage = "Nutrition facts analyzed successfully!"
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    isAnalyzing = false
                    alertMessage = "Failed to analyze recipe: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }

    private func saveFood() {
        let entry = FoodEntry(
            name: foodName,
            calories: Int(calories) ?? 0,
            protein: Double(protein) ?? 0,
            fat: Double(fat) ?? 0,
            carbohydrates: Double(carbohydrates) ?? 0,
            mealType: selectedMealType.rawValue,
            recipeText: useAIAnalysis ? recipeText : nil
        )
        
        modelContext.insert(entry)
        dismiss()
    }
}

#Preview {
    AddFoodView()
        .modelContainer(for: FoodEntry.self, inMemory: true)
}
