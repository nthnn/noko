extends SceneTree

const NokoModel = preload("res://modules/NokoModel.gd")
const NokoPrompt = preload("res://modules/NokoPrompt.gd")

func _init():
    call_deferred("_start_request")

func _start_request():
    var root = get_root()
    var model = "gemma3"
    var prompt = "Hello! What's your name? (Answer in one sentence)"

    var server = {
        "host": "http://localhost",
        "port": 11434
    }

    if await NokoModel.load_model(root, server, model, false):
        print("Successfully loaded model: " + model)
    else:
        print("Something went wrong trying to load model: " + model)
        quit()

    var generated = await NokoPrompt.generate(
        root,
        server,
        "gemma3",
        prompt
    )

    print("Me: " + prompt)
    print("Gemma: " + generated["body"]["response"])

    if await NokoModel.unload_model(root, server, model, false):
        print("Successfully unloaded model: " + model)
    else:
        print("Something went wrong trying to unload model: " + model)
    quit()
