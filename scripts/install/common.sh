#!/usr/bin/env bash

set -euo pipefail

log_step() {
    printf '[agentbox-install] %s\n' "$*"
}

append_if_missing() {
    local line="$1"
    local file="$2"

    touch "$file"
    if ! grep -Fqx "$line" "$file"; then
        printf '%s\n' "$line" >> "$file"
    fi
}
