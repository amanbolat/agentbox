# Repository Guidelines

## Project Structure & Module Organization
AgentBox is intentionally small and centered on three runtime files:
- `agentbox`: main Bash CLI (argument parsing, rebuild checks, container run logic).
- `Dockerfile`: unified development image (Claude/OpenCode, language toolchains, utilities).
- `entrypoint.sh`: container bootstrap (PATH/env setup, optional Python venv creation, startup banner).

Supporting paths:
- `docs/prompts/add-tool.md`: workflow for adding support for new CLI agents.
- `docs/prompts/add-language.md`: workflow for adding support for new language toolchains.
- `docs/language-standards.md`: source of truth for language policies and validation checklist.
- `.github/workflows/`: GitHub Actions for Claude automation and PR review.
- `media/`: logos and branding assets.

## Coding Style & Naming Conventions
- Target Bash 4+ and keep strict mode (`set -euo pipefail`) in scripts.
- Use 4-space indentation; prefer clear, short functions over deep nesting.
- Use `snake_case` for functions and local vars; reserve `UPPER_SNAKE_CASE` for readonly globals/constants.
- Quote variable expansions unless intentional word splitting is required.
- Keep comments minimal and purposeful (explain non-obvious “why,” not obvious “what”).

## Commit & Pull Request Guidelines
- Follow concise, imperative commit messages. History uses both plain imperative style and Conventional Commit prefixes (for example `feat:`, `fix:`, `refactor:`).
- Keep commits focused and atomic; avoid mixing refactors with behavior changes.
- PRs should include: problem statement, summary of behavioral changes, manual test steps/outputs, and documentation updates when flags or workflows change.
- Link related issues and call out breaking changes explicitly.

## Documentation & Dependency Freshness
- Always use the latest stable version of libraries/tools and the corresponding official documentation.
- Keep fetched external docs under `extdocs/` and track metadata in `extdocs/index.csv`.
- `extdocs/index.csv` must include, at minimum: `doc_id`, `source_url`, `local_path`, `version_or_tag`, and `fetch_date`.
- Before using docs for implementation, verify freshness with `scripts/sync_extdocs.sh`.
- If `fetch_date` is older than 30 days, re-fetch documentation.
- The freshness check must use the current date from the `date` command.
- Fetch documentation in markdown format via Jina AI Reader API using `curl` (pattern: `https://r.jina.ai/http://...`).

## Language Workflow
- Language additions must follow `docs/language-standards.md` and `docs/prompts/add-language.md`.
- Always install latest stable runtime/tooling and include a language version manager (for example `uv`, `nvm`, `sdkman`, `gobrew`, `rustup`).
- Keep one dedicated install script per language in `scripts/install/`.
- Do not add CI checks for language policy; use the documented manual checklist.
- Go is the first language expansion target and Rust is next.
