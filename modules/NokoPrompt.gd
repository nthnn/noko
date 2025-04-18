class_name NokoPrompt

const NetUtils = preload("res://modules/utils/NetUtils.gd")

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
        return {
            "result": 0
        }

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
