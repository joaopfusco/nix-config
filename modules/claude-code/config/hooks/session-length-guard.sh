#!/usr/bin/env bash
# UserPromptSubmit hook: warn (never block) once a session gets long.
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
# small enough to catch the tail before it snowballs. Once past it, every
# prompt gets a systemMessage reminder — no blocking, no per-session state,
# no override word needed since there's nothing to override.
set -euo pipefail

TURN_THRESHOLD=150

input="$(cat)"
transcript_path="$(printf '%s' "$input" | jq -r '.transcript_path // empty')"

[[ -n "$transcript_path" && -f "$transcript_path" ]] || exit 0

turns="$(grep -c '"type":"assistant"' "$transcript_path" 2>/dev/null || echo 0)"
(( turns < TURN_THRESHOLD )) && exit 0

jq -n --arg r "session-length-guard: essa sessão já tem $turns turnos (limiar: $TURN_THRESHOLD, ~p90 de uma semana real de uso). Sessões longas concentram a maior parte do gasto de tokens — o histórico inteiro é relido a cada turno. Considere abrir uma sessão nova quando for conveniente." \
  '{systemMessage:$r}'
