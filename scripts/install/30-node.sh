#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

log_step "Installing nvm and Node.js LTS"

nvm_version="$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')"
echo "Installing nvm version ${nvm_version}"

curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${nvm_version}/install.sh" | bash

source "${NVM_DIR}/nvm.sh"
nvm install --lts
nvm alias default node
nvm use default

append_if_missing 'export NVM_DIR="$HOME/.nvm"' "$HOME/.bashrc"
append_if_missing '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' "$HOME/.bashrc"
append_if_missing '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' "$HOME/.bashrc"

log_step "Installing global Node.js packages"

npm install -g \
    typescript \
    @types/node \
    ts-node \
    eslint \
    prettier \
    nodemon \
    yarn \
    pnpm
