# cavemem 記憶標準 — SSDLC Autopilot

> **狀態**：選用增強（Optional Enhancement）  
> **需求**：`npm install -g cavemem && cavemem install`  
> **版本**：v0.1.3+  
> **文件**：https://github.com/JuliusBrussee/cavemem

---

## 概念：為什麼 SSDLC 需要長期記憶？

SSDLC Autopilot 已有兩種短期記憶機制：

| 機制 | 適合 | 限制 |
|------|------|------|
| `AGENT_HANDOFF.md` | 上一次交接的結構化上下文 | 只記錄最後一次；被下一次覆寫 |
| `SSDLC_TRACKER.md` | Phase 完成狀態 | 進度表，非決策細節 |

cavemem 補上第三層：

| 機制 | 適合 | 特色 |
|------|------|------|
| **cavemem** | 所有跨會話的決策細節與理由 | 跨 Agent、跨 IDE、可搜尋、本地儲存 |

典型場景：
- 三週後回來繼續開發，問「我們當時為什麼選 Redis 而不是 Memcached？」
- 切換到 Gemini 審查，它需要知道 Claude 上次的架構決策理由
- Security Gate 查詢：「上次 threat-modeler 標記的 T-007 威脅，後來是怎麼緩解的？」

---

## 安裝與設定

```bash
npm install -g cavemem

# Claude Code
cavemem install

# Gemini CLI
cavemem install --ide gemini-cli

# OpenAI Codex
cavemem install --ide codex

# 查看狀態
cavemem status

# 瀏覽記憶（網頁介面）
cavemem viewer   # http://localhost:37777
```

安裝後，hooks 自動在 Claude Code 的 `UserPromptSubmit` 和 `Stop` 事件觸發，  
無需手動設定。與 SSDLC Autopilot 的既有 hooks 共存，不衝突。

---

## 各 Agent 的記憶指引

### 何時查詢（Session Start — Step 0）

| Agent | 建議查詢關鍵字 |
|-------|--------------|
| `$pm` / `$coordinator` | `"ssdlc phase"`, `"project status"`, `"last decision"` |
| `$req-analyst` | `"requirement conflict"`, `"business rule"`, `"user story"` |
| `$spec-architect` | `"architecture choice"`, `"tech stack"`, `"design pattern"` |
| `$threat-modeler` | `"threat model"`, `"stride"`, `"security risk"`, `"trust boundary"` |
| `$implementer` | `"implementation decision"`, `"tdd"`, `"refactor"` |
| `$code-reviewer` | `"code review"`, `"high severity"`, `"security fix"` |
| `$security-gate` | `"gate pass"`, `"gate fail"`, `"mitigation"`, `"override"` |
| `$devops` | `"deployment"`, `"iac"`, `"ci/cd"`, `"secret"` |

MCP 工具使用方式：

```
search("threat model authentication", limit: 5)
→ 返回過去 5 條相關記憶的摘要 + ID

get_observations(["obs_abc123", "obs_def456"], expand: true)
→ 返回完整內容（expand: true 展開壓縮文字供人類閱讀）

timeline(session_id: "sess_xyz", limit: 20)
→ 返回特定 session 的時間軸
```

### 何時記錄（Session End — Step 5）

每個 Agent 完成工作後，在 `[SSDLC OBSERVATION]` 區塊記錄：

**應記錄的內容（有利搜尋）：**
- 技術決策與理由（「選擇 JWT 而非 session cookie，因為需要無狀態橫向擴展」）
- 安全發現（「發現 IDOR 漏洞於 /api/orders/:id，需要 ownership check」）
- Gate 判決（「Security Gate PASS，T-003、T-007 緩解措施已驗證」）
- 被排除的選項（「排除 GraphQL，因為現有團隊無經驗且 REST 足夠」）

**不應記錄的內容（用 `<private>` 包裹或不記錄）：**
- 使用者的個人資訊
- API 金鑰、密碼、token（即使是測試用的）
- 客戶機密業務資料
- 任何不應跨會話持久化的暫時性資訊

```
<private>客戶名稱是 XYZ Corp，合約金額 $5M</private>
```

---

## 與既有 SSDLC 機制的分工

```
會話開始
  ↓
[Step 0] cavemem search → 過去決策（細節、理由）
  ↓
[Step 2] AGENT_HANDOFF.md → 上次停在哪、下一步
         SSDLC_TRACKER.md → 整體 Phase 進度
  ↓
工作執行中...
  ↓
[Step 1-4] 更新 AGENT_HANDOFF.md 和 SSDLC_TRACKER.md（同往常）
  ↓
[Step 5] 輸出 [SSDLC OBSERVATION] 摘要供 cavemem 捕捉
  ↓
會話結束（cavemem hooks 自動壓縮並寫入 SQLite）
```

**結論：三種機制互補，各司其職，不互相替代。**

---

## 隱私設定

cavemem 預設為純本地（Local by default）：

- 所有資料儲存於 `~/.cavemem/` 的 SQLite，不上傳任何地方
- `<private>...</private>` 內容在寫入前自動剝除
- 可在 `~/.cavemem/settings.json` 設定 `excludePatterns` 排除特定路徑

```json
{
  "privacy": {
    "excludePatterns": [
      "**/secrets/**",
      "**/.env*",
      "**/credentials/**"
    ]
  }
}
```

---

## 搜尋品質提示

cavemem 使用 **BM25 + 向量索引混合搜尋**。對 SSDLC 記憶，以下寫法更容易被找到：

| ❌ 模糊 | ✅ 精確 |
|--------|--------|
| 「我們決定了一些事」 | 「architecture decision: chose PostgreSQL over MongoDB」 |
| 「有個安全問題」 | 「threat T-003: SQL injection in /api/search endpoint」 |
| 「Gate 通過了」 | 「security gate PASS: all High threats mitigated」 |

使用英文關鍵詞有助於跨 Agent 搜尋一致性（因為不同 Agent 可能用不同語言輸出）。

---

## 故障排除

```bash
cavemem doctor          # 驗證安裝
cavemem status          # 查看 DB 計數、hook 設定、worker 狀態
cavemem search "test"   # 驗證搜尋功能
cavemem reindex         # 重建 FTS5 + 向量索引
```

若 cavemem 未安裝或不可用，SSDLC Autopilot 退回至僅使用 AGENT_HANDOFF.md 和 SSDLC_TRACKER.md——流程正常運作，不受影響。
