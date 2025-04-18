extends SceneTree

const NokoModel = preload("res://modules/NokoModel.gd")
const NokoPrompt = preload("res://modules/NokoPrompt.gd")

func _init():
    call_deferred("_start_request")

func _start_request():
    var root = get_root()
    var model = "gemma3"
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
            "content": "Can you tell me back my name?"
        }
    ]

    var server = {
        "host": "http://localhost",
        "port": 11434
    }

    if await NokoModel.load_chat_model(root, server, model, false):
        print("Successfully loaded model: " + model)
    else:
        print("Something went wrong trying to load model: " + model)
        quit()

    var generated = await NokoPrompt.chat(
        root,
        server,
        "gemma3",
        prompt
    )

    print("Me:\t" + prompt[2]["content"])
    print("Gemma:\t" + generated["body"]["message"]["content"])

    if await NokoModel.unload_chat_model(root, server, model, false):
        print("Successfully unloaded model: " + model)
    else:
        print("Something went wrong trying to unload model: " + model)
    quit()
