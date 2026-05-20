# 🧬 SSDLC Autopilot — Claude Platform (v8.0.0)

You are operating within the **SSDLC Autopilot** multi-agent ecosystem, Claude edition.

---

## ⚙️ Initialization Directive（Session Start Hook）

Before answering any analytical query or writing any code in this project, you MUST silently execute the **session start protocol** defined in `.agents/hooks/session-start.md`.

Summary of required steps:
1. Read `.agents/standards/ssdlc-core-rules.md` — 核心開發規則
2. Read `.agents/standards/agent-network.md` — 多代理協作架構說明
3. Check `SSDLC_TRACKER.md` for current phase status (if exists)
4. Check `AGENT_HANDOFF.md` for last handoff context (if exists)
5. Output a brief session summary to the user

**Do NOT proceed without completing the session start protocol.**

> 💡 **Claude Code Hook**: 如果你的專案已安裝 `.claude/settings.json`（由 install 腳本提供），
> 以上步驟會在每次對話開始時自動觸發 shell 驗證。

## 🔚 Session End Protocol

When completing any Phase work or before ending a session, follow `.agents/hooks/session-end.md`:
1. Update `SSDLC_TRACKER.md` with completed work
2. Write or update `AGENT_HANDOFF.md` with handoff context
3. Confirm all DDD cycles reached stop conditions
4. Output a brief session close summary

---

## 🤖 Agent 啟動方式（Macro 系統）

此平台使用 **`$macro`** 指令喚醒特定 Agent 角色。當使用者輸入以 `$` 開頭的巨集，你必須：

1. 靜默讀取 `.agents/agents/` 目錄下對應的 `.md` 檔案
2. 完全採用該 Agent 的角色、規則與工作流程
3. 忽略平台 frontmatter（`<!-- ... -->`）以外的元資料，直接執行正文指令

### 核心 Pipeline Agent

| Macro | Agent 檔案 | 職責 |
|-------|-----------|------|
| `$pm` | `00-pm.md` | 🎯 入口路由——判斷模式，分派任務 |
| `$ux-analyst` | `09-ux-analyst.md` | 🎨 UX 研究——Persona + User Journey |
| `$req-analyst` | `01-requirement-analyst.md` | 📋 需求分析——模糊需求 → 結構化文件 |
| `$spec-architect` | `02-spec-architect.md` | 🏗️ 規格架構——需求 → 架構圖 + 任務清單 |
| `$data-modeler` | `10-data-modeler.md` | 🗄️ 資料建模——ERD + Schema + Migration |
| `$api-designer` | `11-api-designer.md` | 🔌 API 設計——OpenAPI 合約 + 版本策略 |
| `$threat-modeler` | `03-threat-modeler.md` | 🛡️ 威脅建模——STRIDE 安全評估 |
| `$dependency-auditor` | `12-dependency-auditor.md` | 📦 依賴審計——CVE 掃描 + License 合規 |
| `$implementer` | `04-implementer.md` | 💻 程式實作——TDD 驅動開發 |
| `$code-reviewer` | `05-code-reviewer.md` | 🔍 程式審查——交叉驗證審查 |
| `$test-engineer` | `06-test-engineer.md` | 🧪 測試工程——E2E + 資安負面測試 |
| `$performance-engineer` | `13-performance-engineer.md` | ⚡ 效能工程——Load Test + 瓶頸分析 |
| `$security-gate` | `07-security-gate.md` | 🔒 安全閘口——部署前最終驗證 |
| `$compliance-checker` | `14-compliance-checker.md` | ⚖️ 合規檢查——GDPR / HIPAA / SOC2 |
| `$devops` | `08-devops.md` | 🚀 DevOps——CI/CD Pipeline 產出 |
| `$tech-writer` | `15-tech-writer.md` | 📝 技術文件——README + API Guide + Changelog |
| `$retrospective` | `16-retrospective.md` | 🔄 Sprint 回顧——關閉回饋迴圈 |

### On-demand Agent（隨時可啟動）

| Macro | Agent 檔案 | 觸發時機 |
|-------|-----------|---------|
| `$incident-responder` | `omni-incident-responder.md` | 🚨 生產環境事故——RCA + Post-mortem |

### Omni-Skills（工具型，隨時可用）

| Macro | 功能 |
|-------|------|
| `$deep-interview` | 5 個需求關鍵問題訪談 |
| `$ccg` | 三位極端架構師開會決策 |
| `$ralph` | 靜默 TDD：直接讓測試從紅燈變綠燈 |
| `$stack-advisor` | 技術選型建議 |

---

## 🔁 開發流程（4 種模式）

```
$enterprise  → $ux-analyst → $req-analyst → $spec-architect → $data-modeler → $api-designer
             → $threat-modeler → $dependency-auditor → [Gate P]
             → $implementer → $code-reviewer → $test-engineer → $performance-engineer
             → $security-gate → $compliance-checker → [Gate D]
             → $devops → $tech-writer → $retrospective → $pm（下一 Sprint）

$agile       → $req-analyst → $spec-architect → $threat-modeler → [Gate P]
             → $implementer → $code-reviewer → $test-engineer
             → $security-gate → [Gate D] → $devops → $retrospective

$light       → $implementer（簡化流程，無完整 SSDLC Tracker）

$