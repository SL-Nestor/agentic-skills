---
title: AI Agent Network — Multi-Model Cross-Validation Architecture
status: Active
scope: global
version: 1.0
---

# AI Agent Network Standard
> **Language Policy**: AI directives in English for parsing precision. 繁體中文說明供人類開發者參考。

---

## 1. 設計哲學：為什麼要用不同的 AI 模型？

**[給人類開發者的說明]**
這套架構最核心的原則是「**交叉驗證（Cross-Validation）**」。就像優秀的審計流程不能讓同一個人寫帳又查帳，我們刻意讓不同 AI 模型負責「產出」與「審查」這兩個角色。

不同 AI 模型（GPT、Claude、Gemini）有不同的訓練資料、不同的推理偏好、不同的盲點。由 Model A 寫的程式碼，由 Model B 審查，能捕捉到 A 的系統性弱點所遺漏的問題。這不是工具的選擇問題，而是系統性對抗測試（Adversarial Validation）的工程原則。

---

## 2. Agent 角色與模型分配矩陣

**[AI DIRECTIVE]**
Every agent in this network SHOULD use the model assigned below. Model assignments are advisory recommendations for maximizing cross-validation independence. Substitution is permitted when the assigned model is unavailable — see Section 5 for fallback rules. When substituting, note the change in `SSDLC_TRACKER.md` (or `AGENT_HANDOFF.md` if in use).

| # | Agent Role | Macro | Assigned Model | Rationale |
|---|------------|-------|---------------|-----------|
| 0 | Team Coordinator | `$coordinator` | `Claude Sonnet 3.7 (copilot)` | Best orchestration, structured multi-step reasoning |
| 1 | Requirement Analyst | `$req-analyst` | `Claude Sonnet 3.7 (copilot)` | Long-context comprehension, nuanced requirement parsing |
| 2 | Spec Architect | `$spec-architect` | `Claude Sonnet 3.7 (copilot)` | Doc-first philosophy, structured output, Mermaid diagrams |
| 3 | Threat Modeler | `$threat-modeler` | `Gemini 2.0 Pro (copilot)` | **Independent security perspective** — different model than spec author |
| 4 | Implementer | `$implementer` | `GPT-4o (copilot)` | Strongest code generation, broad language coverage |
| 5 | Code Reviewer | `Gemini 2.0 Pro (copilot)` | `Gemini 2.0 Pro (copilot)` | **Reviews code it did NOT write** — catches GPT-4o blind spots |
| 6 | Test Engineer | `$test-engineer` | `GPT-4o (copilot)` | Strong test scaffolding, consistent with implementer's patterns |
| 7 | Security Gate | `$security-gate` | `Claude Sonnet 3.7 (copilot)` | Thorough final analysis, cautious disposition, audit-grade output |
| 8 | DevOps Engineer | `$devops` | `GPT-4o (copilot)` | Strong YAML/pipeline generation, infrastructure code |

### 交叉驗證設計說明

```
產出者 (Creator)          審查者 (Reviewer)        交叉點
─────────────────────────────────────────────────────────────
GPT-4o    [Implementer]  →  Gemini   [Code Reviewer]  ✓ 模型交叉
Claude    [Spec]         →  Gemini   [Threat Modeler] ✓ 模型交叉
GPT-4o    [Implementer]  →  Claude   [Security Gate]  ✓ 模型交叉
Gemini    [Code Review]  →  Claude   [Coordinator]    ✓ 最終裁決
```

---

## 3. SSDLC 工作流程與 Agent 交接協議

**[AI DIRECTIVE]**
The following pipeline shows the recommended agent sequence for multi-model cross-validation. The SSDLC phase sequence and Gates defined in `copilot-instructions.md` remain authoritative — this diagram maps agent roles onto those phases. `SSDLC_TRACKER.md` is the single canonical state document; `AGENT_HANDOFF.md` is an optional supplementary context template for agent-to-agent handoffs.

