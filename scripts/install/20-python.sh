#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

log_step "Installing uv"

curl -LsSf https://astral.sh/uv/install.sh | sh

append_if_missing 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"
append_if_missing 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"

log_step "Installing Python tooling via uv"

"$HOME/.local/bin/uv" tool install black
"$HOME/.local/bin/uv" tool install ruff
"$HOME/.local/bin/uv" tool install mypy
"$HOME/.local/bin/uv" tool install pytest
"$HOME/.local/bin/uv" tool install ipython
