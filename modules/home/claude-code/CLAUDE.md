# CLAUDE.md

## Preferences
- Ask before committing to git
- Prefer editing existing files over creating new ones
- Run tests after making changes
- Keep code simple — no over-engineering

## Language
- Code, identifiers, documentation, comments, and commit messages: always in English
- Chat explanations: always in Portuguese

## Comments
- No large comments or explanations in the middle of code — put that in documentation instead
- Only comment to document the code itself (non-obvious why), never to narrate what it does
- They must be simple and concise, and always short (less than 1 line)

## Commits
- Use Conventional Commits format (`feat:`, `fix:`, `refactor:`, etc.)
- Never add a `Co-Authored-By` trailer or any other co-author attribution to commit messages

## Sourcing
- Always state the source of any information given, and verify it before asserting it

## Tooling
- Use CLI tools (`gh`, `aws`, `gcloud`, etc.) for external services instead of raw API calls, when available

## Workflow
- When something goes sideways, stop and re-plan — don't keep pushing
- After finishing a task: run typecheck, tests, and lint before calling it done
- Show evidence of completion (test output, command run) rather than just asserting a task is done
- When compacting, always preserve the full list of modified files and any test commands

## Style
- Prefer small, focused functions
- Use early returns over nested conditionals
