extends SceneTree

const NokoModel = preload("res://modules/NokoModel.gd")

func _init():
    call_deferred("_start_request")

func _start_request():
    var root = get_root()
    var server = {
        "host": "http://localhost",
        "port": 11434
    }

    var models = await NokoModel.list_model(root, server)
    if models["result"] == HTTPRequest.RESULT_CANT_CONNECT:
        print("Failed to list models")
        quit()

    var modelList = models["body"]["models"]
    if modelList.size() == 0:
        print("No models found")
        quit()

    print("Model(s) found:")
    for model in modelList:
        print("- " + model["name"])

    quit()
