# AgentBox - Simplified multi-language development environment for Claude
FROM debian:trixie

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

# Copy install scripts
COPY scripts/install /tmp/install
RUN chmod +x /tmp/install/*.sh

# Install system dependencies and essential tools
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    /tmp/install/00-system.sh

RUN /tmp/install/10-vcs-clis.sh

# Create non-root user
ARG USER_ID=1000
ARG GROUP_ID=1000
ARG USERNAME=agent

RUN groupadd -g ${GROUP_ID} ${USERNAME} || true && \
    useradd -m -u ${USER_ID} -g ${GROUP_ID} -s /bin/zsh ${USERNAME} && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME}

# Switch to user for language installations
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Install user-space language toolchains and shell configuration
ARG ENABLE_PYTHON=1
ARG ENABLE_NODE=1
ARG ENABLE_JAVA=1
ARG ENABLE_GO=1

# Volta + Node.js are mandatory baseline for AI tool installation.
RUN /tmp/install/25-volta.sh
RUN if [ "${ENABLE_PYTHON}" = "1" ]; then /tmp/install/20-python.sh; fi
RUN if [ "${ENABLE_NODE}" = "1" ]; then /tmp/install/30-node.sh; fi
RUN if [ "${ENABLE_JAVA}" = "1" ]; then /tmp/install/40-java.sh; fi
RUN if [ "${ENABLE_GO}" = "1" ]; then /tmp/install/60-go.sh; fi
RUN /tmp/install/50-shell.sh

# Switch back to root for entrypoint setup
USER root

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set the user for runtime
USER ${USERNAME}

# Using BUILD_TIMESTAMP as a build arg that changes on every invocation invalidates
# Docker's cache for this layer and following layers, forcing reinstall even when
# Dockerfile hasn't changed. This ensures fresh installs on explicit rebuilds instead
# of relying on unpredictable auto-update timing.
ARG BUILD_TIMESTAMP=unknown
RUN /tmp/install/90-ai-tools.sh

# Entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/zsh"]
