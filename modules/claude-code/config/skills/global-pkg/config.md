Oops, wrong tool there — ignore that. Here's the compressed text.

# global-pkg config

User-editable settings for `global-pkg` skill. Versioned in dotfiles.

## Preference hierarchy

Choosing how install app: walk tiers top-to-bottom, use first whose manager available on machine. Reorder list change policy.

1. **Official method** — way project's own devs/docs recommend (their repo, their script, their `.deb`/release). Highest trust for working, current install.
2. **Native system manager** — distro's own manager (`apt`/`dnf`/`pacman`/…).
3. **Other available managers** — `nix`, `brew`, `snap`, `flatpak`, `cargo`, etc.

## Per-OS overrides

Optional. Override hierarchy for specific OS/distro. Leave empty use default above everywhere.

- _none_

## Cache TTL

How long receipt in `installs.jsonl` reused before re-researching same app.

- `ttl_days: 14`