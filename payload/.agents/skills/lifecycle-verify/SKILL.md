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
| "I've run the unit tests, that's enough." | Unit tests prove the logic; Integration tests prove the REALITY. |
| "The UI looks correct to me in the prompt." | Human eyes in a chat window are not a verification gate. Screenshots are proof. |
| "Performance isn't an issue for this small task." | Systematic performance degradation happens one "small task" at a time. |
| "I'll skip the security check this time." | Security is not an optional phase; it is a fundamental property of the work. |

## Red Flags
- **Weak Evidence**: "Tests passed" without logs or specific counts.
- **Omitted Scenarios**: Skipping the "Error Path" or "Unauthorized" scenarios.
- **Manual Overrides**: AI claiming success despite a tool failure.

## Verification (Exit Criteria)
- [ ] A timestamped Audit Report exists in `測試紀錄/YYYYMMDD/`.
- [ ] Evidence (JSON logs or Screenshots) is attached to the report.
- [ ] All Acceptance Criteria are marked as PASS.
- [ ] Gate D (System Test) and Gate E (Audit) are signed off.
