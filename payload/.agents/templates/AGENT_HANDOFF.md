# Agent Handoff — [Feature/Sprint Name]

> **[AI DIRECTIVE]**: This file is the single source of truth for inter-agent context transfer.
> Every agent MUST read this file before starting work. Every agent MUST update the relevant section upon completion.
> Do NOT skip reading this file. Failure to read this file may result in contradictory outputs that invalidate prior work.

---

## Handoff Metadata

```yaml
feature: ""                    # 功能或 Sprint 名稱
created_at: ""                 # ISO 8601 timestamp
last_updated_by: ""            # 最後更新的 agent 名稱 (e.g., "spec-architect")
last_updated_at: ""            # ISO 8601 timestamp
current_phase: ""              # 0=Kickoff | 1=Requirements | 2=Security Design | 3=Implementation | 4=Security Gate | 5=Deployment
next_agent: ""                 # 下一個應該接手的 agent
model_parity_warning: false    # true if creator and reviewer are using the same model (independence degraded)
```

---

## Phase Gate Status

| Phase | Agent | Model Used | Status | Completed At |
|-------|-------|-----------|--------|-------------|
| 0 - Kickoff | team-coordinator | Claude Sonnet 3.7 | ⬜ Pending | — |
| 1a - Requirements | requirement-analyst | Claude Sonnet 3.7 | ⬜ Pending | — |
| 1b - Spec & Design | spec-architect | Claude Sonnet 3.7 | ⬜ Pending | — |
| 2 - Threat Modeling | threat-modeler | Gemini 2.0 Pro | ⬜ Pending | — |
| 3a - Implementation | implementer | GPT-4o | ⬜ Pending | — |
| 3b - Code Review | code-reviewer | Gemini 2.0 Pro | ⬜ Pending | — |
| 3c - Testing | test-engineer | GPT-4o | ⬜ Pending | — |
| 4 - Security Gate | security-gate | Claude Sonnet 3.7 | ⬜ Pending | — |
| 5 - Deployment | devops | GPT-4o | ⬜ Pending | — |

**Status Legend**: ⬜ Pending | 🔄 In Progress | ✅ Pass | ❌ Fail | ⏭️ Skipped (with reason)

---

## Artifacts Registry

每個 agent 完成工作後，必須在此登記產出的文件。

| Phase | Artifact Path | Description | Agent | Status |
|-------|--------------|-------------|-------|--------|
| 1a | `docs/specs/requirements.md` | 需求規格書（原始需求 → 結構化） | requirement-analyst | ⬜ |
| 1b | `docs/plan.md` | 開發計畫（架構圖、技術棧、風險）| spec-architect | ⬜ |
| 1b | `docs/tasks.md` | 開發任務清單（Ticket 格式）| spec-architect | ⬜ |
| 1b | `docs/acceptance.md` | BDD 驗收條件（Happy + Edge paths）| spec-architect | ⬜ |
| 2 | `docs/security/Threat_Model.md` | STRIDE 威脅模型 | threat-modeler | ⬜ |
| 3b | `docs/reviews/code-review-[date].md` | Code Review Report | code-reviewer | ⬜ |
| 3c | `tests/` | 自動化測試 | test-engineer | ⬜ |
| 4 | `docs/security/security-gate-[date].md` | 安全閘口驗證報告 | security-gate | ⬜ |
| 5 | `.github/workflows/` 或 `.gitlab-ci.yml` | CI/CD Pipeline | devops | ⬜ |

---

## Open Issues & Blockers

> 任何 agent 如果發現需要下一個 agent 特別注意的事項，記錄在此。

| ID | Found By | Severity | Description | Resolution Status |
|----|----------|----------|-------------|------------------|
| — | — | — | — | — |

---

## Cross-Validation Conflict Log

> 當兩個 agent 對同一件事的判斷有衝突時，記錄在此。需要人類介入時標記 `resolution_required`。

| Conflict ID | Agent A | Agent A Verdict | Agent B | Agent B Verdict | Resolution | Resolved By |
|-------------|---------|----------------|---------|----------------|------------|-------------|
| — | — | — | — | — | — | — |

---

## Security Gate Checklist

> **[AI DIRECTIVE for security-gate agent]**: Before marking Phase 4 as PASS, every row in this table must be verified. A single unresolved HIGH threat is a FAIL verdict.

| Threat ID | From Threat_Model.md | Dev Task Created | Code Implemented | Code Reviewed | Test Coverage | Gate Verdict |
|-----------|---------------------|-----------------|-----------------|---------------|--------------|-------------|
| — | — | — | — | — | — | — |

---

## Coordinator Notes

> team-coordinator 在 Kickoff 時填寫，並在最終歸檔時更新。

### Initial Context (Kickoff)
```
[由 team-coordinator 在 Phase 0 填寫：
  - 功能背景說明
  - 已知限制條件
  - 參考文件清單
  - 任何特殊的跨越 phase 的注意事項
]
```

### Final Summary (Deployment)
```
[由 team-coordinator 在 Phase 5 完成後填寫：
  - 最終產出摘要
  - 遺留的已知問題
  - 後續追蹤項目
]
```

---

## Changelog

```markdown
| Version | Date | Agent | Change |
|---------|------|-------|--------|
| v0.1 | [date] | team-coordinator | 初始建立 |
```
