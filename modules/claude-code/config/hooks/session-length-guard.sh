#!/usr/bin/env bash
# UserPromptSubmit hook: force a conscious choice once a session gets long.
#
# Measured 2026-07-15 across 112 real sessions (one week, all projects):
# turns/session is heavily right-skewed — median 11, p90 146, p95 284, but
# the tail goes to 602/911/1043. cache_read (the dominant token cost, ~97%
# of weekly volume) scales with session length: the single heaviest session
# that week (774 turns) burned more cache_read alone than every other
# session combined. Output-token tricks (verbosity, compression) don't touch
# this at all — only session length does.
#
# THRESHOLD sits at p90: big enough to not nag on a normal heavy session,
# small enough to catch the tail before it snowballs. Once past it, block
# every prompt until the user either starts a fresh session or explicitly
# says they want to stay (recorded per-session so it doesn't re-block every
# single turn — just every RECONFIRM_EVERY turns after that).
set -euo pipefail

TURN_THRESHOLD=150
RECONFIRM_EVERY=100
OVERRIDE_WORD='continuar'

input="$(cat)"
transcript_path="$(printf '%s' "$input" | jq -r '.transcript_path // empty')"
session_id="$(printf '%s' "$input" | jq -r '.session_id // empty')"
prompt="$(printf '%s' "$input" | jq -r '.prompt // empty')"

[[ -n "$transcript_path" && -f "$transcript_path" && -n "$session_id" ]] || exit 0

turns="$(grep -c '"type":"assistant"' "$transcript_path" 2>/dev/null || echo 0)"
(( turns < TURN_THRESHOLD )) && exit 0

claude_dir="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"
state_dir="$claude_dir/.session-guard"
mkdir -p "$state_dir"
state_file="$state_dir/$session_id"

# This prompt contains the exact code word: record it and let it through.
if printf '%s' "$prompt" | grep -Fq "$OVERRIDE_WORD"; then
  echo "$turns" >"$state_file"
  exit 0
fi

# Already confirmed recently enough: don't nag every single turn after that.
if [[ -f "$state_file" ]]; then
  last_confirmed="$(cat "$state_file" 2>/dev/null || echo 0)"
  (( turns < last_confirmed + RECONFIRM_EVERY )) && exit 0
fi

jq -n --arg r "session-length-guard: essa sessão já tem $turns turnos (limiar: $TURN_THRESHOLD, ~p90 de uma semana real de uso). Sessões longas concentram a maior parte do gasto de tokens — o histórico inteiro é relido a cada turno, e isso cresce com o tamanho da sessão, não com o tamanho das respostas. Abra uma sessão nova pra continuar mais barato, ou responda com a palavra 'continuar' em qualquer lugar da mensagem se preferir seguir por aqui mesmo." \
  '{decision:"block",reason:$r}'
