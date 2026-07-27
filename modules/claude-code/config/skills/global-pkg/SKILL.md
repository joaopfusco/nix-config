---
name: global-pkg
description: Install, update, remove/uninstall, or list apps/packages on this machine. Orchestrates the system's package managers (apt, snap, flatpak, nix, brew, …) by a configurable hierarchy; suggests commands and waits for confirmation, never runs on its own.
---
# Universal package manager

Orchestrate machine's package managers install/update/remove software by user's hierarchy. **Suggest, never auto-run**: present command(s), wait confirm before run anything — especially `sudo`.

## Paths

- **Config** (versioned): `~/.claude/skills/global-pkg/config.md` — hierarchy + TTL. Read every run.
- **State** (per-machine, not git): `~/.local/state/global-pkg/` — `environment.json`
  (OS + managers) and `installs.jsonl` (one receipt per install). Create if missing.

## Every run

Read `config.md`. Load `environment.json`; missing → run detection once (below).

## Commands

| Command | Aliases | Does |
|---|---|---|
| `install <app>` | add, get | Suggest install per hierarchy. |
| `remove <app>` | uninstall, delete | Reverse install from its receipt. |
| `update [<app>]` | upgrade, check | Check/upgrade out-of-band installs (all if no app). |
| `list` | ls, status | List installs from `installs.jsonl`. |
| `info <app>` | show | Print app's receipt. |
| `re-detect` | rescan | Re-run detection, overwrite `environment.json`. |

Modifier `refresh`/`force` (any command): ignore cached receipt, re-research scratch. Unknown verb → ask, no guess.

## Environment detection

Read `/etc/os-release` for distro+version; probe which managers exist (`apt`, `dnf`,
`pacman`, `zypper`, `apk`, `snap`, `flatpak`, `nix`, `brew`, `cargo`, `pipx`, `npm`).
Record only present ones, with `detected_at`. Re-run only on `re-detect`.

## Install

1. Pick method, walk `config.md`'s hierarchy (default: ① official dev/docs →
   ② native manager → ③ others), skip tier whose manager absent.
2. Research (`WebSearch`) only if unsure — method may change, niche app, or
   `refresh`. Never trust stale guess for tier ①.
3. Reuse receipt within TTL unless `refresh`.
4. Present methods via selection prompt (below); run only chosen command;
   append receipt on success.

## Presenting choices

Ask with normal selection prompt (`AskUserQuestion` tool), **not** text menu —
one single-select question, pick one keystroke, see recommendation.

- **Header**: verb (`Install`, `Remove`, `Update`).
- **Question**: `📦 <app> — how should I <verb> it?` State source (`cache <date>` or
  `researched`) and that **Other** lets pick refresh research, name manager not listed, or cancel.
- **Options** (2–4), order by hierarchy:
  - First option = primary method, `label` end **(Recommended)**.
  - Each option: short `label` (manager/tier), one-line `description` (trade-off — update path, upstream freshness, `sudo`/repo/script side effects), and
    `preview` hold **exact command(s)** plus `Side effects:` line.
- Select option **is** confirm: run exact that command, nothing else,
  then append receipt. Never run before select.
- Only one real method → still ask, pair with **Cancel** option; no fabricate
  alternative.
- Official install script (`curl | sh`) or need `sudo` fine — record as
  `script` side effect so removal can undo it. No deprioritize it.
- For `remove`, recommended option = reversal plan; `preview` lists
  uninstall command plus each side effect undone.

Preview body of option, e.g.:

```
sudo apt install ripgrep

Side effects: none
```

## Remove

1. Find app in `installs.jsonl`, recover how installed.
2. Present reversal plan: uninstall command (prefer `purge`), plus each recorded
   side effect reversed (apt source, GPG key, added repo). Leftover user config
   (`~/.config/<app>`) removed **only with confirm** — never delete data silent.
3. No receipt (installed by hand) → say so, fall back to owning manager; no
   claim complete reversal.
4. Drop receipt after removal.

## Receipt schema (`installs.jsonl`, one object per line)

```json
{"app":"ripgrep","method":"apt","command":"sudo apt install ripgrep","tier":2,
 "installed_at":"2026-06-30T14:00:00Z","side_effects":[],"notes":""}
```

`side_effects[].type`: `apt_source`, `gpg_key`, `repo`, `script`, `config_dir`.