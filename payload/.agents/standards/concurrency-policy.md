# Concurrency Policy: Multi-Agent & Multi-Engineer Parallel Development

This standard defines how multiple engineers and/or AI agents can safely work in parallel within the same Monorepo without causing contract version splits, shared-module conflicts, or silent regressions.

## 1. Module Isolation (The Primary Defense)
- Each engineer/agent is assigned to a **specific module directory** (e.g., `src/modules/LOGIN/`).
- You MUST NOT modify files outside your assigned module without explicit escalation (see Section 3).
- Your SSDLC Tracker (`SSDLC_TRACKER.md`) must declare: `Assigned Module: <module_name>`.

## 2. Shared Module Protocol (The Escalation Path)
When your task requires modifying code in a **shared directory** (e.g., `src/Shared/`, `src/Common/`, `src/Infrastructure/`):
1. **Declare Intent**: Before editing, add a note to the Tracker: `Shared Module Edit Required: <file path> — Reason: <why>`.
2. **Check for Locks**: Search the repository for other active PRs or Tracker files that target the same shared file. If found, **STOP** and coordinate with the other engineer/agent.
3. **Interface-Only Changes Preferred**: If possible, extend the shared module via a new interface or extension method rather than modifying the existing contract. This minimizes collision risk.
4. **Atomic PR**: Changes to shared modules must be submitted as a **separate, minimal PR** before continuing feature work. Do not bundle shared module changes with feature code.

## 3. Contract Baseline Synchronization
- All parallel agents MUST reference the **same `contract_baseline_ref`** (OpenAPI tag/commit).
- Before starting Phase 5 (Build), verify that your local contract copy matches the latest baseline in the REQ repository.
- If the baseline has been updated by another team member's Writeback, you MUST pull the new baseline and reconcile your specs before continuing.

## 4. Pre-Merge Checklist (Before PR)
Before submitting any Pull Request in a parallel development environment:
- [ ] My changes are scoped entirely to `src/modules/<my_module>/` (or shared edits are in a separate PR).
- [ ] My contract baseline matches the latest `contract_baseline_ref` in REQ.
- [ ] I have run the full test suite, not just my module's tests.
- [ ] No other active PR targets the same shared files I modified.
