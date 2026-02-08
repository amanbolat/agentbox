#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

log_step "Installing and configuring oh-my-zsh"

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

sed -i 's/ZSH_THEME=".*"/ZSH_THEME="robbyrussell"/' "$HOME/.zshrc"

append_if_missing 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"
append_if_missing 'export VOLTA_HOME="$HOME/.volta"' "$HOME/.zshrc"
append_if_missing 'export PATH="$VOLTA_HOME/bin:$PATH"' "$HOME/.zshrc"

append_if_missing 'eval "$(direnv hook bash)"' "$HOME/.bashrc"
append_if_missing 'eval "$(direnv hook zsh)"' "$HOME/.zshrc"

if ! grep -Fq "# AgentBox terminal size handling" "$HOME/.zshrc"; then
    cat >> "$HOME/.zshrc" <<'EOF'

# AgentBox terminal size handling
if [[ -n "$PS1" ]] && command -v stty >/dev/null; then
  function _update_size {
    local rows cols
    { stty size } 2>/dev/null | read rows cols
    ((rows)) && export LINES=$rows COLUMNS=$cols
  }
  TRAPWINCH() { _update_size }
  _update_size
fi
EOF
fi

log_step "Applying git and tmux defaults"

git config --global init.defaultBranch main
git config --global pull.rebase false

cat > "$HOME/.tmux.conf" <<'EOF'
# Enable mouse support
set -g mouse on

# Better colors
set -g default-terminal "screen-256color"
set -ga terminal-overrides ",xterm-256color:Tc"

# Increase history
set -g history-limit 50000

# Better window/pane management
bind | split-window -h
bind - split-window -v
unbind '"'
unbind %

# Reload config
bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"

# Status bar
set -g status-bg black
set -g status-fg white
set -g status-left '#[fg=green]#H '
set -g status-right '#[fg=yellow]%Y-%m-%d %H:%M'
EOF
