# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

class_name NokoPrompt

const NetUtils = preload("res://modules/utils/NetUtils.gd")

static func load_generate_model(
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

static func unload_generate_model(
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

static func load_chat_model(
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
        server["host"] + ":" + str(server["port"]) + "/api/chat",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        {
            "model": model,
            "messages": []
        },
        use_ssl
    )

    return response["result"] == HTTPRequest.RESULT_SUCCESS

static func unload_chat_model(
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
        server["host"] + ":" + str(server["port"]) + "/api/chat",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        {
            "model": model,
            "messages": [],
            "keep_alive": 0
        },
        use_ssl
    )

    return response["result"] == HTTPRequest.RESULT_SUCCESS

static func create_model(
    parent: Node,
    server: Dictionary,
    model: String,
    from: String = "",
    system: String = "",
    template: String = "",
    quantize: String = "",
    messages: Array = [],
    files: Dictionary = {},
    license: Array = [],
    adapters: Dictionary = {},
    parameters: Dictionary = {},
    use_ssl: bool = true
)-> Dictionary:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return {"result": 0}

    var requestBody = {"model": model}

    if from != "":
        requestBody["from"] = from
    if system != "":
        requestBody["system"] = system
    if template != "":
        requestBody["template"] = template
    if quantize != "":
        requestBody["quantize"] = quantize

    if messages.size() != 0:
        requestBody["messages"] = messages
    if files.size() != 0:
        requestBody["files"] = files
    if license.size() != 0:
        requestBody["license"] = license
    if adapters.size() != 0:
        requestBody["adapters"] = adapters
    if parameters.size() != 0:
        requestBody["parameters"] = parameters

    var response = await NetUtils.send_post_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/create",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        requestBody,
        use_ssl
    )

    if response["result"] == HTTPRequest.RESULT_SUCCESS:
        return response

    push_error("Error trying to generate model")
    return response

static func list_model(
    parent: Node,
    server: Dictionary,
    use_ssl: bool = true
)-> Dictionary:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return {"result": 0}

    return await NetUtils.send_get_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/tags",
        {"User-Agent": "noko-godot/0.0.1"},
        {},
        use_ssl
    )

static func fetch_model_info(
    parent: Node,
    server: Dictionary,
    model: String,
    use_ssl: bool = true
)-> Dictionary:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return {"result": 0}

    return await NetUtils.send_post_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/show",
        {"User-Agent": "noko-godot/0.0.1"},
        {"model": model},
        use_ssl
    )
