extends EditorPlugin

var NokoModel = preload("res://modules/NokoModel.gd").new()
var NokoPrompt = preload("res://modules/NokoPrompt.gd").new()

func _enter_tree() -> void:
    Engine.register_singleton("NokoModel", NokoModel)
    Engine.register_singleton("NokoPrompt", NokoPrompt)

func _exit_tree() -> void:
    Engine.unregister_singleton("NokoModel")
    Engine.unregister_singleton("NokoPrompt")
