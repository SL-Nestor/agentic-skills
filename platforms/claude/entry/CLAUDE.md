# 🧬 SSDLC Autopilot — Claude Platform (v7.9.5)

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

### 可用 Agent 與對應 Macro

| Macro | Agent 檔案 | 職責 |
|-------|-----------|------|
| `$pm` | `00-pm.md` | 🎯 入口路由——判斷模式，分派任務 |
| `$req-analyst` | `01-requirement-analyst.md` | 📋 需求分析——模糊需求 → 結構化文件 |
| `$spec-architect` | `02-spec-architect.md` | 🏗️ 規格架構——需求 → 架構圖 + 任務清單 |
| `$threat-modeler` | `03-threat-modeler.md` | 🛡️ 威脅建模——STRIDE 安全評估 |
| `$implementer` | `04-implementer.md` | 💻 程式實作——TDD 驅動開發 |
| `$code-reviewer` | `05-code-reviewer.md` | 🔍 程式審查——交叉驗證審查 |
| `$test-engineer` | `06-test-engineer.md` | 🧪 測試工程——E2E + 資安負面測試 |
| `$security-gate` | `07-security-gate.md` | 🔒 安全閘口——部署前最終驗證 |
| `$devops` | `08-devops.md` | 🚀 DevOps——CI/CD Pipeline 產出 |

### Omni-Skills 個別召喚

| Macro | 功能 |
|-------|------|
| `$deep-interview` | 5 個需求關鍵問題訪談 |
| `$ccg` | 三位極端架構師開會決策 |
| `$ralph` | 靜默 TDD：直接讓測試從紅燈變綠燈 |
| `$stack-advisor` | 技術選型建議 |

---

## 🔁 開發流程（4 種模式）

```
$enterprise  → $spec-architect → $threat-modeler → $implementer → $code-reviewer
             → $test-engineer → $security-gate → $devops → $pm（歸檔）

$agile       → $req-analyst → $spec-architect → （同上）

$light       → $implementer（簡化流程，無完整 SSDLC Tracker）

$tactical    → $implementer（救火模式，載入 tactical-protocol）
```

---

## ⚠️ 交叉驗證說明（Claude 平台限制）

GitHub Copilot 版本會自動在不同 Agent 間切換 AI 模型（Claude/Gemini/GPT-4o）。
**在 Claude 平台，你始終使用 Claude。** 為維持交叉驗證精神，建議：

- `$threat-modeler`、`$code-reviewer` 步驟開啟**新的對話視窗**執行，確保上下文獨立
- 或改用 Gemini CLI 平台執行這兩個角色（使用本 repo 的 `platforms/gemini/` 安裝包）

---

## 📁 檔案引用慣例

所有 skills 路徑均相對於專案根目錄：
- Skills: `.agents/skills/{skill-name}/SKILL.md`
- Standards: `.agents/standards/{file}.md`
- Templates: `.agents/templates/{file}.md`
