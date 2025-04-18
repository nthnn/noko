# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

# Class for retrieving runner status and version from a remote Noko server.
class_name NokoRunner

const NetUtils = preload("./utils/NetUtils.gd")

# Fetches the current version of the Noko runner from the server.
#
# Initiates an HTTP GET request to the "/api/version" endpoint
# and returns the version string if successful.
#
# @param parent (Node): Node to attach the HTTPRequest to.
# @param server (Dictionary): Server configuration with keys:
#   - "host" (String): Hostname or URL (e.g., "http://example.com").
#   - "port" (int): Port number (e.g., 8080).
# @param use_ssl (bool): If true, uses HTTPS scheme; otherwise HTTP.
# @return (String): Version string on success, or empty string on error.
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

# Retrieves the current process status identifier of the Noko runner.
#
# Sends an HTTP GET request to the "/api/ps" endpoint
# and returns the status string (e.g., a process ID or state).
#
# @param parent (Node): Node to attach the HTTPRequest to.
# @param server (Dictionary): Server configuration with keys:
#   - "host" (String): Hostname or URL (e.g., "http://example.com").
#   - "port" (int): Port number (e.g., 8080).
# @param use_ssl (bool): If true, uses HTTPS scheme; otherwise HTTP.
# @return (String): Process status string on success, or empty string on error.
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
