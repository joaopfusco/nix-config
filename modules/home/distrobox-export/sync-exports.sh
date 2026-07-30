#!/usr/bin/env bash
# Syncs ~/.nix-profile/bin into distrobox-export: exports what's new, deletes
# what's gone. Called both from home-manager activation and from the
# systemd --user path unit that watches the profile for out-of-band changes
# (e.g. `nix profile install`).
set -euo pipefail

if ! command -v distrobox-export >/dev/null 2>&1; then
  exit 0
fi

profile_bin="$HOME/.nix-profile/bin"
[ -d "$profile_bin" ] || exit 0

desired=$(mktemp)
exported=$(mktemp)
trap 'rm -f "$desired" "$exported"' EXIT

find "$profile_bin" -maxdepth 1 \( -type f -o -type l \) -printf '%f\n' 2>/dev/null | sort > "$desired"

# NOTE: verify this matches the real output of `distrobox-export --list-binaries`
# on the installed distrobox version (it may print names or full paths) before
# trusting the diff below.
distrobox-export --list-binaries 2>/dev/null | awk -F/ '{print $NF}' | sort > "$exported"

# Exported but no longer in the profile: drop it.
comm -23 "$exported" "$desired" | while IFS= read -r name; do
  [ -z "$name" ] && continue
  ${DRY_RUN_CMD:-} distrobox-export --bin "$profile_bin/$name" --delete || true
done

# In the profile but not exported yet: add it.
comm -13 "$exported" "$desired" | while IFS= read -r name; do
  [ -z "$name" ] && continue
  ${DRY_RUN_CMD:-} distrobox-export --bin "$profile_bin/$name" || true
done
