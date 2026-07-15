---
name: global-dev-env
description: Scaffold a reproducible dev environment (Nix flake, devenv, or devcontainer) wired with direnv. Use when setting up a repo's toolchain or adding a dev shell.
---
# Dev environment scaffold

Set up reproducible dev shell for repo. Pick approach user prefer (ask if none):

- **Nix flake** — `flake.nix` with `devShells.default` + `.envrc` (`use flake`).
- **devenv** — `devenv.nix` (+ `devenv.yaml`) + `.envrc` (`eval "$(devenv direnvrc)"` then `use devenv`).
- **devcontainer** — `.devcontainer/devcontainer.json` (features or a Dockerfile).

## Steps

1. Confirm approach, detect stack from markers (`go.mod`, `pyproject.toml`,
   `*.csproj`, `package.json`, `Cargo.toml`, …). Ask if ambiguous.
2. Scaffold with tool's initializer (`nix flake init`, `devenv init`, or write
   file direct), then trim to what project need (toolchain, LSP, formatter,
   required service). Pin `nixpkgs`.
3. Wire direnv when relevant: `.envrc` (`use flake`, or for devenv the two lines from
   [devenv specifics](#devenv-specifics) below); tell user run `direnv allow`.
   (`devenv init` write bare `use devenv` — still need `eval` line prepended.)
4. Update `.gitignore` (`.direnv/`, `.devenv/`, artifacts) and commit lockfile.
5. Verify tool resolve inside shell (`nix develop -c <tool> --version`, `devenv
   shell`, or reopen in container).

Keep minimal, specific: dev shell, not production build. No leak build-time
dep into runtime. After add file to Stow package, remind `stow -R <pkg>`.

## devenv specifics

devenv <-> direnv integration **not** loaded globally (it override nix-direnv's
`_nix_direnv_preflight` without set `_nix_direnv_nix`, break `use flake` in plain
Nix project). Wire per-repo instead — `.envrc` must have both line, in order:

```
eval "$(devenv direnvrc)"
use devenv
```

Add `dotenv.disableHint = true` to `devenv.nix`. For Python with compiled dep
(numpy/pandas/…) also set `languages.python.libraries = [ pkgs.stdenv.cc.cc.lib pkgs.zlib ];`.

## devcontainer defaults (editor-agnostic, secure host-bridging)

Use **Zed and VS Code** (mainly Zed), so keep everything at **spec level** — the
devcontainer CLI runs it in both. No lean on VS Code-only magic (gitconfig copy, agent
forwarding, `dotfiles.repository`); Zed no do those, so make explicit. **Zed no
reload on `devcontainer.json` edit** (must kill + recreate container), so scaffold it
**correct first try** — verify prerequisite below before create. Bridge host
nicety **without** mount host secret onto container disk (see
`rules/dev-environments.md` for why).

Prerequisite on host (checked, no assume): SSH agent running with
`SSH_AUTH_SOCK` set (mine: gnome-keyring at `/run/user/1000/keyring/ssh`) — if not, drop
SSH mount + `remoteEnv`. Git identity and Claude config both come from dotfiles via
`stow`, so no host-path bind that could be missing.

```jsonc
{
  "name": "<repo>",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu", // or "build": { "dockerfile": "Dockerfile" }
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "installZsh": true,
      "installOhMyZsh": true,
      "installOhMyZshConfig": false, // don't lay down the stock .zshrc — mine wins (post-create)
      "configureZshAsDefaultShell": true,
      "username": "vscode"
    },
    "ghcr.io/anthropics/devcontainer-features/claude-code:1.0": {}
  },
  "remoteUser": "vscode", // non-root: required for --dangerously-skip-permissions
  "mounts": [
    // SSH agent SOCKET (not ~/.ssh) — explicit, since neither Zed nor the CLI auto-forwards
    "source=${localEnv:SSH_AUTH_SOCK},target=/ssh-agent,type=bind",
    // Claude auth/state persisted per-project — NOT a bind of the host ~/.claude
    "source=claude-code-config-${devcontainerId},target=/home/vscode/.claude,type=volume"
  ],
  "remoteEnv": { "SSH_AUTH_SOCK": "/ssh-agent" },
  "postCreateCommand": "bash .devcontainer/post-create.sh",
  "customizations": {
    "zed": { "extensions": [] },
    "vscode": { "extensions": [] }
  }
}
```

`post-create.sh` — editor-agnostic (VS Code `dotfiles.repository` route won't run in Zed).
Bring in shell, git identity, **and global Claude config** via stow-managed dotfiles,
harden against usual first-run breakage:

```bash
#!/usr/bin/env bash
set -euo pipefail

# Base image lacks these; `jq` is needed by my global Claude hooks, `stow` by my dotfiles.
if ! command -v stow >/dev/null 2>&1 || ! command -v jq >/dev/null 2>&1; then
  sudo apt-get update && sudo apt-get install -y stow jq
fi

# My stow-managed dotfiles: global shell (zsh), git identity, and Claude config.
if [ ! -d "$HOME/.dotfiles" ]; then
  git clone --depth 1 https://github.com/joaopfusco/dotfiles "$HOME/.dotfiles"
fi

# oh-my-zsh custom plugins my .zshrc enables (oh-my-zsh bundles neither).
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"    2>/dev/null || true
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true

# Drop the image's default .zshrc so stow won't conflict, then lay down my config.
# `claude` folds into the ~/.claude volume (config as symlinks); the volume's own auth files
# (.credentials.json, projects/) aren't in the package, so they survive rebuilds.
rm -f "$HOME/.zshrc"
( cd "$HOME/.dotfiles" && stow -R zsh git claude )

# The CLI keeps auth/state in ~/.claude.json (home = ephemeral); redirect it into the
# persisted ~/.claude volume so sign-in survives container rebuilds.
if [ ! -L "$HOME/.claude.json" ]; then
  touch "$HOME/.claude/.claude.json"
  ln -sf "$HOME/.claude/.claude.json" "$HOME/.claude.json"
fi
```

- **Stow package** (`zsh git claude`) and dotfiles URL mine — adjust for other user.
- **macOS + Docker Desktop**: SSH socket path magic `/run/host-services/ssh-auth.sock`.
- **Offline alternative** to clone: commit container-tailored `.devcontainer/dotfiles/` and
  `cp` from it in `post-create.sh` — predictable, but duplicate from real dotfiles.
- Never bind-mount `~/.ssh`, host `~/.claude`, or token file.