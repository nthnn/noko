# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

# Class for managing model lifecycle and server interactions in Noko.
class_name NokoModel

const NetUtils = preload("./utils/NetUtils.gd")

# Initiates loading of a text-generation model on the remote server.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port" keys.
# @param model (String): Identifier of the model to load.
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (bool): True if the request succeeded, false otherwise.
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

# Unloads or shuts down a loaded text-generation model on the server.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port" keys.
# @param model (String): Identifier of the model to unload.
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (bool): True if the request succeeded, false otherwise.
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

# Initiates loading of a chat model (with conversation context) on the server.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port" keys.
# @param model (String): Identifier of the chat model to load.
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (bool): True if the request succeeded, false otherwise.
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

# Unloads a previously loaded chat model, optionally closing session state.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port" keys.
# @param model (String): Identifier of the chat model to unload.
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (bool): True if the request succeeded, false otherwise.
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

# Sends a request to create or configure a new model instance with optional metadata.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port".
# @param model (String): Name or identifier of the new model.
# @param from (String): Origin or base model name (optional).
# @param system (String): System prompt or initial configuration (optional).
# @param template (String): Template name for model generation (optional).
# @param quantize (String): Quantization strategy or level (optional).
# @param messages (Array): Initial conversation messages (optional).
# @param files (Dictionary): Additional file metadata or attachments (optional).
# @param license (Array): License terms or identifiers (optional).
# @param adapters (Dictionary): Adapter configurations (optional).
# @param parameters (Dictionary): Additional parameters (optional).
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (Dictionary): Full response dictionary including result, code, and body.
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

# Retrieves a list of available model tags from the server.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port".
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (Dictionary): Response containing tag list or error information.
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

# Fetches detailed information for a specific model, including metadata.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port".
# @param model (String): Identifier of the model to inspect.
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (Dictionary): Detailed model info or error information.
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
        {
            "model": model,
            "verbose": true
        },
        use_ssl
    )

# Copies an existing model from one name to another on the server.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port".
# @param source (String): Name of the model to copy.
# @param destination (String): New name for the copied model.
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (Dictionary): Result of the copy operation.
static func copy_model(
    parent: Node,
    server: Dictionary,
    source: String,
    destination: String,
    use_ssl: bool = true
)-> Dictionary:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return {"result": 0}

    return await NetUtils.send_post_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/copy",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        {
            "source": source,
            "destination": destination
        },
        use_ssl
    )

# Deletes a model from the server by its identifier.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port".
# @param model (String): Identifier of the model to delete.
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (Dictionary): Result of the delete operation.
static func delete_model(
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
        server["host"] + ":" + str(server["port"]) + "/api/delete",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        {"model": model},
        use_ssl
    )

# Pulls or downloads a model from remote repository to local server.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port".
# @param model (String): Identifier of the model to pull.
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (Dictionary): Result of the pull operation.
static func pull_model(
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
        server["host"] + ":" + str(server["port"]) + "/api/pull",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        {
            "model": model,
            "stream": false
        },
        use_ssl
    )

# Pushes or uploads a local model to a remote repository for sharing.
#
# @param parent (Node): Node to which the HTTPRequest node will be attached.
# @param server (Dictionary): Server configuration with "host" and "port".
# @param model (String): Identifier of the model to push.
# @param use_ssl (bool): Whether to use HTTPS (true) or HTTP (false).
# @return (Dictionary): Result of the push operation.
static func push_model(
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
        server["host"] + ":" + str(server["port"]) + "/api/push",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        {
            "model": model,
            "stream": false
        },
        use_ssl
    )
