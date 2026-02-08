#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

log_step "Installing GitHub CLI"

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
chmod 644 /usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list

apt-get update
apt-get install -y gh
apt-get clean
rm -rf /var/lib/apt/lists/*

log_step "Installing GitLab CLI"

arch="$(dpkg --print-architecture)"
glab_version="$(curl -sL "https://gitlab.com/api/v4/projects/34675721/releases/permalink/latest" | sed -n 's/.*"tag_name":"v\?\([^"]*\)".*/\1/p')"

echo "Installing glab version ${glab_version} for ${arch}"
curl -fsSL -o /tmp/glab.deb \
    "https://gitlab.com/gitlab-org/cli/-/releases/v${glab_version}/downloads/glab_${glab_version}_linux_${arch}.deb"

if ! dpkg -i /tmp/glab.deb; then
    apt-get update
    apt-get install -f -y
fi

rm /tmp/glab.deb
glab --version

apt-get clean
rm -rf /var/lib/apt/lists/*
