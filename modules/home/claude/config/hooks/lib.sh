#!/usr/bin/env bash
# Shared helpers for PreToolUse hooks. Emit the native permission decision so a
# guarded action ESCALATES to a user prompt instead of dead-ending on exit 2.
# Each helper prints the JSON on stdout and exits 0 (the only exit status Claude
# Code parses JSON on). See https://code.claude.com/docs/en/hooks
#
# Source it from a sibling hook: source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"

# Escalate to the user: normal approve/deny prompt in the UI. This is the
# "do it with the user's permission" path — the block isn't a wall, it asks.
hook_ask() {
  jq -n --arg r "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"ask",permissionDecisionReason:$r}}'
  exit 0
}

# Hard block: Claude sees the reason as an error and cannot proceed. Reserve for
# things that must never happen, not "ask me first" cases.
hook_deny() {
  jq -n --arg r "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

# Explicit allow: bypass the permission system for this call (skips prompts).
hook_allow() {
  jq -n --arg r "${1:-}" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"allow",permissionDecisionReason:$r}}'
  exit 0
}
