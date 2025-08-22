import os
import google.generativeai as genai
from pathlib import Path

# NO
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

def chat_video():
    """
    Takes a video/audio file path, extracts the audio transcript (Gemini can't do direct transcription yet).
    For now, this just simulates 'reading' the file contents as if it were a transcript.
    """
    link = input("Paste the path to the video/audio file: ")
    file_path = Path(link)

    if not file_path.exists():
        return "Error: File not found."

    # TODO: Replace with transcription service when Gemini supports audio/video.
    # For now, treat as placeholder.
    return f"(Transcription placeholder for {file_path.name})"

def chat_with_gemini():
    print("Welcome to Calorie Tracking AI.")
    print("Paste a recipe and I’ll return the calorie and macro breakdown.")
    print("Enter Q to quit. Type T for text-based or V for video-based recipe breakdowns.\n")

    model = genai.GenerativeModel("gemini-2.5-pro")

    while True:
        user_input = input("You: ")

        if user_input.upper() == "V":
            user_input = chat_video()
        elif user_input.upper() == "T":
            print("Paste the recipe below:")
            user_input = input("You: ")
        elif user_input.upper() == "Q":
            print("Thanks for chatting!")
            break
        else:
            print("Please input a valid option (T, V, Q).")
            continue

        # Send to Gemini
        response = model.generate_content(
            f"You are an assistant who parses recipes and returns total nutrition facts (calories, protein, fat, carbohydrates).\n\nRecipe:\n{user_input}"
        )

        print("\nAssistant:", response.text, "\n")


if __name__ == "__main__":
    chat_with_gemini()
