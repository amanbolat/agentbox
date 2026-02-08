#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

log_step "Installing Claude CLI"

curl -fsSL https://claude.ai/install.sh | bash -s stable
zsh -i -c 'which claude && claude --version'

log_step "Installing OpenCode"

curl -fsSL https://opencode.ai/install | bash
zsh -i -c 'which opencode && opencode --version'

log_step "Installing Codex CLI"

source "${NVM_DIR}/nvm.sh"
nvm use default >/dev/null
npm install -g @openai/codex@latest
zsh -i -c 'which codex && codex --version'
