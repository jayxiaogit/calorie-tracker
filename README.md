# CalorieTracker iOS App

A native iOS app for tracking calories and nutrition, built with **SwiftUI** and **SwiftData**, featuring AI-powered nutrition analysis using Google Gemini.

---

## Overview

CalorieTracker helps users log meals, track macronutrients, and monitor daily calorie intake with minimal friction. It supports both manual food entry and AI-assisted recipe analysis.

The app is privacy-first, with all data stored locally on-device using SwiftData.

---

## Problem Statement

Users often struggle with:
- Accurately tracking daily calories and macros
- Logging meals quickly and efficiently
- Estimating nutrition from homemade recipes

Existing solutions are often:
- Overly complex or cluttered
- Dependent on external databases
- Locked behind subscriptions

---

## Goals

- Fast and simple calorie tracking
- Reduce friction in food logging
- Enable AI-powered nutrition estimation
- Fully local data storage (no backend required)

---

## Target Users

- Fitness enthusiasts
- People tracking weight loss or gain
- Home cooks estimating nutrition
- Privacy-conscious users

---

## Features

### Dashboard
- Daily calorie progress overview
- Macronutrient breakdown (protein, carbs, fats)
- Visual progress indicators
- Auto-resets daily

---

### Food Log
- View all food entries by date
- Filter by meal type (breakfast, lunch, dinner, snack)
- Search food entries
- Edit and delete entries
- Swipe actions for quick management

---

### Add Food

Two ways to log food:

#### Manual Entry
- Food name
- Calories
- Protein, carbs, fats
- Meal type
- Date/time selection

#### AI-Powered Entry (Gemini)
- Enter recipe in natural language
- Example: "chicken pasta with cream sauce"
- AI returns:
  - Estimated calories
  - Macronutrients
  - Suggested ingredient assumptions

---

### AI Integration (GeminiService)
- Uses Google Gemini API
- Converts recipes → structured nutrition data
- Returns JSON-formatted nutrition estimates
- Handles API errors gracefully
- Allows user edits before saving

---

### Settings
- Set daily calorie goal
- Toggle AI feature on/off
- Clear all data (with confirmation)
- View app version info

---

## Data Model (SwiftData)

### FoodEntry

```swift
id: UUID
name: String
calories: Int
protein: Int
carbs: Int
fat: Int
date: Date
mealType: String
source: String // manual | ai
