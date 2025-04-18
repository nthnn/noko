extends SceneTree

# Preloads the NokoModel module for accessing model-related API functions.
const NokoModel = preload("res://modules/NokoModel.gd")

func _init():
    # Schedules the _start_request function to be
    # called once the scene tree is initialized.
    call_deferred("_start_request")

func _start_request():
    # Retrieves the root node of the SceneTree
    # (used as the parent for HTTP requests).
    var root = get_root()

    # The name of the model to query information for.
    var modelName = "gemma3"
    var server = {
        "host": "http://localhost", # Local server hostname.
        "port": 11434               # Port number for the Noko server.
    }

    # Sends an asynchronous request to fetch
    # information about the specified model.
    var info = await NokoModel.fetch_model_info(
        root,
        server,
        modelName
    )

    # If the HTTP request failed to connect,
    # print an error and quit the application.
    if info["result"] == HTTPRequest.RESULT_CANT_CONNECT:
        print("Failed to fetch model information")
        quit()

    # Extracts the model details from the response body.
    var modelDetails = info["body"]["details"]

    # Prints out formatted information about the model.
    print("Model information")
    print("------------------------------")
    print("Name:\t\t\t" + modelName)
    print("Parameter Size:\t\t" + modelDetails["parameter_size"])
    print("Quantization Level:\t" + modelDetails["quantization_level"])

    # Terminates the application once the info is printed.
    quit()
