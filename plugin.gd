extends EditorPlugin

var net_utils

func _enter_tree() -> void:
    net_utils = preload("res://modules/NetUtils.gd").new()
    Engine.register_singleton("NetUtils", net_utils)

func _exit_tree() -> void:
    Engine.unregister_singleton("NetUtils")
