from openai import OpenAI

client = OpenAI()

def chat_with_gpt():
    print("ChatGPT Agent (type 'quit' to exit)\n")

    # Conversation history
    messages = [
        {"role": "system", "content": "You are a assistant who parses through recipes and returns the total nutrition facts of the recipe. Return calorie, protein, fat, and carbohydrate content."}
    ]

    while True:
        user_input = input("You: ")

        if user_input == "Q":
            print("Thanks for chatting")
            break

        # Add user message
        messages.append({"role": "user", "content": user_input})

        # Send to GPT
        response = client.chat.completions.create(
            model="gpt-4o-mini",  # You can change to another available model
            messages=messages
        )

        # Extract reply
        reply = response.choices[0].message.content
        print("Assistant:", reply)

        # Add assistant reply to history
        messages.append({"role": "assistant", "content": reply})

if __name__ == "__main__":
    print("Welcome to Calorie Tracking AI. This is the agent. Paste a recipe into the agent, and we will return the total calorie and macro breakdown. Enter Q to quit")
    chat_with_gpt()

