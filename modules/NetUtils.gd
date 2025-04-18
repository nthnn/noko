class_name NetUtils

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

    var error = http_request.request(
        url,
        header_array,
        HTTPClient.METHOD_POST,
        JSON.stringify(body)
    )

    if error != OK:
        push_error("HTTP request error: " + str(error))
        http_request.queue_free()
        return {
            "result": HTTPRequest.RESULT_CANT_CONNECT
        }
    
    var response = await response_signal
    http_request.queue_free()
    
    return {
        "result": response[0],
        "response_code": response[1],
        "headers": JSON.parse_string(str(response[2])),
        "body": JSON.parse_string(response[3].get_string_from_utf8())
    }

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
    for key in headers:
        header_array.append(key + ": " + headers[key])
    
    var error = http_request.request(url, header_array, HTTPClient.METHOD_GET)
    if error != OK:
        push_error("An error occurred in the HTTP request: " + str(error))
        http_request.queue_free()
        return {
            "result": HTTPRequest.RESULT_CANT_CONNECT
        }

    var response = await response_signal
    http_request.queue_free()

    return {
        "result": response[0],
        "response_code": response[1],
        "headers": JSON.parse_string(str(response[2])),
        "body": JSON.parse_string(response[3].get_string_from_utf8())
    }
