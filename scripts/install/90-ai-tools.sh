#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

log_step "Installing Claude CLI"

volta install @anthropic-ai/claude-code@latest
zsh -i -c 'which claude && claude --version'

log_step "Installing OpenCode"

volta install opencode-ai@latest
zsh -i -c 'which opencode && opencode --version'

log_step "Installing Codex CLI"

volta install @openai/codex@latest
zsh -i -c 'which codex && codex --version'
