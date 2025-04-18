extends SceneTree

const NokoModel = preload("res://modules/NokoModel.gd")

func _init():
    call_deferred("_start_request")

func _start_request():
    var root = get_root()
    var modelName = "gemma3"
    var server = {
        "host": "http://localhost",
        "port": 11434
    }

    var info = await NokoModel.fetch_model_info(
        root,
        server,
        modelName
    )

    if info["result"] == HTTPRequest.RESULT_CANT_CONNECT:
        print("Failed to fetch model information")
        quit()

    var modelDetails = info["body"]["details"]
    print("Model information")
    print("------------------------------")
    print("Name:\t\t\t" + modelName)
    print("Parameter Size:\t\t" + modelDetails["parameter_size"])
    print("Quantization Level:\t" + modelDetails["quantization_level"])

    quit()
