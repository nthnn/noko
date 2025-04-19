# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

@tool
extends EditorPlugin

var NokoBlobs = preload("./modules/NokoBlobs.gd").new()
var NokoModel = preload("./modules/NokoModel.gd").new()
var NokoPrompt = preload("./modules/NokoPrompt.gd").new()

func _enter_tree() -> void:
    Engine.register_singleton("NokoBlobs", NokoBlobs)
    Engine.register_singleton("NokoModel", NokoModel)
    Engine.register_singleton("NokoPrompt", NokoPrompt)

func _exit_tree() -> void:
    Engine.unregister_singleton("NokoBlobs")
    Engine.unregister_singleton("NokoModel")
    Engine.unregister_singleton("NokoPrompt")
