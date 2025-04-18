# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

class_name NokoRunner

const NetUtils = preload("res://modules/utils/NetUtils.gd")

static func version(
    parent: Node,
    server: Dictionary,
    use_ssl: bool = true
)-> String:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return ""

    var response = await NetUtils.send_get_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/version",
        {"User-Agent": "noko-godot/0.0.1"},
        {},
        use_ssl
    )

    if response["result"] == HTTPRequest.RESULT_CANT_CONNECT:
        push_error("Failed to fetch runner version")
        return ""

    return response["body"]["version"]

static func process_status(
    parent: Node,
    server: Dictionary,
    use_ssl: bool = true
)-> String:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return ""

    var response = await NetUtils.send_get_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/ps",
        {"User-Agent": "noko-godot/0.0.1"},
        {},
        use_ssl
    )

    if response["result"] == HTTPRequest.RESULT_CANT_CONNECT:
        push_error("Failed to fetch runner version")
        return ""

    return response["body"]["version"]
