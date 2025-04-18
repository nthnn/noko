extends SceneTree

# Preload the NokoModel module, which provides
# functions to interact with models on the server.
const NokoModel = preload("res://modules/NokoModel.gd")

func _init():
    # Defer the execution of _start_request
    # to ensure the scene tree is fully initialized.
    call_deferred("_start_request")

func _start_request():
    # Retrieve the root node of the scene tree.
    var root = get_root()

    # Define the server details where the models are hosted.
    var server = {
        "host": "http://localhost", # Server host address.
        "port": 11434               # Server port number.
    }

    # Asynchronously fetch the list of models from the server.
    var models = await NokoModel.list_model(root, server)

    # Check if the request failed to connect to the server.
    if models["result"] == HTTPRequest.RESULT_CANT_CONNECT:
        print("Failed to list models")
        quit()

    # Extract the list of models from the response body.
    var modelList = models["body"]["models"]

    # Check if the model list is empty.
    if modelList.size() == 0:
        print("No models found")
        quit()  # Terminate the application.

    # Output the list of models found on the server.
    print("Model(s) found:")
    for model in modelList:
        # Print the name of each model.
        print("- " + model["name"])

    # Terminate the application after listing the models.
    quit()
