#!/usr/bin/env bash
# PreToolUse hook (Bash): guard `git commit` / `git push` on main/master.
# The explicit token CLAUDE_ALLOW_MAIN=1 (Claude adds it only after I clearly
# authorize a commit/push on the default branch) passes silently. Without it, the
# action isn't hard-blocked — it's escalated to a user prompt so I can approve it
# on the spot. Only governs Claude; you can always do it yourself in the terminal.
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

input="$(cat)"
cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty')"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty')"
[[ -n "$cwd" && -d "$cwd" ]] && cd "$cwd"

# Only care about commit / push.
printf '%s' "$cmd" | grep -Eq 'git[[:space:]]+(commit|push)' || exit 0

# Explicit authorization bypass: I told Claude to commit/push to main for this action.
printf '%s' "$cmd" | grep -q 'CLAUDE_ALLOW_MAIN=1' && exit 0

branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
case "$branch" in
  main|master)
    hook_ask "protect-main: '$branch' is the default branch. Approve to allow this git commit/push here, or deny and branch off first (git switch -c <name>). Once clearly authorized, Claude can also prefix the command with CLAUDE_ALLOW_MAIN=1 to skip this prompt." ;;
esac
exit 0
