# Adding a New Language to AgentBox

Use this guide when adding a language runtime/toolchain (for example Go, Rust) to AgentBox.

## Non-Negotiable Rules

1. Use latest stable versions from official sources.
2. Include a version manager for the language.
3. Keep install logic in dedicated `scripts/install/<order>-<language>.sh`.
4. Update documentation (`README.md` and `docs/language-standards.md`).
5. Follow manual validation checklist only (no CI policy changes).

## Phase 1: Research

Collect and cite from official docs:

1. Version manager and install method.
2. Runtime install/selection commands.
3. Version commands for manager and runtime.
4. Recommended baseline formatter/linter/test commands.
5. Any shell/profile setup requirements.

If a requirement is not documented, do not guess. Ask the user for direction.

## Phase 2: Implementation

### A) Install Scripts

- Add a new script in `scripts/install/` with strict mode (`set -euo pipefail`).
- Use helpers from `scripts/install/common.sh` where possible.
- Keep the script focused on one language only.

### B) Dockerfile

- Wire the new script in `Dockerfile` in execution order.
- Keep existing cache-busting and layering behavior unchanged unless necessary.

### C) Documentation

- Update `docs/language-standards.md` with the new language profile.
- Update `README.md` language/tooling sections.

## Phase 3: Manual Verification (Required)

Run these checks and include outputs in your summary:

1. `./agentbox --rebuild`
2. Manager version command (for example `gobrew --version`, `rustup --version`)
3. Runtime version command (for example `go version`, `rustc --version`)
4. Minimal language sanity check in a sample project

## Language-Specific Direction

- Go is a built-in baseline language and must use `gobrew`.
- Keep `golangci-lint` as project-level setup, not a globally preinstalled tool.
- Rust is the next target after Go and must use `rustup`.
