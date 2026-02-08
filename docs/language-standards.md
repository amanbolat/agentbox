# Language Standards

This document defines how AgentBox adds and maintains language toolchains.

## Core Rules

- Always install the latest stable release for language runtimes and tooling.
- Every language must include a version manager (for example `uv`, `nvm`, `sdkman`, `gobrew`, `rustup`).
- Keep language-specific install logic in a dedicated script under `scripts/install/`.
- Use official docs as the source of truth and keep references in `extdocs/index.csv`.
- Do not add CI gates for language policy; use the manual checklist in this document.

## Current Baseline (As Implemented)

- Python: `uv` for environment/package management and Python CLI tools.
- Node.js: `nvm` for version selection; npm globals for JS tooling.
- Java: `sdkman` for JDK/Gradle version management.
- Go: `gobrew` for stable version selection and switching.
- Shell: Bash/Zsh plus common utilities.

## Language Profiles

### Go

- Version manager: `gobrew` (required).
- Runtime policy: install latest stable Go through version-manager workflow.
- Default global tools: keep minimal; do not preinstall `golangci-lint` globally.
- Project-level guidance: teams may add `golangci-lint` in project config/tooling.
- Validation commands:
  - `gobrew --version`
  - `go version`
  - `go test ./...` (run in a Go project)

### Rust (Next Target)

- Version manager: `rustup` (required).
- Runtime policy: install latest stable toolchain.
- Validation commands:
  - `rustup --version`
  - `rustc --version`
  - `cargo --version`

## Required Implementation Pattern

- Add one install script per language, ordered in `scripts/install/` (for example `60-go.sh`, `70-rust.sh`).
- Keep shared helpers in `scripts/install/common.sh`.
- Wire new scripts from `Dockerfile` in deterministic order.
- Update `README.md` language/tooling docs when a language is added.

## Manual Validation Checklist (No CI)

1. Rebuild: `./agentbox --rebuild`.
2. Confirm manager and runtime versions print correctly.
3. Run a minimal language sanity command in a sample project (for example build/test).
4. Confirm no regression for existing toolchains (Python, Node.js, Java, Go).
5. Update documentation if command output or workflows changed.
