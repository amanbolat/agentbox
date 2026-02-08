# Repository Guidelines

## Project Structure & Module Organization
AgentBox is intentionally small and centered on three runtime files:
- `agentbox`: main Bash CLI (argument parsing, rebuild checks, container run logic).
- `Dockerfile`: unified development image (Claude/OpenCode, language toolchains, utilities).
- `entrypoint.sh`: container bootstrap (PATH/env setup, optional Python venv creation, startup banner).

Supporting paths:
- `docs/prompts/add-tool.md`: workflow for adding support for new CLI agents.
- `.github/workflows/`: GitHub Actions for Claude automation and PR review.
- `media/`: logos and branding assets.

## Build, Test, and Development Commands
- `chmod +x agentbox`: make the launcher executable.
- `./agentbox --help`: view CLI options and usage without starting Docker.
- `./agentbox`: start Claude Code in the container for the current project.
- `./agentbox --tool opencode`: run OpenCode instead of Claude.
- `./agentbox shell`: open an interactive shell in the container.
- `./agentbox --rebuild`: force image rebuild after Dockerfile/entrypoint changes.
- `./agentbox ssh-init`: create isolated SSH keys under `~/.agentbox/ssh/`.

## Coding Style & Naming Conventions
- Target Bash 4+ and keep strict mode (`set -euo pipefail`) in scripts.
- Use 4-space indentation; prefer clear, short functions over deep nesting.
- Use `snake_case` for functions and local vars; reserve `UPPER_SNAKE_CASE` for readonly globals/constants.
- Quote variable expansions unless intentional word splitting is required.
- Keep comments minimal and purposeful (explain non-obvious “why,” not obvious “what”).

## Testing Guidelines
There is no formal automated test suite in this repository today; use smoke tests for changes:
- `bash -n agentbox entrypoint.sh` for syntax validation.
- `./agentbox --help` for CLI parsing checks.
- For runtime changes, verify at least one container start path (for example `./agentbox shell`) and any touched flags (`--add-dir`, `--tool`, `--ignore-dot-env`).

## Commit & Pull Request Guidelines
- Follow concise, imperative commit messages. History uses both plain imperative style and Conventional Commit prefixes (for example `feat:`, `fix:`, `refactor:`).
- Keep commits focused and atomic; avoid mixing refactors with behavior changes.
- PRs should include: problem statement, summary of behavioral changes, manual test steps/outputs, and documentation updates when flags or workflows change.
- Link related issues and call out breaking changes explicitly.
