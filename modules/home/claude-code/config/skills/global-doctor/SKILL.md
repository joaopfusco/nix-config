---
name: global-doctor
description: Diagnose a broken local dev environment — tools not found, wrong shell, services won't connect, "works for someone else but not me". Checks direnv/Nix/devenv/devcontainer, toolchain resolution, and Docker Compose.
---
# Dev environment doctor

Diagnose why repo local env no work. **Read-only**: investigate and report; propose fix but no apply without ask.

## Procedure

Detect what repo use, run only relevant check. No assume stack.

1. **Shell / direnv**
   - `.envrc` exist? direnv installed (`direnv version`) and **allowed** (`direnv status`)? Blocked/!allowed `.envrc` mean env never load.
   - Confirm expected env actually applied (e.g. project bin on `PATH`).
2. **Reproducible shell**
   - **Nix**: `flake.nix` present? `nix flake check` / `nix develop -c true` work?
     `flake.lock` committed and current?
   - **devenv**: `devenv.nix` present? `devenv version`; `devenv shell -- true` work?
   - **devcontainer**: `.devcontainer/` present? Note if user inside it or not.
3. **Toolchain resolution**
   - For repo languages, check tool resolve and version match project expect
     (`go version`, `python --version`, `dotnet --info`,
     `node --version`, `cargo --version`, etc.). Flag host-vs-shell mismatch.
4. **Services (Docker Compose)**
   - `compose.yml` / `docker-compose*.yml` exist? Daemon up
     (`docker info`)? `docker compose ps` — which service up/exited/unhealthy?
   - Service no connect → check `docker compose logs <svc>` and published port.
5. **Env files**
   - Required `.env` missing while only `.env.example` exist? No print
     secret value — just report missing key.

## Output

Short report group as **Broken** (blocking) / **Warning** / **OK**. Each
problem: what wrong, evidence (command output), exact fix command.
End with single most likely root cause. Ask before change anything.