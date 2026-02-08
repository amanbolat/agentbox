#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

log_step "Installing global Node.js packages"

volta install \
    typescript \
    ts-node \
    eslint \
    prettier \
    nodemon \
    yarn \
    pnpm
