class_name NokoPrompt

const NetUtils = preload("res://modules/utils/NetUtils.gd")

static func load_model(
    parent: Node,
    server: Dictionary,
    model: String,
    use_ssl: bool = true
)-> bool:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return false

    var response = await NetUtils.send_post_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/generate",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        {"model": model},
        use_ssl
    )

    return response["result"] == HTTPRequest.RESULT_SUCCESS

static func unload_model(
    parent: Node,
    server: Dictionary,
    model: String,
    use_ssl: bool = true
)-> bool:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return false

    var response = await NetUtils.send_post_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/generate",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        {
            "model": model,
            "keep_alive": 0
        },
        use_ssl
    )

    return response["result"] == HTTPRequest.RESULT_SUCCESS
