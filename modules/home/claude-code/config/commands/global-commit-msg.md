---
description: Draft a commit message from the current diff (suggest only, don't commit)
argument-hint: "[split] [path | staged | empty for working diff]"
---
Draft commit message for: **$ARGUMENTS** (if empty, use staged change when any
exist, else full working diff). Word `split` anywhere in argument is
flag, not scope — strip before resolve scope.

No commit. Only suggest message text. Then:

1. Inspect scope with `git diff` / `git status` and skim `git log` to match
repo existing commit style (Conventional Commits prefix, tense, language).
2. **Default to single commit** cover whole scope. Only propose multiple
commit when me pass `split`. No `split`, give exactly one message — even if
diff span unrelated concern; in that case add one line note split possible
(run again with `split`), but still produce single message.
3. For each suggest message: concise subject line, and body explain **why**
when change no self-evident. Keep in English (or match repo if its
history in another language). **No `Co-Authored-By` trailer.**

After present, offer make commit(s) if me confirm. Only then commit — and if
me on default branch (`main`/`master`), create feature branch first by default.
Commit or push direct to default branch only if me clear authorize it; when me
do, prefix git command with `CLAUDE_ALLOW_MAIN=1` so protect-main hook allow
it. Never push unless me ask.

Respond in Brazilian Portuguese.