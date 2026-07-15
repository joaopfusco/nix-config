---
name: global-dev-env
description: Scaffold a reproducible dev environment (Nix flake, devenv, or devcontainer) wired with direnv. Use when setting up a repo's toolchain or adding a dev shell.
---

# Dev environment scaffold

Set up a reproducible dev shell for a repo. Pick the approach the user prefers (ask if none):

- **Nix flake** — `flake.nix` with `devShells.default` + `.envrc` (`use flake`).
- **devenv** — `devenv.nix` (+ `devenv.yaml`) + `.envrc` (`eval "$(devenv direnvrc)"` then `use devenv`).
- **devcontainer** — `.devcontainer/devcontainer.json` (features or a Dockerfile).

## Steps

1. Confirm the approach and detect the stack from markers (`go.mod`, `pyproject.toml`,
   `*.csproj`, `package.json`, `Cargo.toml`, …). Ask if ambiguous.
2. Scaffold with the tool's initializer (`nix flake init`, `devenv init`, or write the
   file directly), then trim to just what the project needs (toolchain, LSP, formatter,
   required services). Pin `nixpkgs`.
3. Wire direnv when relevant: `.envrc` (`use flake`, or for devenv the two lines from
   [devenv specifics](#devenv-specifics) below); tell the user to run `direnv allow`.
   (`devenv init` writes a bare `use devenv` — still needs the `eval` line prepended.)
4. Update `.gitignore` (`.direnv/`, `.devenv/`, artifacts) and commit the lockfile.
5. Verify tools resolve inside the shell (`nix develop -c <tool> --version`, `devenv
   shell`, or reopen in container).

Keep it minimal and specific: a dev shell, not a production build. Don't leak build-time
deps into runtime. After adding files to a Stow package, remind to `stow -R <pkg>`.

## devenv specifics

The devenv <-> direnv integration is **not** loaded globally (it overrode nix-direnv's
`_nix_direnv_preflight` without setting `_nix_direnv_nix`, breaking `use flake` in plain
Nix projects). Wire it per-repo instead — `.envrc` must have both lines, in order:

```
eval "$(devenv direnvrc)"
use devenv
```

Add `dotenv.disableHint = true` to `devenv.nix`. For Python with compiled deps
(numpy/pandas/…) also set `languages.python.libraries = [ pkgs.stdenv.cc.cc.lib pkgs.zlib ];`.

## devcontainer defaults (editor-agnostic, secure host-bridging)

I use **Zed and VS Code** (mainly Zed), so keep everything at the **spec level** — the
devcontainer CLI runs it in both. Don't lean on VS Code-only magic (gitconfig copy, agent
forwarding, `dotfiles.repository`); Zed doesn't do those, so make them explicit. **Zed doesn't
reload on `devcontainer.json` edits** (you must kill + recreate the container), so scaffold it
**correct on the first try** — verify the prerequisites below before creating. Bridge host
niceties **without** mounting host secrets onto the container disk (see
`rules/dev-environments.md` for the why).

Prerequisites on the host (checked, don't assume): an SSH agent is running with
`SSH_AUTH_SOCK` set (mine: gnome-keyring at `/run/user/1000/keyring/ssh`) — if not, drop the
SSH mount + `remoteEnv`. My git identity and Claude config both come from my dotfiles via
`stow`, so no host-path binds that could be missing.

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

`post-create.sh` — editor-agnostic (the VS Code `dotfiles.repository` route won't run in Zed).
Brings in my shell, git identity, **and global Claude config** via my stow-managed dotfiles,
and hardens against the usual first-run breakages:

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

- **Stow packages** (`zsh git claude`) and the dotfiles URL are mine — adjust for another user.
- **macOS + Docker Desktop**: the SSH socket path is the magic `/run/host-services/ssh-auth.sock`.
- **Offline alternative** to cloning: commit a container-tailored `.devcontainer/dotfiles/` and
  `cp` from it in `post-create.sh` — predictable, but duplicated from my real dotfiles.
- Never bind-mount `~/.ssh`, the host `~/.claude`, or token files.
