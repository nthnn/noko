extends SceneTree

# Preload the NokoRunner module which contains utility
# functions to interact with the Ollama runner.
const NokoRunner = preload("res://modules/NokoRunner.gd")

func _init():
    # Defer the _start_request function to run after
    # the scene tree has been fully initialized.
    call_deferred("_start_request")

func _start_request():
    # Asynchronously fetch the version information
    # from the Ollama runner using NokoRunner.
    var version = await NokoRunner.version(get_root(), {
        # Server host where Ollama runner is running.
        "host": "http://localhost",

        # Port on which the Ollama runner listens.
        "port": 11434
    })

    # Print the retrieved version to the console.
    print("Ollama runner version is " + version)

    # Quit the application after printing the version.
    quit()
