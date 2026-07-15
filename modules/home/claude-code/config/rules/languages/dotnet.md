---
paths:
  - "**/*.cs"
  - "**/*.csproj"
  - "**/*.sln"
---
# C# / .NET

> Generic default. Pin version, project rule in repo's own config.

- Keep controller/handler thin: validate + delegate; no business logic at edge.
- Repo use layered/clean architecture, respect boundary — dependency point inward, domain depend on nothing.
- Use DI (constructor injection); avoid service locator, static for dependency.
- `async`/`await` end-to-end for I/O; flow `CancellationToken`; never `.Result`/`.Wait()`.
- Expose DTO at API boundary — no leak persistence entity direct.
- Follow repo `.editorconfig`, nullable-reference setting.

<!-- Per-repo: target framework, architecture, validation/mapping libs, test layout. -->