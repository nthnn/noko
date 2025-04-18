# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

# Class for sending prompts and messages to remote Noko language models.
class_name NokoPrompt

const NetUtils = preload("./utils/NetUtils.gd")

# Sends a text-completion request to a generation endpoint.
#
# @param parent (Node): Node to attach the HTTPRequest to.
# @param server (Dictionary): Server config containing 'host' and 'port'.
# @param model (String): Identifier of the model to use for generation.
# @param prompt (String): The input text prompt to send to the model.
# @param suffix (String): Text appended after the generated content (optional).
# @param image (Dictionary): Optional image data or parameters for multimodal generation.
# @param options (Dictionary): Additional generation parameters (e.g., max_tokens, temperature).
# @param use_ssl (bool): If true, uses 'https://' schema; otherwise 'http://'.
# @return (Dictionary): Response dictionary with:
#   - result (int): HTTPRequest result code.
#   - response_code (int): HTTP status code returned by the server.
#   - body (Variant): Decoded JSON response or null on error.
static func generate(
    parent: Node,
    server: Dictionary,
    model: String,
    prompt: String,
    suffix: String = "",
    image: Dictionary = {},
    options: Dictionary = {},
    use_ssl: bool = true
)-> Dictionary:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return {"result": 0}

    var data = {
        "model": model,
        "prompt": prompt,
        "suffix": suffix,
        "stream": false,
        "options": options
    }

    if image.size() != 0:
        data["images"] = image

    var response = await NetUtils.send_post_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/generate",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        data,
        use_ssl
    )

    if response["result"] == HTTPRequest.RESULT_SUCCESS:
        return response

    push_error("Error trying to generate response")
    return response

# Sends a conversational chat request to a chat endpoint.
#
# @param parent (Node): Node to attach the HTTPRequest to.
# @param server (Dictionary): Server config containing 'host' and 'port'.
# @param model (String): Identifier of the chat model to interact with.
# @param messages (Array): Conversation history as array of role/content maps.
# @param suffix (String): Text appended after the assistant's reply (optional).
# @param image (Dictionary): Optional image context for multimodal chats.
# @param options (Dictionary): Additional chat parameters (e.g., max_tokens, temperature).
# @param use_ssl (bool): If true, uses 'https://' schema; otherwise 'http://'.
# @return (Dictionary): Response dictionary with:
#   - result (int): HTTPRequest result code.
#   - response_code (int): HTTP status code returned by the server.
#   - body (Variant): Decoded JSON response or null on error.
static func chat(
    parent: Node,
    server: Dictionary,
    model: String,
    messages: Array,
    suffix: String = "",
    image: Dictionary = {},
    options: Dictionary = {},
    use_ssl: bool = true
)-> Dictionary:
    if (!server.has("host") or
        !server.has("port")):
        push_error("Server host name and port number must be defined")
        return {"result": 0}

    var data = {
        "model": model,
        "messages": messages,
        "suffix": suffix,
        "stream": false,
        "options": options
    }

    if image.size() != 0:
        data["images"] = image

    var response = await NetUtils.send_post_request(
        parent,
        server["host"] + ":" + str(server["port"]) + "/api/chat",
        {
            "User-Agent": "noko-godot/0.0.1",
            "Content-Type": "application/x-www-form-urlencoded"
        },
        data,
        use_ssl
    )

    if response["result"] == HTTPRequest.RESULT_SUCCESS:
        return response

    push_error("Error trying to generate response")
    return response
