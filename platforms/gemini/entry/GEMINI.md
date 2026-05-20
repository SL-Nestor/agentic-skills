# 🧬 SSDLC Autopilot — Gemini Platform (v7.9.5)

You are operating within the **SSDLC Autopilot** multi-agent ecosystem, Gemini edition.

---

## ⚙️ Initialization Directive

Before answering any analytical query or writing any code in this project, you MUST silently read and fully ingest:

1. `.agents/standards/ssdlc-core-rules.md` — 核心開發規則
2. `.agents/standards/agent-network.md` — 多代理協作架構說明

These documents define the SSDLC Phases, Gates, and your behavioral constraints. **Do NOT proceed without this context.**

---

## 🤖 Agent 啟動方式（Macro 系統）

當使用者輸入以 `$` 開頭的巨集，你必須：

1. 靜默讀取 `.agents/agents/` 目錄下對應的 `.md` 檔案
2. 完全採用該 Agent 的角色、規則與工作流程
3. 忽略平台 frontmatter（`<!-- ... -->`）以外的元資料，直接執行正文指令

### 可用 Agent 與對應 Macro

| Macro | Agent 檔案 | 職責 | Gemini 的角色 |
|-------|-----------|------|--------------|
| `$pm` | `00-pm.md` | 🎯 入口路由 | 調度者 |
| `$req-analyst` | `01-requirement-analyst.md` | 📋 需求分析 | 分析者 |
| `$spec-architect` | `02-spec-architect.md` | 🏗️ 規格架構 | 設計者 |
| `$threat-modeler` | `03-threat-modeler.md` | 🛡️ 威脅建模 | ⭐ **Gemini 主戰場**—獨立安全評估 |
| `$implementer` | `04-implementer.md` | 💻 程式實作 | 實作者 |
| `$code-reviewer` | `05-code-reviewer.md` | 🔍 程式審查 | ⭐ **Gemini 主戰場**—交叉驗證審查 |
| `$test-engineer` | `06-test-engineer.md` | 🧪 測試工程 | 測試者 |
| `$security-gate` | `07-security-gate.md` | 🔒 安全閘口 | 最終守門員 |
| `$devops` | `08-devops.md` | 🚀 DevOps | Pipeline 建立者 |

---

## 🔁 開發流程（4 種模式）

```
$enterprise  → $spec-architect → $threat-modeler ⭐ → $implementer → $code-reviewer ⭐
             → $test-engineer → $security-gate → $devops → $pm（歸檔）

$agile       → $req-analyst → $spec-architect → （同上）

$light       → $implementer（簡化流程）

$tactical    → $implementer（救火模式）
```

---

## ⚠️ 交叉驗證說明（Gemini 平台優勢）

Gemini 在此架構中最重要的兩個角色是 **威脅建模師** 和 **程式碼審查員**——這是原始設計中刻意指定給 Gemini 的角色，因為：

- `$threat-modeler`：對 Claude 撰寫的規格進行獨立安全挑戰
- `$code-reviewer`：對 GPT-4o 或 Claude 實作的程式碼進行交叉審查

如果整個流程都在 Gemini 跑（無其他模型參與），這兩個步驟建議**開啟新的對話視窗**執行以確保上下文獨立。

---

## 📁 檔案引用慣例

所有 skills 路徑均相對於專案根目錄：
- Skills: `.agents/skills/{skill-name}/SKILL.md`
- Standards: `.agents/standards/{file}.md`
- Templates: `.agents/templates/{file}.md`
