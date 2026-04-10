# CalorieTracker iOS App

A native iOS app for tracking calories and nutrition, built with SwiftUI and SwiftData.

## Features

- **Dashboard**: View daily calorie progress and macronutrient breakdown
- **Food Log**: Track and search your food entries by date and meal type
- **Add Food**: Manually enter nutrition data or use AI-powered recipe analysis
- **AI Integration**: Uses Google Gemini to analyze recipes and calculate nutrition facts
- **Persistent Storage**: All data is stored locally using SwiftData

## Project Structure

```
CalorieTracker/
├── Sources/
│   ├── App/
│   │   └── CalorieTrackerApp.swift      # App entry point
│   ├── Models/
│   │   └── FoodEntry.swift              # Data models
│   ├── Views/
│   │   ├── ContentView.swift            # Tab-based navigation
│   │   ├── DashboardView.swift          # Main dashboard
│   │   ├── FoodLogView.swift            # Food entries list
│   │   ├── AddFoodView.swift            # Add new food entry
│   │   └── SettingsView.swift           # App settings
│   └── Services/
│       └── GeminiService.swift           # Gemini API integration
├── Resources/
│   ├── Info.plist
│   └── Assets.xcassets/
└── project.yml                          # XcodeGen configuration
```

## Prerequisites

- macOS 14.0 or later
- Xcode 15.0 or later
- XcodeGen (`brew install xcodegen`)
- iOS 17.0+ simulator or device

## Setup Instructions

### 1. Install XcodeGen

```bash
brew install xcodegen
```

### 2. Generate the Xcode Project

```bash
cd CalorieTracker
xcodegen generate
```

### 3. Get Gemini API Key

1. Go to [Google AI Studio](https://aistudio.google.com/apikey)
2. Create an API key
3. In the app, go to Settings > API Key and enter your key

### 4. Open and Build

```bash
open CalorieTracker.xcodeproj
```

Then in Xcode:
1. Select a simulator (e.g., iPhone 16)
2. Press Cmd+R to build and run

### 5. Add API Key at Runtime (Alternative)

Set the `GEMINI_API_KEY` environment variable in Xcode:
1. Edit Scheme (Cmd+Shift+<)
2. Go to Run > Arguments
3. Add Environment Variable: `GEMINI_API_KEY` = your_api_key

## Usage

1. **Dashboard**: See your daily calorie progress and macros at a glance
2. **Add Food**: Enter food details manually or paste a recipe for AI analysis
3. **Food Log**: View and manage all your logged meals
4. **Settings**: Customize daily goals and configure API key

## Technology Stack

- **UI Framework**: SwiftUI
- **Data Persistence**: SwiftData
- **AI Integration**: Google Gemini API via generative-ai-swift
- **Build System**: XcodeGen + Swift Package Manager

## License

MIT
