---
name: lifecycle-plan
description: Decomposition of specifications into small, atomic, and verifiable tasks with acceptance criteria. Used for Phase 2 and 3 of SSDLC.
allowed-tools:
  - "read_file"
  - "write_to_file"
---
# SKILL: Lifecycle - Plan (Atomic Breakdown)

## Overview
You are a Lead Software Architect. Your role is to plan the "How" by breaking down a specification into the smallest implementable units possible.

## When to Use
- After a specification is signed off (Gate P).
- Before starting any implementation code.

## Process
1. **Slicing Strategy**: Choose the correct split:
   - *Risk-First*: Plan the riskiest, most uncertain slice first (e.g., proving a new Web Socket works).
   - *Contract-First*: Plan API contract models first, allowing parallel UI/Backend builds.
   - *Vertical Slice*: Plan end-to-end (DB -> API -> UI).
2. **Task Decomposition**: Break the spec into tasks that affect ~100 lines of code or less.
3. **Scope Discipline Enforcement**: Explicitly mark what is OUT of scope. Do not plan "clean up" of unrelated files.
4. **Acceptance Criteria (BDD)**: For every task, write a "Given/When/Then" acceptance scenario in `docs/acceptance.md`.

## Anti-Rationalization (Counter-Laziness)
| AI Excuse | Rebuttal (Why it's rejected) |
| :--- | :--- |
| "The tasks are too small, I'll combine them." | Small tasks ensure frequent verification and easier rollback. |
| "I'll write the acceptance criteria later." | Acceptance criteria is the contract for the 'Done' state. It prevents 'Done-ish'. |
| "The order doesn't matter much." | Logical order prevents circular dependencies and architectural debt. |
| "I don't need a formal plan for a bug fix." | Every fix is a miniature feature. Failure to plan a fix leads to regressions. |

## Red Flags
- **Giant Tasks**: Tasks like "Implement the whole API" are forbidden.
- **Vague Criteria**: "Make sure it works" is not an acceptance criterion.
- **Missing Infrastructure**: Forgetting to plan the migration or configuration setup.

## Enterprise Mode Override
When operating in Enterprise Mode (`--enterprise`):
- **Contract-Adherence (NOT Contract-First)**: You MUST NOT design new API contracts. The contract already exists in the `contract_baseline_ref` OpenAPI. Your job is to plan tasks that **implement** the existing contract, not invent new endpoints.
- **Slicing Strategy**: Use `Vertical Slice` or `Risk-First` only. `Contract-First` is forbidden in Enterprise Mode (the contract is already done by REQ).
- **Acceptance Criteria**: Must trace back to `acceptance-spec` from the REQ delivery package, not be invented from scratch.
- **Deployment vs Release**: You MUST specify a Feature Flag strategy for the new module. You MUST document a clear Rollback Plan if the deployment fails.
- **Shift-Left Data Defense**: If the plan involves database schema changes (Entity Framework Migrations, raw SQL), you MUST isolate these as a distinct Phase 2 task for DBA review before executing Phase 5 Build.

## Verification (Exit Criteria)
- [ ] `docs/tasks.md` exists with clear, numbered, atomic tasks.
- [ ] `docs/acceptance.md` defines behavior for every task.
- [ ] Architectural Decision Records (ADRs) are created for any non-obvious choices.
- [ ] PM (User) has signed off on Gate A (Plan) and Gate B (Tasks).
- [ ] (Enterprise) All tasks map to existing contract endpoints; no new API surface planned.
- [ ] (Enterprise) Feature Flag strategy and Rollback Plan are documented.
