# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

extends EditorPlugin

var NokoBlobs = preload("res://modules/NokoBlobs.gd").new()
var NokoModel = preload("res://modules/NokoModel.gd").new()
var NokoPrompt = preload("res://modules/NokoPrompt.gd").new()

func _enter_tree() -> void:
    Engine.register_singleton("NokoBlobs", NokoBlobs)
    Engine.register_singleton("NokoModel", NokoModel)
    Engine.register_singleton("NokoPrompt", NokoPrompt)

func _exit_tree() -> void:
    Engine.unregister_singleton("NokoBlobs")
    Engine.unregister_singleton("NokoModel")
    Engine.unregister_singleton("NokoPrompt")
