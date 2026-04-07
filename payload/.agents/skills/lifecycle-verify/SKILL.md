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
1. **Target Verification**: Invoke `$test-auditor` to drive testing against the target environment (Dev/Test).
2. **Proof Capture (MCP)**:
   - For UI: Capture screenshots using **Playwright MCP**.
   - For API: Capture exact Request/Response payloads.
3. **Security Hardening**: Perform an OWASP assessment on the new changes.
4. **Performance Audit**: Ensure the change hasn't introduced regressions (N+1 queries, memory leaks).

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
