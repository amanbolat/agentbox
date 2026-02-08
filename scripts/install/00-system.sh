#!/usr/bin/env bash

set -euo pipefail

source /tmp/install/common.sh

log_step "Installing base system dependencies"

rm -f /etc/apt/apt.conf.d/docker-clean
cat > /etc/apt/apt.conf.d/keep-cache <<'EOF'
Binary::apt::APT::Keep-Downloaded-Packages "true";
EOF

apt-get update
apt-get install -y --no-install-recommends \
    ca-certificates curl wget gnupg lsb-release sudo \
    git vim nano tmux htop tree direnv \
    build-essential gcc g++ make cmake pkg-config \
    zsh bash-completion locales \
    openssh-client netcat-openbsd socat dnsutils iputils-ping \
    zip unzip tar gzip bzip2 xz-utils \
    jq yq \
    procps psmisc \
    python3-dev python3-pip python3-venv \
    libssl-dev libffi-dev \
    ripgrep fd-find

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen

apt-get clean
rm -rf /var/lib/apt/lists/*
