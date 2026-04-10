import SwiftUI

struct SettingsView: View {
    @AppStorage("dailyCalorieGoal") private var dailyCalorieGoal: Int = 2000
    @AppStorage("dailyProteinGoal") private var dailyProteinGoal: Int = 150
    @AppStorage("dailyFatGoal") private var dailyFatGoal: Int = 65
    @AppStorage("dailyCarbsGoal") private var dailyCarbsGoal: Int = 300
    
    @State private var apiKey: String = ""
    @State private var showAPIKeyAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                goalsSection
                apiSection
                aboutSection
            }
            .navigationTitle("Settings")
        }
    }

    private var goalsSection: some View {
        Section {
            HStack {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .frame(width: 24)
                Text("Calories")
                Spacer()
                Stepper("\(dailyCalorieGoal) cal", value: $dailyCalorieGoal, in: 1000...5000, step: 100)
                    .frame(width: 150)
            }
            
            HStack {
                Image(systemName: "p.circle.fill")
                    .foregroundStyle(.blue)
                    .frame(width: 24)
                Text("Protein")
                Spacer()
                Stepper("\(dailyProteinGoal)g", value: $dailyProteinGoal, in: 50...400, step: 10)
                    .frame(width: 150)
            }
            
            HStack {
                Image(systemName: "c.circle.fill")
                    .foregroundStyle(.yellow)
                    .frame(width: 24)
                Text("Fat")
                Spacer()
                Stepper("\(dailyFatGoal)g", value: $dailyFatGoal, in: 20...200, step: 5)
                    .frame(width: 150)
            }
            
            HStack {
                Image(systemName: "leaf.fill")
                    .foregroundStyle(.green)
                    .frame(width: 24)
                Text("Carbohydrates")
                Spacer()
                Stepper("\(dailyCarbsGoal)g", value: $dailyCarbsGoal, in: 50...600, step: 10)
                    .frame(width: 150)
            }
        } header: {
            Text("Daily Goals")
        } footer: {
            Text("Set your daily nutrition goals to track your progress")
        }
    }

    private var apiSection: some View {
        Section {
            NavigationLink {
                APIKeyView()
            } label: {
                HStack {
                    Image(systemName: "key.fill")
                        .foregroundStyle(.purple)
                        .frame(width: 24)
                    Text("API Key")
                    Spacer()
                    Text(hasAPIKey ? "Configured" : "Not Set")
                        .foregroundStyle(.secondary)
                }
            }
        } header: {
            Text("AI Configuration")
        } footer: {
            Text("Add your Gemini API key to enable AI-powered recipe analysis")
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text("1.0.0")
                    .foregroundStyle(.secondary)
            }
            
            HStack {
                Text("Developer")
                Spacer()
                Text("Calorie Tracker Team")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var hasAPIKey: Bool {
        if let key = Bundle.main.infoDictionary?["API_KEY"] as? String {
            return !key.isEmpty
        }
        return false
    }
}

struct APIKeyView: View {
    @State private var apiKey: String = ""
    @State private var showSaveAlert: Bool = false
    
    var body: some View {
        Form {
            Section {
                SecureField("Enter your Gemini API Key", text: $apiKey)
                    .textContentType(.password)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            } header: {
                Text("Gemini API Key")
            } footer: {
                Text("Get your API key from Google AI Studio")
            }
            
            Section {
                Link(destination: URL(string: "https://aistudio.google.com/apikey")!) {
                    HStack {
                        Text("Get API Key")
                        Spacer()
                        Image(systemName: "arrow.up.right.square")
                    }
                }
            }
        }
        .navigationTitle("API Key")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveAPIKey()
                }
                .disabled(apiKey.isEmpty)
            }
        }
        .alert("API Key Saved", isPresented: $showSaveAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your API key has been saved. Please restart the app for changes to take effect.")
        }
        .onAppear {
            loadAPIKey()
        }
    }
    
    private func loadAPIKey() {
        if let savedKey = UserDefaults.standard.string(forKey: "GEMINI_API_KEY") {
            apiKey = savedKey
        }
    }
    
    private func saveAPIKey() {
        UserDefaults.standard.set(apiKey, forKey: "GEMINI_API_KEY")
        showSaveAlert = true
    }
}

#Preview {
    SettingsView()
}
