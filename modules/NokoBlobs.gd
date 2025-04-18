# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

class_name NokoBlobs

const NetUtils = preload("./utils/NetUtils.gd")
const ValidatorUtils = preload("./utils/ValidatorUtils.gd")

# Checks if a blob identified by its SHA-256 digest exists on the server.
#
# This function performs a GET request to the server's blob endpoint to verify
# the existence of a blob corresponding to the provided SHA-256 digest.
#
# @param parent (Node): The node initiating the request, used for signal connections.
# @param server (Dictionary): A dictionary containing the server's 'host' and 'port'.
# @param digest (String): The SHA-256 hash of the blob to check.
# @param use_ssl (bool, optional): Determines whether to use HTTPS. Defaults to true.
# @return (bool): True if the blob exists on the server (HTTP 200 response), false otherwise.
static func has_blob(
    parent: Node,
    server: Dictionary,
    digest: String,
    use_ssl: bool = true
)-> bool:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return false

    if !ValidatorUtils.is_valid_sha256(digest):
        push_error("Digest parameter is not a valid SHA-256 hash")
        return false

    var response = await NetUtils.send_get_request(
        parent,
        server["host"] + ":"
            + str(server["port"])
            + "/api/blobs/sha256:" + digest,
        {"User-Agent": "noko-godot/0.0.1"},
        {},
        use_ssl
    )

    return response["response_code"] == 200
