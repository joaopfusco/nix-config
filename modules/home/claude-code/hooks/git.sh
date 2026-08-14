#!/usr/bin/env bash
# PreToolUse hook (Bash): ask for confirmation before running a git command
# that mutates history/refs while the repo is checked out on its default branch.
set -euo pipefail

input="$(cat)"
command="$(jq -r '.tool_input.command // empty' <<<"$input")"
cwd="$(jq -r '.cwd // empty' <<<"$input")"

[ -z "$command" ] && exit 0

cd "$cwd" 2>/dev/null || exit 0
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

default_branch="$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's#^origin/##')"
if [ -z "$default_branch" ]; then
  for candidate in main master; do
    if git show-ref --verify --quiet "refs/heads/$candidate"; then
      default_branch="$candidate"
      break
    fi
  done
fi
[ -z "$default_branch" ] && exit 0

current_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
[ "$current_branch" != "$default_branch" ] && exit 0

mutating_subcommands='commit|push|merge|rebase|reset|revert|cherry-pick|filter-branch'
if ! grep -Eq "git ($mutating_subcommands)\\b" <<<"$command"; then
  exit 0
fi

reason="Running '$command' on the default branch ($default_branch). Confirm before proceeding."
jq -n --arg reason "$reason" '{
  hookSpecificOutput: {
    hookEventName: "PreToolUse",
    permissionDecision: "ask",
    permissionDecisionReason: $reason
  }
}'
exit 0
