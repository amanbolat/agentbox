![AgentBox Logo](media/logo-image-only-150.png)

# AgentBox

A Docker-based development environment for running agentic coding tools in a more safe, isolated fashion. This makes it less dangerous to give your agent full permissions (YOLO mode / `--dangerously-skip-permissions`), which is, in my opinion, the only way to use AI agents.

## Fork Origin

This repository is a fork of [`fletchgqc/agentbox`](https://github.com/fletchgqc/agentbox) and continues development with project-specific changes.

## Features

- **Shares project directory with host**: Maps a volume with the source code so that you can see and modify the agent's changes on the host machine - just like if you were running your tool without a container.
- **Multi-Tool Support**: All agentic coding tools are supported, some built-in, others [via prompt](#adding-tools).
- **Language Workflow**: Language additions follow standards and prompts (`docs/language-standards.md`, `docs/prompts/add-language.md`).
- **Unified Development Environment**: Single Docker image with optional language toolchains and a mandatory Volta baseline for AI tools
- **Isolated SSH**: Dedicated SSH directory for secure Git operations
- **Low-Maintenance Philosophy**: Always uses latest LTS tool versions, rebuilds container automatically when necessary

## Requirements

- **Docker**: Must be installed and running
- **Bash 4.0+**: macOS ships with Bash 3.2, I recommend upgrading via Homebrew (`brew install bash`).

## Installation and Quick Start

1. Clone AgentBox to your preferred location (e.g. `~/code/agentbox/agentbox`)
2. Ensure Docker is installed and running
3. Make the script executable: `chmod +x agentbox`
4. (Strongly recommended) add an alias for global access - e.g. alias `agentbox` to `~/code/agentbox/agentbox`.
5. Run `agentbox` from your desired working directory (wherever you would normally start your agentic coding tool).

## CLI Agent Support

- claude code: built-in
- opencode: built-in
- codex cli: built-in
- any other agents (copilot CLI, Aider, Cursor CLI...): easily add it yourself using the prompt at [docs/prompts/add-tool.md](docs/prompts/add-tool.md).

### Adding tools

Start your coding agent in the agentbox directory and issue this (example) prompt:
> Add support for Copilot CLI to this project using the instructions at @docs/prompts/add-tool.md.

Then you can go to your project directory and run (e.g.) `agentbox --tool copilot`. Thanks to [Felix Medam](https://github.com/SputnikTea) for this very cool idea.

### Adding languages

Language additions are standardized:

- Rules and baseline profiles: `docs/language-standards.md`
- Prompt workflow: `docs/prompts/add-language.md`

Current policy is:

- Always use latest stable versions.
- Always include a version manager for each language.
- Validate changes with a manual checklist (no CI language policy gates).
- Language toolchains are optional via `--languages` / `AGENTBOX_LANGUAGES` / `~/.agentbox/config.toml`.
- Volta + Node.js runtime remain mandatory baseline for AI tools.

## Helpful Commands

```bash
# Start Claude CLI in container (--dangerously-skip-permissions is automatically included)
agentbox

# Use OpenCode instead of Claude
agentbox --tool opencode

# Use Codex CLI in YOLO mode
agentbox --tool codex

# Or set via environment variable
AGENTBOX_TOOL=codex agentbox

# Choose optional language toolchains for this build profile
agentbox --languages python,node

# Build baseline image (AI tools only, no optional language toolchains)
agentbox --languages none

# Set language profile via environment variable
AGENTBOX_LANGUAGES=python,node agentbox

# Show available commands
agentbox --help

# Non-agentbox CLI flags are passed through to the selected tool.
# For example, to continue the most recent session
agentbox -c

# Mount additional directories for multi-project access
agentbox --add-dir ~/proj1 --add-dir ~/proj2

# Start shell with sudo privileges
agentbox shell --admin

# Set up SSH keys for AgentBox
agentbox ssh-init
```

**Note**: Tool selection via `--tool` flag takes precedence over the `AGENTBOX_TOOL` environment variable.

## Language Profiles and Config

AgentBox supports optional language toolchains using a comma-separated list:

- Supported values: `python,node,java,go`
- Special value: `none`

Resolution order:

1. `--languages ...`
2. `AGENTBOX_LANGUAGES`
3. `~/.agentbox/config.toml`
4. Built-in default (`python,node,java,go`)

On first run, AgentBox auto-creates `~/.agentbox/config.toml` with defaults:

```toml
languages = ["python", "node", "java", "go"]
```

`node` controls optional Node.js developer extras (`typescript`, `eslint`, `prettier`, `yarn`, `pnpm`, etc.).
Node.js runtime itself remains available via Volta because built-in AI tools depend on it.

## How It Works

AgentBox creates ephemeral Docker containers (with `--rm`) that are automatically removed when you exit. However, important data persists between sessions:

```
Single Dockerfile → Build once → agentbox:latest image
                                         ↓
                    ┌────────────────────┼────────────────────┐
                    ↓                    ↓                    ↓
          Container: project1    Container: project2    Container: project3
          (ephemeral, --rm)      (ephemeral, --rm)      (ephemeral, --rm)
          Mounts: ~/code/api    Mounts: ~/code/web     Mounts: ~/code/cli

Persistent data (survives container removal):
  Cache: ~/.cache/agentbox/agentbox-<hash>/
  History: ~/.agentbox/projects/agentbox-<hash>/history/
  Claude: ~/.claude
  OpenCode: ~/.config/opencode and ~/.local/share/opencode
  Codex: ~/.codex
```

## Languages and Tools

The unified Docker image includes:

- **Python**: Latest version with `uv` for package management and Python CLI tooling (`black`, `ruff`, `mypy`, `pytest`, `ipython`)
- **Node.js Runtime**: Latest LTS via Volta (mandatory baseline)
- **Node.js Extras**: Optional via `node` profile value (`typescript`, `ts-node`, `eslint`, `prettier`, `nodemon`, `yarn`, `pnpm`)
- **Java**: Latest LTS via SDKMAN with Gradle
- **Go**: Latest stable via Gobrew for version management and switching
- **Shell**: Zsh (default) and Bash with common utilities
- **Claude CLI**: Pre-installed via Volta with per-project authentication
- **OpenCode**: Pre-installed via Volta as an alternative AI coding tool
- **Codex CLI**: Pre-installed via Volta as an alternative AI coding tool

## Authenticating to Git or other SCC Providers

### GitHub
The `gh` tool is included in the image and can be used for all GitHub operations. My recommendation:
- Visit this link to configure a [fine-grained access-token](https://github.com/settings/personal-access-tokens/new?name=MyRepo-AI&description=For%20AI%20Agent%20Usage&contents=write&pull_requests=write&issues=write) with a sensible set of permissions predefined.
- On that page, restrict the token to the project repository.
- Create a .env file at the root of your project repository with entry `GH_TOKEN=<token>`
- Add instructions to your repository agent guidance (for example `AGENTS.md`) to prefer the `gh` tool for GitHub operations when using access tokens.

You or your agent should convert ssh git remotes to https, ssh remotes don't work with tokens.

### GitLab
 The `glab` tool is included in the image. You can use it with a GitLab token for API operations, but not for git operations as far as I know. So for GitLab I recommend the SSH configuration detailed below.

## Git Configuration

AgentBox copies your host `~/.gitconfig` into the container on each startup. If you don't have a host gitconfig, it uses `agent@agentbox` as the default identity.

## SSH Configuration

AgentBox uses a dedicated SSH directory (`~/.agentbox/ssh/`) isolated from your main SSH keys:

```bash
# Initialize SSH for AgentBox
agentbox ssh-init
```

This will:
1. Create ~/.agentbox/ssh/ directory
2. Copy your known_hosts for host verification
3. Generate a new Ed25519 key pair (if preferred, delete them and manually place your desired SSH keys in `~/.agentbox/ssh/`).

This SSH setup is for Git/remote authentication from inside the container. AgentBox does not run an SSH server for shell login.

### Accessing the Current Project Container

Container names are deterministic per project path:

```bash
container_name="agentbox-$(echo -n "$PWD" | sha256sum | cut -c1-12)"
docker ps --filter "name=^/${container_name}$" --format "table {{.Names}}\t{{.Status}}"
```

If running, attach a shell directly:

```bash
docker exec -it -w "$PWD" "$container_name" zsh
```

If a container with that name is already running, `agentbox shell` now auto-attaches to it for the current project.
Non-shell flows (`agentbox`, `agentbox --tool ...`) still start a new container and can fail if that project container name is already in use.

### Environment Variables
Environment variables are loaded from `.env` files in this order (later overrides earlier):
1. `~/.agentbox/.env` (global)
2. `<project-dir>/.env` (project-specific)

AgentBox includes `direnv` support - `.envrc` files are evaluated if `direnv allow`ed on the host.

## MCP Server Configuration

Due to [Claude Code bug #6130](https://github.com/anthropics/claude-code/issues/6130), by default you won't be prompted to enable MCP servers when running `agentbox` directly.

**Workaround options:**

1. **Enable individual MCP servers interactively:**
   ```bash
   agentbox shell
   claude
   ```

2. **Enable all MCP servers by default** by adding `"enableAllProjectMcpServers": true` to your Claude project or user settings.

## Data Persistence

### Package Caches
Package manager caches are stored in `~/.cache/agentbox/<container-name>/`:
- npm packages: `~/.cache/agentbox/<container-name>/npm`
- pip packages: `~/.cache/agentbox/<container-name>/pip`
- Maven artifacts: `~/.cache/agentbox/<container-name>/maven`
- Gradle cache: `~/.cache/agentbox/<container-name>/gradle`
- Go build cache: `~/.cache/agentbox/<container-name>/go-build`
- Go module cache: `~/.cache/agentbox/<container-name>/go-mod`

### Shell History
Zsh history is preserved in `~/.agentbox/projects/<container-name>/history`

### Tool Authentication

Built-in tools use bind mounts to share authentication across all AgentBox projects:

**Claude CLI**:
- `~/.claude` mounted at `/home/agent/.claude`

**OpenCode**:
- Config: `~/.config/opencode` mounted at `/home/agent/.config/opencode`
- Auth: `~/.local/share/opencode` mounted at `/home/agent/.local/share/opencode`

**Codex CLI**:
- Config/Auth: `~/.codex` mounted at `/home/agent/.codex`

## Advanced Usage

### Running One-Off Commands
If you need to run a single command in the containerized environment without starting Claude CLI or an interactive shell:

```bash
# Run any command
agentbox npm test
```

### Rebuild Control
```bash
# Force rebuild the Docker image
agentbox --rebuild
```

The image automatically rebuilds when:
- Dockerfile or entrypoint.sh changes
- Language profile changes (`--languages`, `AGENTBOX_LANGUAGES`, or config)

## Tool / Dependency Versions
The Dockerfile is configured to pull the latest stable version of each tool (Volta, GitLab CLI, etc.) during the build process. Installation logic is split into `scripts/install/*.sh`, while the Dockerfile orchestrates stage order and caching. This makes maintenance easier and keeps language/tool additions localized.

Rebuilding the Docker image may automatically result in newer versions of tools being installed, which could introduce unexpected behavior or breaking changes. If you require specific tool versions, consider pinning them in the install scripts.

For language additions, follow `docs/language-standards.md` and run the manual validation checklist after each change.

## Alternatives
### Anthropic DevContainer
Anthropic offers a [devcontainer](https://github.com/anthropics/claude-code/tree/main/.devcontainer) which achieves a similar goal. If you like devcontainers, that's a good option. Unfortunately, I find that devcontainers sometimes have weird bugs, problematic support in IntelliJ/Mac, or they are just more cumbersome to use (try switching to a recent project with a shortcut, for example). I don't want to force people to use a devcontainer if what they really want is safe YOLO-mode isolation - the simpler solution to the problem is just Docker, hence, this project.

### Comparison with ClaudeBox
AgentBox began as a simplified replacement for [ClaudeBox](https://github.com/RchGrav/claudebox). I liked the ClaudeBox project, but its complexity caused a lot of bugs and I found myself maintaning my own fork with my not-yet-merged PRs. It became easier for me to build something leaner for my own needs. Comparison:

| Feature | AgentBox | ClaudeBox |
|---------|----------|-----------|
| Files | 3 core files | 20+ files |
| Profiles | Single unified image | 20+ language profiles |
| Container Management | Simple per-project | Advanced slot system |
| Setup | Automatic | Manual configuration |

## Support and Contributing
I make no guarantee to support this project in the future, however the history is positive: I've actively supported it since September 2025. Feel free to create issues and submit PRs. The project is designed to be understandable enough that if you need specific custom changes which we don't want centrally, you can fork or just make them locally for yourself.

If you do contribute, consider that AgentBox is designed to be simple and maintainable. The value of new features will always be weighed against the added complexity. Try to find the simplest possible way to get things done and control the AI's desire to write such bloated doco.

## License

This project is licensed under the Apache License 2.0. See `LICENSE`.

As a fork, it preserves upstream attribution to [`fletchgqc/agentbox`](https://github.com/fletchgqc/agentbox) and applies Apache-2.0 terms to ongoing modifications in this repository.
