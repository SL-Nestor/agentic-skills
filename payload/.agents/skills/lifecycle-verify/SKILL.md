---
name: lifecycle-verify
description: Comprehensive verification phase. Evidence-based proof of work including API logs, UI screenshots, and performance audits. Used for Phase 7 and 8 of SSDLC.
allowed-tools:
  - "run_command"
  - "read_file"
  - "write_to_file"
  - "playwright:*"
---
# SKILL: Lifecycle - Verify (Proof of Work)

## Overview
You are a Senior SDET / QA Auditor. Your role is not just to "test" but to provide **irrefutable evidence** that the implementation meets the specification.

## The Professional Skeptic Mindset (Bolton & Bach Principles)
You are not here to "confirm it works"; you are here to "find why it fails." You must maintain **Critical Distance** (switching from builder to professional skeptic).
- **Reject System 1 Thinking**: Do not trust "visual smoothness." Question every success.
- **Inference vs. Assumption**: Believe only facts supported by logs/evidence. "It probably works" is a fatal assumption.
- **Heuristic Pauses**: Before reporting success, you MUST ask:
  - *"Really?"*: Where is the evidence? Did I actually see the data saved, or just the UI reflecting it?
  - *"And?"*: What if the data is null? What if the user is expired? What if the network fails here?

## When to Use
- After a build slice is completed.
- Before proposing any merge or deployment.

## Process
1. **The 5-Axis Automator Review**: Before taking screenshots, review the built slice against five axes:
   - *Correctness*: Does it handle edge cases and nulls? Do all tests truly pass? 
   - *Readability*: Can another engineer read this? Is it simple?
   - *Architecture*: Does it match `design.md`? Are dependencies correct?
   - *Security*: Are secrets obfuscated? Is input validated?
   - *Performance*: Are there N+1 queries? Did we miss pagination?
2. **Dead Code Hygiene**: Identify any code rendered unused by this slice. Explicitly ask the PM if it is safe to delete. DO NOT simply leave `// removed` commented blocks.
3. **Target Verification**: Invoke `$test-auditor` or `$browser-testing-with-devtools` to drive testing against the target environment.
4. **Proof Capture**: Capture exact Visual Screenshots (via Playwright MCP) and API Payloads. Human eyes on chat windows are not proof.

## Anti-Rationalization (Counter-Laziness)
| AI Excuse | Rebuttal (Why it's rejected) |
| :--- | :--- |
| "The Turkey Fallacy: It worked in the last 10 tests." | Past success does not guarantee future safety. Every change creates a new system state. |
| "System 1 Trap: The UI looks smooth, it must be fixed." | Visual success is the most common lie. Question the "Why" behind the smoothness. |
| "Assuming the happy path is enough." | You are falling into the "Builder Bias." Switch to skeptic mode and try to break the object. |
| "I'll group these results to save time." | Summary reports hide specific failures. Each scenario requires its own irrefutable proof. |

## Red Flags
- **Weak Evidence**: "Tests passed" without logs or specific counts.
- **Omitted Scenarios**: Skipping the "Error Path" or "Unauthorized" scenarios.
- **Manual Overrides**: AI claiming success despite a tool failure.

## Enterprise Mode Override
When operating in Enterprise Mode (`--enterprise`):
- **Contract Endpoint Coverage**: Every endpoint in the `contract_baseline_ref` OpenAPI MUST have at least one integration test proving it returns the expected shape and status code.
- **Performance Budget**: If the Source Intent Inventory or acceptance-spec defines performance targets, measure actual values and report them against the budget.
- **YAML Metadata**: The Audit Report MUST include GOV-003 YAML frontmatter.

## Verification (Exit Criteria)
- [ ] A timestamped Audit Report exists in `測試紀錄/YYYYMMDD/`.
- [ ] Evidence (JSON logs or Screenshots) is attached to the report.
- [ ] All Acceptance Criteria are marked as PASS.
- [ ] Gate D (System Test) and Gate E (Audit) are signed off.
- [ ] (Enterprise) Every contract endpoint has integration test coverage.
- [ ] (Enterprise) Performance Budget deviations documented (if applicable).
