# Code style (universal)

Lang-agnostic default. Per-lang specific live `languages/`.

## Naming

- Name describe intent, not type: `users`, not `userList`/`userArr`.
- Boolean read as predicate: `isEnabled`, `hasAccess`, `shouldRetry`.
- Avoid abbreviation except well-known (`id`, `url`, `db`, `ctx`).
- Follow each lang's casing convention; no impose one across lang.

## Structure

- Small, single-purpose function; extract once logic reused or hard read.
- Keep nesting shallow — prefer early return / guard clause over `else` ladder.
- Order file top-down: public/exported surface first, helper below.
- Co-locate thing change together; split by feature, not layer-of-the-week.

## Comments

- Explain **why**, not **what**. Code already say what.
- No commented-out code, no decorative banner — delete dead code, git remember.
- Keep doc comment on exported/public API current; wrong comment worse than none.

## Errors

- Never swallow error silent. Handle, wrap with context, or propagate.
- Fail fast on programmer error; degrade graceful on expected/runtime error.
- Error message state what failed and relevant input, no leak secret.

## General

- No magic number/string — name them.
- Prefer immutability and pure function where no hurt clarity.
- Delete code rather than leave disabled behind flag "just in case".
- Respect repo existing formatter/linter config; no reformat unrelated code
  or impose formatter repo no adopt.