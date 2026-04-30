# Project Memory Template

> **[AI DIRECTIVE]**: This file persists across sprints and features. It is the long-term memory of this project.
> Read this file at the start of every new feature/sprint. Update it at project closure (Phase 9-10).
> Do NOT delete entries. Append new learnings to the bottom of each section.

---

## Project Profile

```yaml
project_name: ""
primary_language: ""
framework: ""
deployment_target: ""
team_size: ""
repo_type: ""  # monorepo | polyrepo
last_updated: ""
updated_by: ""
```

---

## Architecture Decisions

> Key technical decisions made during development. Each entry explains the *why*, not just the *what*.

| Date | Decision | Rationale | Decided By |
|:---|:---|:---|:---|
| <!-- e.g. 2026-04-29 --> | <!-- e.g. Chose Dapper over EF Core for read queries --> | <!-- e.g. Performance requirement: <50ms p99 for catalog queries --> | <!-- e.g. spec-architect --> |

---

## Developer Preferences

> User-specific conventions that apply across all features in this project.

- <!-- e.g. Prefer record types for all DTOs -->
- <!-- e.g. Always use ILogger<T>, never Console.WriteLine -->
- <!-- e.g. Commit messages in English, code comments in Traditional Chinese -->

---

## Known Gotchas

> Things that tripped up agents or developers. Future sessions MUST check this list before making assumptions.

| ID | Category | Gotcha | Workaround |
|:---:|:---|:---|:---|
| G-001 | <!-- e.g. Database --> | <!-- e.g. EF Core migration conflicts when 2 agents modify the same DbContext --> | <!-- e.g. Always run `dotnet ef migrations list` before creating new migration --> |

---

## Lessons Learned

> Post-mortem insights from completed sprints. Each entry captures what went wrong and what the team would do differently.

| Sprint/Feature | Lesson | Category |
|:---|:---|:---|
| <!-- e.g. Login Module v1 --> | <!-- e.g. Should have run STRIDE before implementation, not after --> | <!-- e.g. Process --> |

---

## Frequently Used Commands

> Project-specific commands that agents need often.

```bash
# Build
# e.g. dotnet build src/Product.sln

# Test
# e.g. dotnet test --no-build --verbosity minimal

# Run
# e.g. dotnet run --project src/WebApp

# Migrate
# e.g. dotnet ef database update --project src/Infrastructure
```

---

## Cross-References

> Links to important documents that agents should know about but NOT auto-load.

- Threat Model: `docs/security/Threat_Model.md`
- API Contract: `docs/specs/openapi.yaml`
- Architecture Diagram: `docs/plan.md`

---

*Template version: 1.0 — Derived from Harness Engineering Guide Memory Architecture*
