---
name: lifecycle-ship
description: Finalization, living documentation sync, and deployment readiness. Used for Phase 9 and 10 of SSDLC.
allowed-tools:
  - "run_command"
  - "read_file"
  - "write_to_file"
---
# SKILL: Lifecycle - Ship (Release & Support)

## Overview
You are a Release Engineer / Technical Writer. Your role is to ensure the codebase is left in a "Better than found" state, with all documentation perfectly synchronized.

## When to Use
- After the verification phase is signed off (Gate E).
- To finalize the SSDLC loop.

## Process
1. **Living Docs Sync**: Update `README.md`, `CHANGELOG.md`, and any user manuals based on the final implementation.
2. **Code Cleanup**: Remove any temporary scaffolding, TODOs (that weren't intentional), or unused test doubles.
3. **PR/Deployment Readiness**: Generate the final handover summary in `Traditional Chinese`.
4. **VCS Checkpoint**: Commit all final changes with a standard conventional commit message.

## Anti-Rationalization (Counter-Laziness)
| AI Excuse | Rebuttal (Why it's rejected) |
| :--- | :--- |
| "The code is the documentation." | Code describes how; documentation describes why and how to use. |
| "I'll update the readme in the next PR." | Documentation drift starts here. Finish the job completely. |
| "One giant commit is fine for the whole project." | Atomic commits allow for safer rollbacks and cleaner history. |
| "I'm done, PM can just read the PR." | Handover documentation is a sign of professional engineering. |

## Red Flags
- **Missing Docs**: New features mentioned in code but missing from the UI guides or Readme.
- **Dirty Workspace**: Leftover temp files or `.tmp` directories.
- **Specification Drift**: The final implementaton differs from Phase 0 with no recorded reason.

## Enterprise Mode Override
When operating in Enterprise Mode (`--enterprise`):
1. **Contract Drift Check**: Before declaring ship-ready, verify the final implementation matches `contract_baseline_ref` exactly. Use `oasdiff` or equivalent tooling to compare the implemented API against the OpenAPI baseline. Any drift MUST be resolved via Writeback or rollback.
2. **Handoff Checklist Update**: Mark the `tpl_req_eng_handoff_checklist.md` status as `delivered`.
3. **Delivery Report**: Produce a formal Delivery Report (with GOV-003 YAML metadata) summarizing what was built, any deviations, and outstanding Writeback Notes.
4. **YAML Metadata**: All Ship-phase documents MUST include GOV-003 YAML frontmatter.

## Verification (Exit Criteria)
- [ ] `Living Documentation Sync` completed.
- [ ] Final VCS checkpoint committed and pushed.
- [ ] Traditional Chinese handover report generated for the PM.
- [ ] SSDLC_TRACKER.md marked as 100% COMPLETE.
- [ ] (Enterprise) Contract Drift Check passed — implementation matches baseline.
- [ ] (Enterprise) Handoff Checklist marked as `delivered`.
- [ ] (Enterprise) Delivery Report with YAML metadata produced.
