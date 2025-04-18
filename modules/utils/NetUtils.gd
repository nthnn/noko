# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

# Utility class providing static methods for HTTP communication.
# Includes methods for sending POST and GET requests with optional headers,
# body or query parameters, and SSL support.
class_name NetUtils

# Sends an HTTP POST request to the specified URL.
# 
# @param parent (Node): The node to which the HTTPRequest will be added.
# @param url (String): The full endpoint URL for the POST request.
# @param headers (Dictionary): Optional HTTP headers (key: header name, value: header value).
# @param body (Dictionary): Optional request payload as key/value pairs, serialized to JSON.
# @param use_ssl (bool): Whether to enforce SSL; setting true allows https URLs.
# @return (Dictionary) A result containing:
#   - result (int): The HTTPRequest result code (OK or error code).
#   - response_code (int): The HTTP status code (e.g., 200, 404).
#   - body (Variant): Parsed JSON body if successful and JSON was returned, otherwise null.
static func send_post_request(
    parent: Node,
    url: String,
    headers: Dictionary = {},
    body: Dictionary = {},
    use_ssl: bool = true
)-> Dictionary:
    var http_request = HTTPRequest.new()
    parent.add_child(http_request)
    
    var response_signal = http_request.request_completed
    http_request.use_threads = true

    var header_array = PackedStringArray()
    for key in headers:
        header_array.append(key + ": " + headers[key])

    var actualBody = "{}"
    if body.size() != 0:
        actualBody = JSON.stringify(body)

    var error = http_request.request(
        url,
        header_array,
        HTTPClient.METHOD_POST,
        actualBody
    )

    if error != OK:
        push_error("HTTP request error: " + str(error))
        http_request.queue_free()
        return {
            "result": HTTPRequest.RESULT_CANT_CONNECT
        }
    
    var response = await response_signal
    http_request.queue_free()

    var bodyValue = null
    if (response[1] == 200
        and response[3] != null
        and response[3].size() != 0):
        bodyValue = JSON.parse_string(
            response[3].get_string_from_utf8()
        )
    else:
        bodyValue = null

    return {
        "result": response[0],
        "response_code": response[1],
        "body": bodyValue
    }

# Sends an HTTP GET request to the specified URL.
# 
# @param parent (Node): The node to which the HTTPRequest will be added.
# @param url (String): The base URL for the GET request; query_params will be appended.
# @param headers (Dictionary): Optional HTTP headers (key: header name, value: header value).
# @param query_params (Dictionary): Optional URL parameters (key: name, value: value) to include.
# @param use_ssl (bool): Whether to enforce SSL; setting true allows https URLs.
# @return (Dictionary) A result containing:
#   - result (int): The HTTPRequest result code (OK or error code).
#   - response_code (int): The HTTP status code (e.g., 200, 404).
#   - body (Variant): Parsed JSON body if successful and JSON was returned, otherwise null.
static func send_get_request(
    parent: Node,
    url: String,
    headers: Dictionary = {},
    query_params: Dictionary = {},
    use_ssl: bool = true
)-> Dictionary:
    var http_request = HTTPRequest.new()
    parent.add_child(http_request)
    
    var response_signal = http_request.request_completed
    http_request.use_threads = true

    var url_encode = func(text: String) -> String:
        var encoded = ""
        for i in text.length():
            var c = text[i]
            var code = c.ord()

            if ((code >= 0x30 and code <= 0x39) or
                (code >= 0x41 and code <= 0x5A) or
                (code >= 0x61 and code <= 0x7A) or
                c == '-' or c == '_' or c == '.' or c == '~'):
                encoded += c
            else:
                encoded += "%" + code.to_hex().pad_zeroes(2).to_upper()
        return encoded

    if !query_params.is_empty():
        var query_string = "?"
        var first = true
        
        for key in query_params:
            if !first:
                query_string += "&"

            first = false
            query_string += url_encode.call(str(key)) + "=" + url_encode.call(
                str(query_params[key])
            )
        url += query_string
    
    var header_array = PackedStringArray()
    if headers.size() != 0:
        for key in headers:
            header_array.append(key + ": " + headers[key])

    var error = http_request.request(
        url,
        header_array,
        HTTPClient.METHOD_GET
    )

    if error != OK:
        push_error("HTTP request error: " + str(error))
        http_request.queue_free()
        return {"result": HTTPRequest.RESULT_CANT_CONNECT}

    var response = await response_signal
    http_request.queue_free()

    var bodyValue = null
    if (response[1] == 200
        and response[3] != null
        and response[3].size() != 0):
        bodyValue = JSON.parse_string(
            response[3].get_string_from_utf8()
        )
    else:
        bodyValue = null

    return {
        "result": response[0],
        "response_code": response[1],
        "body": bodyValue
    }
