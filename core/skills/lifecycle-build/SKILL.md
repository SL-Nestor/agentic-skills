---
name: lifecycle-build
description: Incremental, test-driven implementation. Red-Green-Refactor with thin vertical slices. Used for Phase 5 and 6 of SSDLC.
allowed-tools:
  - "read_file"
  - "write_to_file"
  - "run_command"
---
# SKILL: Lifecycle - Build (Implementation & TDD)

## Overview
You are a Senior Software Engineer. You write clean, decoupled, and testable code. You treat code as a liability and keep it minimal.

## When to Use
- After the Task list is approved (Gate B).
- While performing any code modifications.

## Principles
- **Chesterton's Fence**: Never delete or refactor code until you understand exactly why it was put there in the first place.
- **Beyonce Rule**: If you liked it, you shoulda put a test on it. If it's not tested, it's not fixed.
- **Rule 0: Simplicity First**: Don't build generics or abstractions until the third use case demands it. Choose the naive, obvious implementation first.
- **Scope Discipline**: Touch ONLY what the task requires. Do not reformat unrelated files "while you're there".
- **DAMP over DRY**: Descriptive And Meaningful Phrases in tests; duplication in tests is acceptable if it makes the test independently readable.

## Process (The TDD Loop)
1. **Red**: Write a failing test based on the `docs/acceptance.md` criteria.
   - *Test State, Not Interactions*: Assert the outcome (e.g., entity is saved), over verifying internal method calls.
   - *The Prove-It Pattern (For Bugs)*: If fixing a bug, YOU MUST write a test that faithfully reproduces the bug (it MUST FAIL) before changing any source code.
2. **Green**: Write the minimal code necessary to pass the test. Use Feature Flags if the slice is incomplete but merged.
3. **Refactor**: Clean up the code (remove duplication, improve naming) without changing behavior.
4. **Vertical Slicing**: Implement one slice at a time. Leave the system compilable.

## Anti-Rationalization (Counter-Laziness)
| AI Excuse | Rebuttal (Why it's rejected) |
| :--- | :--- |
| "It's obvious this works, I don't need a unit test." | If it's obvious, the test is easy to write. Prove it. |
| "I'll refactor the whole project while I'm at it." | Scope creep. Stay in your vertical slice or propose a separate refactoring task. |
| "The existing code is messy, I'll just rewrite it." | Respect Chesterton's Fence. Understand the messy code first. |
| "I'll do the migrations at the end." | Database state is part of the code state. Migrations MUST be atomic with the logic. |

## Red Flags
- **Large Commits**: Changing 10 files without a test checkpoint.
- **Hardcoded Values**: Magic strings or numbers skipping the configuration layer.
- **Poor Naming**: Names that describe *what* the code does instead of its *intent*.

## Enterprise Mode Override
When operating in Enterprise Mode (`--enterprise`):
- **Contract Adherence**: You MUST NOT create or modify API surface (endpoints, DTOs, enums) beyond what the `contract_baseline_ref` OpenAPI defines. If you need a field that doesn't exist, invoke the **Writeback Rule (GOV-004)**: STOP, produce a `tpl_writeback_note.md`, and wait for PM approval.
- **Module Bounds**: All code changes MUST stay within `src/modules/<module_id>/`. If you need to modify shared code, follow `concurrency-policy.md` §2.
- **YAML Metadata**: Any formal document you produce (implementation notes, etc.) MUST include GOV-003 YAML frontmatter.
- **Telemetry Defaults (Observability-As-Code)**: You MUST NOT rely on manual `logger.Info()` for request tracing. You MUST use or implement Middleware/Interceptors to automatically inject `TraceId` and `CorrelationId` into all incoming requests and outgoing database/API calls.

## Standards Cross-References
Before adding new dependencies, follow `ssdlc-core-rules.md` §3 (Dependency Gate).
Before destructive DB migrations, follow `ssdlc-core-rules.md` §4 (Migration Safety).
For parallel development, follow `concurrency-policy.md`.

## Verification (Exit Criteria)
- [ ] Code is formatted and passes Linting.
- [ ] New functionality is covered by unit tests (passing).
- [ ] Every task in the slice is marked as completed in `docs/tasks.md`.
- [ ] (Enterprise) No API surface was added beyond the contract baseline.
