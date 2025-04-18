extends SceneTree

const NokoRunner = preload("res://modules/NokoRunner.gd")

func _init():
    call_deferred("_start_request")

func _start_request():
    var version = await NokoRunner.version(get_root(), {
        "host": "http://localhost",
        "port": 11434
    })

    print("Ollama runner version is " + version)
    quit()
