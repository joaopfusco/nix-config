---
description: Scaffold a lean repo-specific .claude/ (.claude/CLAUDE.md + settings + structure)
argument-hint: "[empty | subpath to focus on]"
---

Scaffold **lean, repo-specific** `.claude/` for this project. Focus: **$ARGUMENTS**
(if empty, whole repo). Richer than built-in `/init`: also set up
`.claude/` structure — but stay minimal, never duplicate my global config.

## 1. Analyze the repo (detect, don't assume)

- **Stack / package managers:** `package.json`, `pyproject.toml`/`requirements*.txt`,
  `go.mod`, `Cargo.toml`, `*.csproj`/`*.sln`, etc.
- **Commands:** canonical build / test / lint / run. Read `package.json` scripts,
  `Makefile`, `justfile`, `Taskfile`, `pyproject` (hatch/poe), `go`/`cargo`/`dotnet`
  convention. Cross-check `.github/workflows` for commands CI really run.
- **Dev environment:** `flake.nix` / `devenv.nix` / `.devcontainer` / `.envrc`. If one
  exist, commands must run **inside it** — record that.
- **Architecture:** top-level layout, entry points, key modules/packages, services
  (`compose.yml`), and existing formatter/linter/test framework.
- **Preferred architectures:** if this **FastAPI** or **Django** project, read
  matching note in `~/.claude/references/architectures/` (`fastapi.md` / `django.md`) —
  those describe how me like these structured. Describe repo's *actual* layout in
  CLAUDE.md and flag any deviation from that reference. For greenfield/near-empty repo,
  offer to follow reference (no impose it on established codebase).

## 2. Write a lean `.claude/CLAUDE.md`

Always put project CLAUDE.md **inside `.claude/`** (`./.claude/CLAUDE.md`), never
repo root — Claude Code load both, this keep it beside `.claude/rules/`.
Write file **in English** (it a config/doc file), even though reply to me in
Portuguese — unless repo existing docs in another language, then match them.

Repo-specific fact **only**: what project is, exact build/test/lint/run commands
(inside dev shell when present), architecture map (key dirs + entry points), and
any **deviation** from my global default. No restate rule in
`~/.claude/rules/` — they already load everywhere. If `.claude/CLAUDE.md` already
exist, update in place; no clobber unrelated content. If root `./CLAUDE.md`
exist instead, point it out and ask whether move it into `.claude/` — no
silently relocate or duplicate it.

## 3. Scaffold `.claude/`

- **`.claude/settings.json`** — a **conservative** `permissions.allow` list for this
  project's safe, frequent commands, scoped tight (e.g. `Bash(npm run test:*)`,
  `Bash(go test:*)`, `Bash(cargo build:*)`), plus empty `env` stub for repo-wide
  var. **No hooks, no plugins, nothing personal** — those live in my global config.
- **`.gitignore`** — make sure `.claude/settings.local.json` (my personal override) is
  ignored. Append entry, create `.gitignore` if absent.
- **`.claude/commands/` and `.claude/rules/`** — create these **only if** you have
  concrete repo-specific command or path-scoped rule to put in them right now.
  Otherwise no make empty dir; just list them as optional next step.

## 4. Confirm before writing

Show short plan first: files you'll create/update and exact
`permissions.allow` entry (permissions security-relevant — me review them). Only
write after me confirm.

Respond in Brazilian Portuguese.