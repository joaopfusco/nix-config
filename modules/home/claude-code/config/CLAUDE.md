# Global instructions

Me **global** Claude Code config (dotfiles, symlink to `~/.claude`). Keep generic —
fit every repo. Repo-specific fact (version, layout, build/test command) belong in
that repo own `.claude/`/`CLAUDE.md`, which override this. When scaffold repo
`.claude/` (e.g. `/init`), keep lean, no copy global rule in — they load
everywhere.

Global skill/command prefix `global-` (skill resolve user-over-project, so prefix
avoid shadow repo or built-in skill). Agent no need it.

## Hooks (`hooks/`)

Blocking PreToolUse hook **escalate to user prompt, never dead-end**. Source shared
`hooks/lib.sh`, call `hook_ask "<reason>"` (emit `permissionDecision: "ask"` — me approve or
deny in UI); save `hook_deny` for thing must truly never happen. No use bare
`exit 2` — it wall Claude no get past even when me allow it. `protect-main.sh` still
fast-path `CLAUDE_ALLOW_MAIN=1` token as silent allow.

## Language

- Reply in **Brazilian Portuguese**.
- Code, identifier, commit message, branch name, config/doc file in **English** —
  unless file already Portuguese, then match it.

## About me

Full-stack / systems engineer, polyglot — stack change per repo, so check, no
assume. Regular: Go, Python, C#/.NET, TypeScript/React, Rust, among other.

- Dev shell often Nix flake (sometime `devenv`/devcontainer) + direnv; run tool inside them.
- Local service/DB via Docker Compose.
- Dotfile (incl. this config) manage via `nix-config` (Nix Flakes + Home Manager).

## How me like work

- Concise, direct. Smallest change solve problem.
- Match existing convention before introduce new one.
- No add dependency without ask; prefer stdlib / lib already present.
- No commit or push unless me ask. Never commit secret.
- Default branch (`main`/`master`) off-limit by default: branch off it. Commit/push
  direct to it **only when me clearly, explicitly authorize that action** — never assume.
- Commit message: English, Conventional Commits, **no `Co-Authored-By` trailer**.
- When dev shell exist, run tooling inside it; no install toolchain globally.
- No reformat wholesale or introduce formatter/linter repo no adopt.
- Ask before big refactor, schema change, or destructive operation.

## Conventions (`~/.claude/rules/`)

Load auto as default (repo override win):
- Always: `code-style.md`, `security.md`.
- Path-scoped (`paths:` frontmatter): `testing.md`, `api-conventions.md`,
  `dev-environments.md`, `languages/*.md`.

## Tooling

- LSP available (pyright, typescript, gopls, csharp, rust-analyzer) — use when present.
- No run formatter by default; follow repo config.