# NixOS module split: headless VM vs desktop vs VM-with-UI

## Context

The repo uses a dendritic module layout (`flake-parts` + `import-tree`, single
`modules/` tree, `flake.modules.<class>.<name>` registry — see
`modules/flake/host-options.nix` for the pattern). Each host's
`modules/hosts/<name>/default.nix` composes its NixOS/darwin/home-manager
configuration from an explicit list of named modules — there is no
option-driven "profile" indirection (e.g. no `host.class` switch); this is a
deliberate, previously-established preference for this repo.

Today there is exactly one real `nixosConfigurations` host: `nixos-vm`, a
headless NixOS VM created via OrbStack on macOS (no display, SSH-only
access). Its module composition currently imports the full desktop stack by
mistake:

- `nixos.gnome` (GDM + GNOME + extensions) — pointless without a display.
- `homeManager.gnome`, `homeManager.kitty`, `homeManager.zedEditor` — GUI-only
  home-manager modules.

The two catch-all NixOS modules it also imports, `nixos.common` and
`nixos.pkgs`, each mix concerns that don't belong together:

- `nixos.common` mixes universal host settings (nix config, inotify limits,
  networking, firewall, timezone, i18n, console keymap) with physical-machine
  peripherals (bluetooth, touchpad/libinput, printing, fwupd firmware
  updates, 32-bit graphics) and GUI-session settings (pipewire/pulseaudio
  audio stack, X keyboard layout via `services.xserver.xkb`).
- `nixos.pkgs` mixes CLI-safe packages/services (wget, curl, btop, distrobox,
  gstreamer codecs, docker, flatpak, nix-ld) with heavy GUI applications
  (libreoffice, vlc, obs-studio, vscode, dbeaver, postman, firefox, chrome).

The user wants to be able to compose three kinds of NixOS host going
forward: a normal physical desktop, a headless VM, and a VM that does run a
full desktop UI. Only the headless VM case needs to exist as a real host
today (fixing `nixos-vm`); the other two are future hosts the module
structure should support without further rework.

## Goals

- Split `nixos.common` and `nixos.pkgs` so headless hosts can import only
  what's headless-safe, without hand-picking individual settings.
- Fix `nixos-vm` to actually be headless: drop the GUI modules it currently
  pulls in on both the NixOS and home-manager side.
- Keep the existing explicit-import-list pattern per host — no new options,
  no conditional/`mkIf`-driven "profile" switches.
- Do not create the future `desktop-normal` or `vm-with-ui` hosts now; the
  design just needs to make composing them later a matter of picking the
  right modules off the shelf.

## Non-goals

- `darwin/common.nix` mixes macOS desktop settings (dock, trackpad, skhd
  keybindings) with universal ones (nix, timezone), but macOS always has a
  UI — splitting it has no practical benefit right now and is out of scope.
- `nixos.virtualisation` (libvirtd/virt-manager) is unrelated to this split
  (it's for a host that hosts VMs via virt-manager, not for the VM itself)
  and is untouched.
- `modules/home/pkgs.nix` is already CLI-only; no split needed there.
- No new host files are created by this work.

## Module split

Two orthogonal concerns were tangled in `common`/`pkgs`: "does this host have
real physical hardware" and "does this host run a GUI session." Splitting
along both axes produces exactly the three host recipes the user wants,
plus keeps a fourth (hardware without GUI) available at no extra cost even
though nobody needs it today.

| Module | Content | Status |
|---|---|---|
| `nixos.common` | nix settings/gc, inotify sysctl, networking, firewall, timezone, i18n locale, `console.keyMap` | trimmed (existing file) |
| `nixos.hardware` | `hardware.enableAllFirmware`/`enableRedistributableFirmware`, `hardware.bluetooth.*`, `services.fwupd`, `services.libinput.*` (touchpad), `services.printing`, `hardware.graphics.enable32Bit` | new |
| `nixos.desktop` | `hardware.graphics.enable`, `services.pulseaudio.enable = false` + `security.rtkit.enable` + `services.pipewire.*`, `services.xserver.xkb` | new |
| `nixos.gnome` | GDM + GNOME + extensions | unchanged |
| `nixos.pkgs` | wget, curl, btop, distrobox, gstreamer codecs, docker, flatpak, nix-ld | trimmed (existing file) |
| `nixos.apps` | libreoffice, vlc, obs-studio, vscode, dbeaver, postman, firefox, google-chrome | new |

Both browsers (`programs.firefox` and `google-chrome`) move to `nixos.apps`
— there's no reason to treat one browser as more headless-safe than the
other, both are full GUI applications.

`hardware.graphics` splits across two modules: the base
`hardware.graphics.enable` (GPU render acceleration) goes to `nixos.desktop`
— a VM with a UI still benefits from render acceleration for its desktop
session — while `hardware.graphics.enable32Bit` (legacy 32-bit app/game
compat, e.g. Wine/Steam) goes to `nixos.hardware`, since that's a
physical-desktop concern only.

Host recipes this split enables (not created now, for reference):

- **desktop-normal** (future): `common + hardware + desktop + gnome + pkgs + apps`
- **nixos-vm** (headless, fixed by this work): `common + pkgs`
- **vm-with-ui** (future): `common + desktop + gnome + pkgs + apps` (no `hardware` — a VM has no real bluetooth/touchpad/printer)

## `nixos-vm` host fix

`modules/hosts/nixos-vm/default.nix` changes:

- NixOS `modules` list: replace `nixos.common, nixos.gnome, nixos.pkgs` with
  `nixos.common, nixos.pkgs` (drop `nixos.gnome`; `nixos.hardware` and
  `nixos.desktop` were never imported here so nothing to remove there).
- `specialArgs.homeManagerModules`: drop `homeManager.gnome`,
  `homeManager.kitty`, `homeManager.zedEditor`. Keep everything else
  (`base`, `gh`, `git`, `direnv`, `dotnet`, `pkgs`, `fonts`, `zsh`,
  `aliases`, `starship`, `claudeCode`) — these are all CLI-safe or
  harmless-if-unused (fonts just install font files).

No change to `_hardware.nix` (VM-generated hardware-scan, unrelated to this
split) or to the already-uncommitted `services.openssh` addition.

## Out of scope confirmation

`modules/hosts/notebook/default.nix` and `modules/hosts/macbook/default.nix`
are untouched. Their existing `lib.mkForce null` overrides on
`programs.claude-code`/`programs.zed-editor`/`programs.kitty` packages are a
different concern (package delivery on genericLinux / apps managed via
Homebrew on macOS) — not a headless/desktop split. `modules/darwin/*` is
untouched per Non-goals.

## Testing

- `nix flake check` after the split to confirm evaluation still succeeds for
  every existing `nixosConfigurations`, `darwinConfigurations`, and
  `homeConfigurations` entry (only `nixos-vm` and `notebook`/`macbook`
  currently exist, so this is the full matrix).
- Manually diff `nix eval .#nixosConfigurations.nixos-vm.config.system.build.toplevel.drvPath`
  behavior isn't practical to "diff" meaningfully pre/post since the whole
  point is it changes (drops GNOME) — instead confirm the build closure no
  longer references `gnome-shell`/`gdm` via
  `nix path-info -r .#nixosConfigurations.nixos-vm.config.system.build.toplevel | grep -i gnome`
  returning nothing.
