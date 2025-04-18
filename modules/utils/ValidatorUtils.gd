# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

class_name ValidatorUtils

static func is_valid_sha256(digest: String) -> bool:
    if digest.length() != 64:
        return false

    var regex := RegEx.new()
    if regex.compile("^[0-9A-Fa-f]{64}$") != OK:
        return false

    return regex.search(digest) != null
