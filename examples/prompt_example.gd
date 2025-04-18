extends SceneTree

# Preload the NokoModel module, which provides
# functions to manage AI models.
const NokoModel = preload("res://modules/NokoModel.gd")

# Preload the NokoPrompt module, which provides functions
# to interact with AI models via prompts.
const NokoPrompt = preload("res://modules/NokoPrompt.gd")

func _init():
    # Defer the execution of _start_request to ensure
    # the scene tree is fully initialized.
    call_deferred("_start_request")

func _start_request():
    # Retrieve the root node of the scene tree.
    var root = get_root()

    # Define the name of the AI model to use.
    var model = "gemma3"

    # Define the conversation history as a list of message dictionaries.
    var prompt = [
        {
            "role": "user",
            "content": "Hello! I am Nathanne."
        },
        {
            "role": "assistant",
            "content": "Hello, Nathanne. I am Gemma, an AI assistant developed by Google DeepMind."
        },
        {
            "role": "user",
            "content": "Can you tell me back my name? (Answer in one sentence only)"
        }
    ]

    # Define the server details where the AI model is hosted.
    var server = {
        "host": "http://localhost", # Server host address.
        "port": 11434               # Server port number.
    }

    # Asynchronously load the specified chat model on the server.
    if await NokoModel.load_chat_model(root, server, model, false):
        print("Successfully loaded model: " + model)
    else:
        print("Something went wrong trying to load model: " + model)
        quit()  # Terminate the application if loading fails.

    # Asynchronously send the conversation prompt
    # to the AI model and await the response.
    var generated = await NokoPrompt.chat(
        root,
        server,
        "gemma3",
        prompt
    )

    # Output the user's last message.
    print("Me:\t" + prompt[2]["content"])

    # Output the assistant's response from the AI model.
    print("Gemma:\t" + generated["body"]["message"]["content"])

    # Asynchronously unload the chat model from the server to free up resources.
    if await NokoModel.unload_chat_model(root, server, model, false):
        print("Successfully unloaded model: " + model)
    else:
        print("Something went wrong trying to unload model: " + model)

    # Terminate the application after the interaction is complete.
    quit()
