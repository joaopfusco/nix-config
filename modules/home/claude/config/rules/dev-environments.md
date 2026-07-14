---
paths:
  - "**/flake.nix"
  - "**/devenv.{nix,yaml}"
  - "**/.envrc"
  - "**/.devcontainer/**"
  - "**/Dockerfile"
  - "**/{docker-compose,compose}*.{yml,yaml}"
---

# Dev environments

> Generic defaults. The actual setup varies per repo — detect and follow it.

Many repos ship a reproducible dev environment. Detect it and run tooling inside it
instead of installing toolchains globally:

- **Nix flakes** — `flake.nix` (+ `flake.lock`); shell via `nix develop` or direnv.
- **devenv** — `devenv.nix` / `devenv.yaml`.
- **devcontainers** — `.devcontainer/` (`devcontainer.json`).
- **direnv** — `.envrc` (often `use flake` / `use devenv`); needs `direnv allow`.

Guidelines:

- If a dev shell is defined, assume it provides the toolchain; don't reinstall things
  globally or with a different package manager.
- Keep environment definitions minimal and pinned; update inputs deliberately and
  commit the lockfile.
- Don't leak build-time deps into runtime closures/images.
- After adding files to a GNU Stow package, re-stow it (`stow -R <pkg>`).

## devenv

- The devenv <-> direnv integration is **not** loaded globally (it overrode nix-direnv's
  `_nix_direnv_preflight` without setting `_nix_direnv_nix`, breaking `use flake` in plain
  Nix projects) — wire it per-repo in `.envrc`, both lines in order:
  ```
  eval "$(devenv direnvrc)"
  use devenv
  ```
- Set `dotenv.disableHint = true` in `devenv.nix` (direnv already loads `.env`; this just
  silences the recurring hint).
- Python with compiled deps (numpy/pandas/scikit-learn) needs shared libs made explicit,
  or it fails on missing `libz.so.1` / `libstdc++`:
  `languages.python.libraries = [ pkgs.stdenv.cc.cc.lib pkgs.zlib ];`.

## devcontainers

Editor-agnostic: I use **Zed and VS Code** (mainly Zed). Put everything at the
**spec level** of `devcontainer.json` — `features`, `mounts`, `remoteUser`, `remoteEnv`,
`postCreateCommand` are run by the devcontainer CLI, so they work in both. Do **not** rely
on VS Code-only conveniences (auto-copying `~/.gitconfig`, auto SSH-agent forwarding,
`dotfiles.repository`) — **Zed doesn't do them** (SSH/GPG agent forwarding is an open gap),
so make them explicit here. **Zed doesn't reload on `devcontainer.json` edits** — it means
killing + recreating the container — so the file must be right on the first build; verify
host prerequisites before creating rather than iterating on small fixes.

Bridge host niceties **without putting host secrets on the container disk** — a container
(especially with `--dangerously-skip-permissions`) can exfiltrate anything mounted into it;
prefer short-lived / repo-scoped tokens (Claude Code docs + `security.md`).

- **Shell (oh-my-zsh, my config)**: `common-utils` feature with `installOhMyZsh: true` **and
  `installOhMyZshConfig: false`** (so its stock `.zshrc` doesn't clobber mine) +
  `configureZshAsDefaultShell: true`. It only installs a *bare* oh-my-zsh — deliver my actual
  config in `postCreateCommand` by cloning my dotfiles and `stow`-ing the `zsh` package (`rm`
  the image's default `~/.zshrc` first, or stow conflicts), and clone the custom plugins my
  `.zshrc` enables into `~/.oh-my-zsh/custom/`.
- **Git identity**: `stow` the `git` package in `postCreateCommand` — my identity lives in
  `~/.config/git/config` (there is no `~/.gitconfig` to bind).
- **Git creds**: SSH via an **explicit** agent-socket mount (`${localEnv:SSH_AUTH_SOCK}` →
  `remoteEnv.SSH_AUTH_SOCK`) — the socket, never `~/.ssh`. Default here, not optional: neither
  Zed nor the CLI forwards the agent. (macOS + Docker Desktop: magic path
  `/run/host-services/ssh-auth.sock`.)
- **Global Claude config**: `stow` the `claude` package too, so the container's Claude Code has
  my skills/commands/rules/CLAUDE.md/hooks. Its hooks need `jq` — install `stow` + `jq` in
  `postCreateCommand` (the base image lacks them).
- **Claude auth**: a per-project **named volume** at `~/.claude`
  (`source=claude-code-config-${devcontainerId}`), not a bind of the host `~/.claude`. The CLI
  also keeps state in `~/.claude.json` (ephemeral home) — symlink it into the volume so
  sign-in survives rebuilds. Stowing `claude` folds config into the volume as symlinks; the
  volume's own auth files aren't in the package, so they persist.
- **`remoteUser` must be non-root** (required for `--dangerously-skip-permissions`).
- **Editor extensions**: set both `customizations.zed.extensions` and
  `customizations.vscode.extensions`.
- **Don't** bind-mount `~/.ssh`, host `~/.claude`, or token files.

<!-- Per-repo: which tool, shell layout, services, CI specifics. -->
