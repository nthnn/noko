# Copyright 2025 Nathanne Isip
# This file is part of Noko (https://github.com/nthnn/noko)
# This code is licensed under MIT license (see LICENSE for details)

# Utility class for validating string formats and checksums.
class_name ValidatorUtils

# Determines whether the provided string is a valid SHA-256 hex digest.
#
# @param digest (String): The input string to validate as a SHA-256 hash.
# @return (bool): True if the string is exactly 64 hexadecimal characters [0-9A-Fa-f], false otherwise.
static func is_valid_sha256(digest: String) -> bool:
    if digest.length() != 64:
        return false

    var regex := RegEx.new()
    if regex.compile("^[0-9A-Fa-f]{64}$") != OK:
        return false

    return regex.search(digest) != null
