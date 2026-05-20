# Session Start Hook — SSDLC Autopilot

> **適用平台**：Claude Code / Codex CLI / Gemini CLI  
> **觸發時機**：每次新對話開始、或切換專案後的第一次互動

---

## 自動執行清單（Agent 必須靜默完成，再輸出儀表板）

### Step 0：查詢長期記憶（cavemem，如已安裝）

> 此步驟為**選用**。若 MCP 工具清單中有 `search`、`timeline`、`get_observations`，代表 cavemem 已啟用。

若 cavemem MCP 可用，靜默執行：

```
search("ssdlc phase decision")
search("threat model security")
search("architecture choice")
search("gate pass fail")
```

將結果與 Step 2 的檔案合併，形成完整上下文。

---

### Step 1：載入核心協議

靜默讀取：
1. `.agents/standards/ssdlc-core-rules.md`
2. `.agents/standards/agent-network.md`

> 若這些檔案不存在，告知使用者：「未偵測到 SSDLC Autopilot 配置。請執行安裝腳本。」並停止。

---

### Step 2：讀取專案狀態

靜默讀取：
- `SSDLC_TRACKER.md` → 每個 Phase 的完成狀態、Gate 狀態
- `AGENT_HANDOFF.md` → 上次 Agent 的產出、決策、建議下一步

若兩者都不存在 → 全新專案，儀表板輸出「全新專案」狀態。

---

### Step 3：輸出進度儀表板

**這是使用者看到的第一個輸出，格式固定：**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧬  SSDLC Autopilot v8.0.0 已就緒
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁  專案：[從 TRACKER 讀取專案名稱，或使用當前目錄名]
🤖  上次由：[$macro 名稱]（[模型名稱]）操作於 [日期]

📊  開發進度
    ✅ Phase 1  需求分析       [若完成]
    ✅ Phase 2  規格架構       [若完成]
    ✅ Phase 3  威脅建模       [若完成]
    🔒 Gate P   人工確認       [✅已確認 / ⏳等待你確認]
    ▶  Phase 4  實作           [若進行中，標示 ▶]
    ○  Phase 5  程式審查       [若未開始]
    ○  Phase 6  測試           [若未開始]
    ○  Phase 7  安全閘口       [若未開始]
    🔒 Gate D   人工確認       [✅已確認 / ⏳等待你確認]
    ○  Phase 8  DevOps         [若未開始]

📋  上次產出
    [從 AGENT_HANDOFF.md 摘取，列出 1-3 個關鍵檔案]

⏭️  下一步
    [從 AGENT_HANDOFF.md 讀取建議指令，如 $implementer]
    [若有 Gate 等待確認，說明：「輸入『確認』繼續，或提出問題」]

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

**全新專案時的格式：**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🧬  SSDLC Autopilot v8.0.0 已就緒
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📁  全新專案 — 尚未開始

⏭️  輸入以下指令開始：
    $pm [你的任務描述]
    範例：$pm 建立一個 JWT 認證系統

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Step 4：DDD 預備（高風險 Phase）

若 TRACKER 顯示目前在 Phase 3 或 Phase 7，在儀表板下方附加：

```
⚠️  DDD 提醒：本 Phase 的任何緩解聲明，在宣告有效前須通過 $doubt-driven-development 驗證。
```

---

## 注意事項

- Step 0-2 **完全靜默**，使用者只看到 Step 3 的儀表板
- 儀表板中，未完成的 Phase 用 `○` 表示，進行中用 `▶`，完成用 `✅`
- Gate 用 `🔒` 標示，並明確說明是否等待人工確認
- 若 TRACKER 有任何欄位讀取失敗，用 `?` 填入，不中斷啟動流程
- 儀表板之後不要再補充任何文字，等待使用者指令
