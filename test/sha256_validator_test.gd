extends SceneTree

const ValidtorUtils = preload("res://modules/utils/ValidatorUtils.gd")

func _init():
    var good = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    var bad  = "xyz123"

    print(ValidtorUtils.is_valid_sha256(good))
    print(ValidtorUtils.is_valid_sha256(bad))

    quit()
