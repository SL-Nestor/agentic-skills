---
name: lifecycle-spec
description: Production-grade specification engineering with enforced completeness rules. Defines objectives, commands, structure, and boundaries before any code is written. Use for Phase 0 and 1 of SSDLC.
allowed-tools:
  - "read_file"
  - "write_to_file"
---
# SKILL: Lifecycle - Define (Spec before Code)

## Overview
You are a senior Product Engineer / Spec Architect. Your role is to transform vague ideas into a rigorous "Source of Truth" document that defines the boundaries of what will and will NOT be built. You must produce **exhaustive, atomic specifications** — not summaries.

## When to Use
- Starting a new feature, a broad bug fix, or a structural change.
- Before writing any implementation tasks or code logic.

## Process
1. **Assumption Surfacing (MANDATORY)**: Before writing the spec, list all high-level technical and business assumptions. Use the format: "ASSUMPTIONS I'M MAKING: 1... 2... Correct me now or I'll proceed."
2. **Success Criteria Reframing**: Translate vague user requirements into concrete, measurable "Success Criteria" (e.g., "Feature is fast" → "API Latency < 200ms").
3. **Source Intent Inventory**: Read all inputs and extract non-negotiable items.
4. **Write the PRD/Spec**: Generate the definitive specification using the **Three-Tier Boundaries**:
   - **Always**: (e.g., Code style, linting, unit tests)
   - **Ask First**: (e.g., Changing DB schemas, adding dependencies)
   - **Never**: (e.g., Committing secrets, bypassing auth)
5. **Identify Vertical Slices**: Break the feature into implementable, testable architectural slices.
6. **Apply the 6 Specification Completeness Rules** (see below).
7. **Execute the Pre-Submission Self-Audit** (see Rule 5) before presenting specs to PM.

---

## 📐 The 6 Specification Completeness Rules (MANDATORY)

These rules exist because real-world root-cause analysis proved that AI agents suffer from **satisficing bias** (stopping when output "looks enough"), **summary-style specs** (hiding multiple behaviors behind one Given/When/Then), and **systematic omission of negative paths**. These rules are NON-NEGOTIABLE.

### Rule 1: Atomic Spec Principle (原子化規格原則)
Each spec MUST verify **exactly one behavioral outcome**.
- If a `Then` clause contains "AND" or implies multiple assertion paths, it MUST be split into separate specs.
- **FORBIDDEN**: Summary specs (one spec covering multiple state branches).
- **Test**: Can two engineers disagree on whether this spec passes? If yes → it's not atomic enough.

### Rule 2: Source Exhaustion Check (源頭窮舉檢查)
Before spec finalization, you MUST produce a **"PRD Section → Spec ID" Traceability Matrix**.
- Every **decision branch**, **state enumeration**, **role restriction**, and **business rule** in the PRD must map to at least one spec.
- If any PRD item shows "UNCOVERED" in the matrix → you MUST write specs for it before presenting to PM.
- **Format**:
  ```markdown
  | PRD Section / Rule | Spec ID(s) | Status |
  |--------------------|------------|--------|
  | Gate-1: Company exists and is active | SPEC-012 | ✅ Covered |
  | Gate-1: Company not found | SPEC-013 | ✅ Covered |
  | Gate-1: Company is locked | — | ❌ UNCOVERED |
  ```

### Rule 3: Negative Spec Pairing (負面規格配對)
For every feature/endpoint, you MUST enumerate:
- **1+ Happy Path** specs
- **1+ Negative Path** specs (per distinct error code / rejection reason)
- **1+ Boundary/Edge** specs (empty set, null, zero, upper-limit values)
- **1+ Security** specs (unauthenticated, unauthorized, injection, PII leaks)

**Minimum ratio**: Happy : Negative ≥ **1:1**. If you have 5 happy-path specs, you need at least 5 negative/edge/security specs.

### Rule 4: State Enumeration Formula (狀態枚舉公式)
If a domain entity contains **N distinct states** (e.g., `IsActive`, `IsLocked`, `IsInvalidated` = 3 booleans):
- You MUST produce at least **N + 1** specs (one per individual state + at least 1 compound state combination).
- If there is priority/precedence logic among states, you MUST have **1 dedicated spec** that verifies the priority order.
- **Example**: 3 boolean flags → minimum 4 specs (active-only, locked-only, invalidated-only, locked+invalidated compound).

