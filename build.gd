# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

extends SceneTree

func add_dir_to_zip(packer: ZIPPacker, src_dir: String, zip_subpath: String) -> void:
    var dir := DirAccess.open(src_dir)

    if dir == null:
        push_warning("Directory error: " + src_dir)
        return
    dir.list_dir_begin()

    var name := dir.get_next()
    while name != "":
        if name.begins_with("."):
            name = dir.get_next()
            continue

        var abs_path = src_dir.path_join(name)
        var rel_path = zip_subpath + "/" + name

        if dir.current_is_dir():
            dir.make_dir_recursive(abs_path)
            add_dir_to_zip(packer, abs_path, rel_path)
        else:
            add_file_to_zip(packer, abs_path, rel_path)
        name = dir.get_next()
    dir.list_dir_end()

func add_file_to_zip(packer: ZIPPacker, src_path: String, zip_path: String) -> void:
    var file := FileAccess.open(src_path, FileAccess.READ)
    if file == null:
        push_warning("File error: " + src_path)
        return

    var data: PackedByteArray = file.get_buffer(file.get_length())
    file.close()

    packer.start_file(zip_path)
    packer.write_file(data)
    packer.close_file()

func _init():
    var packer := ZIPPacker.new()
    var outputFile = "dist/noko-v0.0.1.zip"

    if FileAccess.file_exists(outputFile):
        var remErr = DirAccess.remove_absolute(outputFile)
        if remErr != OK:
            push_error("Failed to delete file '"
                + outputFile
                + "': "
                + str(remErr)
            )

    var dirErr = DirAccess.make_dir_recursive_absolute("dist")
    if dirErr != OK:
        push_error("Failed to create output folder: " + str(dirErr))

    var err := packer.open(outputFile)
    if err != OK:
        push_error("Zip error: " + str(err))
        return

    var extras = ["res://LICENSE", "res://plugin.cfg", "res://plugin.gd"]
    for file_path in extras:
        if FileAccess.file_exists(file_path):
            add_file_to_zip(packer, file_path, file_path.get_file())
        else:
            push_warning("File error: " + file_path)

    add_dir_to_zip(packer, "res://modules", "modules")
    packer.close()

    quit()
