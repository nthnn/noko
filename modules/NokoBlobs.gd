# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

class_name NokoBlobs

const NetUtils = preload("res://modules/utils/NetUtils.gd")
const ValidatorUtils = preload("res://modules/utils/ValidatorUtils.gd")

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
