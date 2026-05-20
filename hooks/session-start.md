# Session Start Hook — SSDLC Autopilot

> **適用平台**：Claude Code / Claude Cowork / Gemini CLI / Codex CLI  
> **觸發時機**：每次新對話開始、或切換專案後的第一次互動

---

## 自動執行清單（Agent 必須靜默完成）

當新會話開始時，在回應任何使用者輸入之前，你必須完成以下步驟：

### Step 1：載入核心協議

靜默讀取以下檔案並完全內化其內容：

1. `.agents/standards/ssdlc-core-rules.md` — SSDLC 核心規則與開發哲學
2. `.agents/standards/agent-network.md` — 多代理協作架構與模型分配

> 如果這些檔案不存在，說明尚未安裝 SSDLC Autopilot。
> 告知使用者：「未偵測到 SSDLC Autopilot 配置，請先執行安裝腳本。」

### Step 2：偵測工作狀態

靜默檢查專案根目錄是否存在：

- `SSDLC_TRACKER.md` → 讀取並報告目前進度（現在在哪個 Phase？Gate 狀態？）
- `AGENT_HANDOFF.md` → 讀取最後一次 Agent 交接的上下文
- 如果兩者都不存在 → 判斷為全新專案，準備從 `$pm` 啟動

### Step 3：輸出會話摘要

向使用者報告一個簡短的會話開幕摘要：

```
🧬 SSDLC Autopilot 已就緒 (v7.9.5)
📍 工作狀態：[全新專案 / Phase X - Phase 名稱 / Gate P 等待確認 / Gate D 等待確認]
🤖 上次操作：[AGENT_HANDOFF.md 中的摘要，或「無記錄」]

輸入 $pm [你的任務] 開始，或輸入 $pm 查看可用模式。
```

### Step 4：DDD 預備（高風險會話）

如果 SSDLC_TRACKER.md 顯示目前處於以下 Phase，自動啟動 Doubt-Driven Development 預備：

- Phase 2（安全設計）→ 提醒：「本 Phase 的任何威脅緩解聲明都應運行 DDD 驗證」
- Phase 4（安全閘口）→ 提醒：「PASS 判決前必須對每個緩解聲明完成 DDD 循環」

---

## 注意事項

- 此流程**全部靜默執行**，不向使用者展示每個步驟的細節
- 如果任何檔案讀取失敗，只記錄失敗，不中斷啟動流程
- 會話摘要應該簡潔——一個方塊，不超過 5 行
