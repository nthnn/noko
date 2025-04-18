extends SceneTree

const NokoBlob = preload("res://modules/NokoBlobs.gd")

func _init():
    call_deferred("_start_request")

func _start_request():
    var digest = "29fdb92e57cf0827ded04ae6461b5931d01fa595843f55d36f5b275a52087dd2"
    var root = get_root()
    var server = {
        "host": "http://localhost",
        "port": 11434
    }

    if await NokoBlob.has_blob(root, server, digest):
        print("Blob exists!")
    else:
        print("Blob doesn't exists!")

    quit()
