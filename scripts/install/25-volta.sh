#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

log_step "Installing Volta"

curl -fsSL https://get.volta.sh | bash

append_if_missing 'export VOLTA_HOME="$HOME/.volta"' "$HOME/.bashrc"
append_if_missing 'export PATH="$VOLTA_HOME/bin:$PATH"' "$HOME/.bashrc"
append_if_missing 'export VOLTA_HOME="$HOME/.volta"' "$HOME/.zshrc"
append_if_missing 'export PATH="$VOLTA_HOME/bin:$PATH"' "$HOME/.zshrc"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

log_step "Installing Node.js LTS via Volta"

volta install node@lts
node --version
volta --version
