#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

log_step "Installing gobrew"

curl -sL https://raw.githubusercontent.com/kevincobain2000/gobrew/master/git.io.sh | bash

append_if_missing 'export PATH="$HOME/.gobrew/current/bin:$HOME/.gobrew/bin:$PATH"' "$HOME/.bashrc"
append_if_missing 'export PATH="$HOME/.gobrew/current/bin:$HOME/.gobrew/bin:$PATH"' "$HOME/.zshrc"

export PATH="$HOME/.gobrew/current/bin:$HOME/.gobrew/bin:$PATH"

log_step "Installing latest stable Go via gobrew"

gobrew version
gobrew use latest
go version
