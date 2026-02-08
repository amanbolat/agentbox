#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

log_step "Installing SDKMAN and Java tooling"

curl -s "https://get.sdkman.io?rcupdate=false" | bash

append_if_missing 'source "$HOME/.sdkman/bin/sdkman-init.sh"' "$HOME/.bashrc"
append_if_missing 'source "$HOME/.sdkman/bin/sdkman-init.sh"' "$HOME/.zshrc"

# sdkman init script is not fully compatible with nounset; scope-disable it.
set +u
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java 21.0.9-tem
sdk install gradle
set -u
