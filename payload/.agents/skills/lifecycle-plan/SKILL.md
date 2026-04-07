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
1. **Task Decomposition**: Break the spec into tasks that should take no more than 1 hour of "mental effort" for an agent.
2. **Dependency Ordering**: Order tasks so that dependencies (e.g., DB Schema -> Repository -> API) are handled in the logical flow.
3. **Acceptance Criteria (BDD)**: For every major task, write a "Given/When/Then" acceptance scenario in `docs/acceptance.md`.
4. **Vertical Slicing**: Ensure each task contributes to a functional vertical slice rather than broad horizontal layers.

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

## Verification (Exit Criteria)
- [ ] `docs/tasks.md` exists with clear, numbered, atomic tasks.
- [ ] `docs/acceptance.md` defines behavior for every task.
- [ ] Architectural Decision Records (ADRs) are created for any non-obvious choices.
- [ ] PM (User) has signed off on Gate A (Plan) and Gate B (Tasks).
