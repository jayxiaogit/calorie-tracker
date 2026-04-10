import SwiftUI
import SwiftData

struct FoodLogView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FoodEntry.date, order: .reverse) private var entries: [FoodEntry]
    
    @State private var selectedMealType: MealType? = nil
    @State private var searchText: String = ""
    
    private var filteredEntries: [FoodEntry] {
        var result = entries
        
        if let mealType = selectedMealType {
            result = result.filter { $0.mealType == mealType.rawValue }
        }
        
        if !searchText.isEmpty {
            result = result.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        return result
    }
    
    private var groupedEntries: [(String, [FoodEntry])] {
        let grouped = Dictionary(grouping: filteredEntries) { entry in
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .none
            return formatter.string(from: entry.date)
        }
        return grouped.sorted { $0.key > $1.key }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                mealTypePicker
                
                if filteredEntries.isEmpty {
                    emptyState
                } else {
                    foodList
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Food Log")
            .searchable(text: $searchText, prompt: "Search foods")
        }
    }

    private var mealTypePicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                filterChip(title: "All", isSelected: selectedMealType == nil) {
                    selectedMealType = nil
                }
                
                ForEach(MealType.allCases, id: \.self) { meal in
                    filterChip(title: meal.rawValue, isSelected: selectedMealType == meal) {
                        selectedMealType = meal
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }

    private func filterChip(title: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.orange : Color(.systemGray5))
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Food Entries", systemImage: "fork.knife")
        } description: {
            Text("Start logging your meals to track your nutrition")
        } actions: {
            NavigationLink("Add Food") {
                AddFoodView()
            }
            .buttonStyle(.borderedProminent)
            .tint(.orange)
        }
    }

    private var foodList: some View {
        List {
            ForEach(groupedEntries, id: \.0) { date, foods in
                Section(header: Text(date)) {
                    ForEach(foods) { entry in
                        FoodEntryRow(entry: entry)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    deleteEntry(entry)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
    }

    private func deleteEntry(_ entry: FoodEntry) {
        withAnimation {
            modelContext.delete(entry)
        }
    }
}

struct FoodEntryRow: View {
    let entry: FoodEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(entry.name)
                    .font(.headline)
                
                Spacer()
                
                Text("\(entry.calories) cal")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.orange)
            }
            
            HStack(spacing: 16) {
                macroLabel(icon: "flame.fill", value: "\(Int(entry.protein))g", color: .blue)
                macroLabel(icon: "drop.fill", value: "\(Int(entry.fat))g", color: .yellow)
                macroLabel(icon: "leaf.fill", value: "\(Int(entry.carbohydrates))g", color: .green)
                
                Spacer()
                
                Text(entry.mealType)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 4)
    }
    
    private func macroLabel(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
                .foregroundStyle(color)
            Text(value)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    FoodLogView()
        .modelContainer(for: FoodEntry.self, inMemory: true)
}
