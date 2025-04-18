extends SceneTree

const NetUtils = preload("../modules/NetUtils.gd")

func _init():
    call_deferred("_start_request")

func _start_request():
    var get_response = await NetUtils.send_get_request(
        get_root(),
        "https://catfact.ninja/fact",
        {}, {}
    )

    if get_response["result"] == HTTPRequest.RESULT_SUCCESS:
        print(
            "Here's a random cat fact:\r\n",
            get_response["body"]["fact"]
        )
    else:
        print("Failed to fetch random cat fact.")
    quit()
