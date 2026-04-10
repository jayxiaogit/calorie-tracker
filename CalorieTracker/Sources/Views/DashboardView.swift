import SwiftUI
import SwiftData

struct DashboardView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \FoodEntry.date, order: .reverse) private var entries: [FoodEntry]
    
    @State private var dailyGoal: Int = 2000
    
    private var todayEntries: [FoodEntry] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        return entries.filter { calendar.isDate($0.date, inSameDayAs: today) }
    }
    
    private var totalCalories: Int {
        todayEntries.reduce(0) { $0 + $1.calories }
    }
    
    private var totalProtein: Double {
        todayEntries.reduce(0) { $0 + $1.protein }
    }
    
    private var totalFat: Double {
        todayEntries.reduce(0) { $0 + $1.fat }
    }
    
    private var totalCarbs: Double {
        todayEntries.reduce(0) { $0 + $1.carbohydrates }
    }
    
    private var progressPercentage: Double {
        guard dailyGoal > 0 else { return 0 }
        return min(Double(totalCalories) / Double(dailyGoal), 1.0)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    calorieProgressCard
                    
                    macroSummaryCard
                    
                    recentFoodsCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Dashboard")
        }
    }

    private var calorieProgressCard: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .stroke(Color.orange.opacity(0.2), lineWidth: 20)
                    .frame(width: 180, height: 180)
                
                Circle()
                    .trim(from: 0, to: progressPercentage)
                    .stroke(Color.orange, style: StrokeStyle(lineWidth: 20, lineCap: .round))
                    .frame(width: 180, height: 180)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.5), value: progressPercentage)
                
                VStack(spacing: 4) {
                    Text("\(totalCalories)")
                        .font(.system(size: 36, weight: .bold))
                    Text("of \(dailyGoal) cal")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            
            Text("Daily Progress")
                .font(.headline)
            
            HStack(spacing: 20) {
                statItem(value: "\(Int(progressPercentage * 100))%", label: "Goal")
                statItem(value: "\(todayEntries.count)", label: "Entries")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var macroSummaryCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Macronutrients")
                .font(.headline)
            
            HStack(spacing: 16) {
                macroBar(label: "Protein", value: totalProtein, maxValue: 150, color: .blue)
                macroBar(label: "Fat", value: totalFat, maxValue: 65, color: .yellow)
                macroBar(label: "Carbs", value: totalCarbs, maxValue: 300, color: .green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func macroBar(label: String, value: Double, maxValue: Double, color: Color) -> some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(color.opacity(0.2))
                    .frame(width: 60, height: 100)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: 60, height: min(value / maxValue * 100, 100))
                    .animation(.easeInOut(duration: 0.5), value: value)
            }
            
            Text("\(Int(value))g")
                .font(.caption)
                .fontWeight(.medium)
            
            Text(label)
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
    }

    private var recentFoodsCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Foods")
                    .font(.headline)
                Spacer()
                NavigationLink("See All") {
                    FoodLogView()
                }
                .font(.subheadline)
            }
            
            if todayEntries.isEmpty {
                ContentUnavailableView(
                    "No food logged today",
                    systemImage: "fork.knife",
                    description: Text("Add your first meal from the Add Food tab")
                )
                .frame(height: 150)
            } else {
                ForEach(todayEntries.prefix(3)) { entry in
                    foodRow(entry)
                    if entry.id != todayEntries.prefix(3).last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func foodRow(_ entry: FoodEntry) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(entry.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(entry.mealType)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            Text("\(entry.calories) cal")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.orange)
        }
    }
}

#Preview {
    DashboardView()
        .modelContainer(for: FoodEntry.self, inMemory: true)
}