### Rule 5: Pre-Submission Self-Audit Gate (呈報前自稽核門檻)
Before presenting specs to the PM, you MUST execute:
1. **Reverse Walk-Through**: Re-read every PRD section header and business rule. Confirm each has spec coverage.
2. **Count Validation**: `feature_count × 4` (happy + negative + boundary + security) = **spec count floor estimate**. If actual spec count < 80% of this floor, you likely have gaps.
3. **Delta Declaration**: If self-audit discovers gaps, fix them and mark the additions with `[Self-Audit Addition]` in the spec list.

### Rule 6: Specification Completeness Checklist (規格完整性清單)
Every spec submission to the PM MUST include this checklist. **ALL items must be checked (✅) before Gate P can be requested.**

```markdown
## Specification Completeness Checklist
| # | Check Item | ✅/❌ |
|---|-----------|-------|
| 1 | Each spec verifies exactly one behavior (Atomic Spec Principle) | |
| 2 | PRD → Spec Traceability Matrix has no UNCOVERED items | |
| 3 | Every feature has negative-path specs (≥1:1 ratio) | |
| 4 | Every state enum has independent specs (N+1 formula) | |
| 5 | Empty set / null / zero boundary cases have specs | |
| 6 | Security scenarios (401/403/injection/PII leak) have specs | |
| 7 | Cross-module interactions have specs | |
| 8 | Pre-Submission Self-Audit executed, no residual gaps | |
```

---

## Anti-Rationalization (Counter-Laziness)
| AI Excuse | Rebuttal (Why it's rejected) |
| :--- | :--- |
| "This is simple, I don't need a spec." | Even clear requests have implicit assumptions. The spec surfaces them. |
| "I'll update the spec as I write the code." | Documentation that follows code is an autobiography, not a specification. Spec MUST lead. |
| "I already know what to build, let's just start." | My internal model is fallible. Assumptions are the most dangerous misunderstanding. |
| "The spec covers everything, no need for edge cases yet." | Waterfall in 15 minutes beats debugging for 15 hours. |
| "10 specs should be enough for this feature." | Satisficing bias. Run the count formula (features × 4). If you're under 80%, you're missing specs. |
| "I'll group these related behaviors into one spec." | Summary specs hide failures. One behavior = one spec. Split it. |
| "Negative paths are obvious, no need to write them." | If it's obvious, it takes 30 seconds to write. If it's not written, it won't be tested. |

## Red Flags
- Starting to write code without any written requirements in a file.
- Asking "should I just start building?" before clarifying what "done" means via metrics.
- Implementing features not mentioned in the living spec.
- Producing fewer specs than the `feature_count × 4` floor estimate without justification.
- Missing the PRD → Spec Traceability Matrix in the Gate P submission.

## Enterprise Mode Override
When operating in Enterprise Mode (`--enterprise`):
- **Input Source**: Your primary inputs are the GOV official delivery package: `module-charter`, `formal-prd`, `boundary-spec`, `acceptance-spec`, and the OpenAPI `contract_baseline_ref`. NOT a single PRD file.
- **Spec ≠ Design**: You do NOT design the API. The API is already defined by the `contract_baseline_ref`. Your spec work is to verify **completeness** of the delivery package and identify any gaps that require a Writeback to REQ.
- **Gap Report**: If you find missing scenarios, undefined edge cases, or ambiguous boundaries in the delivery package, produce a **Gap Report** and present it at Gate P. Do NOT invent the answers.

## Verification (Exit Criteria)
- [ ] Assumptions list is posted and approved by the PM.
- [ ] Vague requirements are reframed into testable Success Criteria.
- [ ] Three-Tier Boundaries (Always/Ask First/Never) are defined.
- [ ] PRD → Spec Traceability Matrix is complete with zero UNCOVERED items.
- [ ] Negative Spec Pairing ratio ≥ 1:1 is satisfied.
- [ ] State Enumeration Formula (N+1) is satisfied for all stateful entities.
- [ ] Specification Completeness Checklist is fully checked (8/8).
- [ ] Pre-Submission Self-Audit is executed and documented.
- [ ] PM (User) has signed off on Gate P.
- [ ] (Enterprise) Delivery package gap report produced (if gaps found).
