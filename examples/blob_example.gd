extends SceneTree

# Preload the NokoBlobs module, which provides blob-related functionalities.
const NokoBlob = preload("res://modules/NokoBlobs.gd")

func _init():
    # Defer the execution of _start_request to
    # ensure the scene tree is fully initialized.
    call_deferred("_start_request")

func _start_request():
    # Define the SHA-256 digest of the blob to check.
    var digest = "29fdb92e57cf0827ded04ae6461b5931d01fa595843f55d36f5b275a52087dd2"
    
    # Retrieve the root node of the scene tree.
    var root = get_root()

    # Define the server details where the blob is expected to be found.
    var server = {
        "host": "http://localhost", # Server host address.
        "port": 11434               # Server port number.
    }

    # Asynchronously check if the blob exists
    # on the server using the provided digest.
    if await NokoBlob.has_blob(root, server, digest):
        print("Blob exists!")
    else:
        print("Blob doesn't exists!")

    # Terminate the application after the check is complete.
    quit()