```
Phase 0: KICK-OFF
  └─ $coordinator (Claude)
       ├─ 讀取所有輸入（需求、現有程式碼、限制條件）
       ├─ 產出 AGENT_HANDOFF.md 初始版本
       └─ HANDOFF → Phase 1

Phase 1: REQUIREMENTS & DESIGN
  ├─ $req-analyst (Claude) — 需求訪談 → docs/specs/requirements.md
  ├─ $spec-architect (Claude) — 規格設計 → docs/plan.md, tasks.md, acceptance.md
  └─ HANDOFF → Phase 2

Phase 2: SECURITY DESIGN  [⚠️ 模型切換點]
  └─ $threat-modeler (Gemini) — 獨立安全評估 → docs/security/Security_Threat_Model.md
       HANDOFF → Phase 3

Phase 3: IMPLEMENTATION LOOP
  ├─ $implementer (GPT-4o) — 程式碼實作
  ├─ $code-reviewer (Gemini) — 交叉審查  [⚠️ 不同模型]
  ├─ $test-engineer (GPT-4o) — 測試撰寫
  └─ [Loop until reviewer & tests PASS] → Phase 4

Phase 4: SECURITY GATE  [⚠️ 最終獨立驗證]
  └─ $security-gate (Claude) — 對照 Security_Threat_Model.md 逐條驗證
       ├─ PASS → Phase 5
       └─ FAIL → 退回 Phase 3 (附帶 FAIL_REASON)

Phase 5: DEPLOYMENT
  └─ $devops (GPT-4o) — CI/CD pipeline 產出
       └─ HANDOFF → $coordinator 歸檔
```

---

## 4. Agent 間的衝突解決規則

**[AI DIRECTIVE]**
When two agents produce conflicting outputs (e.g., Code Reviewer approves but Security Gate rejects), apply the following priority order:

1. `$security-gate` output ALWAYS takes precedence over `$code-reviewer`
2. `$coordinator` is the final arbiter for non-security conflicts
3. Any FAIL verdict from any agent MUST be documented in `SSDLC_TRACKER.md` (and optionally `AGENT_HANDOFF.md`) with the blocking reason clearly stated
4. Human developer approval is MANDATORY before overriding a `$security-gate` FAIL verdict

---

## 5. 模型降級規則

**[AI DIRECTIVE]**
If the assigned model is unavailable in the developer's GitHub Copilot subscription:

| Primary (Unavailable) | Fallback |
|-----------------------|----------|
| Gemini 2.0 Pro | Gemini 1.5 Pro, then Claude Sonnet 3.5 |
| Claude Sonnet 3.7 | Claude Sonnet 3.5, then o3-mini |
| GPT-4o | GPT-4.1, then GPT-4o-mini (non-critical tasks only) |

**[給人類開發者的說明]**
降級時，最重要的原則是「**審查者與產出者的模型必須不同**」。如果降級導致 Code Reviewer 和 Implementer 使用同一模型，應在 `SSDLC_TRACKER.md` 備註中標記 `model_parity_warning`，提醒這次審查的獨立性降低。

---

## 6. GitHub Copilot 多模型啟用設定

**[給人類開發者的說明]**
要在 VS Code 中啟用多模型 Agent 切換：

1. 確認 GitHub Copilot 訂閱為 **Copilot Pro** 或 **Copilot Enterprise**（才有 Claude / Gemini 模型選項）
2. 在 VS Code 設定中啟用：
   ```json
   // .vscode/settings.json
   {
     "github.copilot.chat.agent.thinkingTool": true,
     "github.copilot.chat.models": "all"
   }
   ```
3. 將 `.agents/agents/` 目錄下的 `.agent.md` 檔案安裝完成後，在 Chat 面板點選 `@` 符號就能看到各個 agent 並切換。
4. 每個 `.agent.md` 的 `model` 欄位定義了預設使用的 AI 模型。
