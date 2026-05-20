# Session End Hook — SSDLC Autopilot

> **適用平台**：Claude Code / Claude Cowork / Gemini CLI / Codex CLI  
> **觸發時機**：使用者明確結束工作、或 Agent 完成一個完整的工作單元

---

## 自動執行清單（Agent 在完成任何 Phase 工作後執行）

### Step 1：更新 SSDLC_TRACKER.md

將本次會話完成的工作更新到 tracker：

- 標記已完成的 Phase / 步驟（打勾）
- 記錄任何 Gate 狀態變更
- 更新「最後操作時間」與「操作 Agent」欄位

### Step 2：寫入 AGENT_HANDOFF.md

確保下一個 Agent（或下一個會話）能從正確的地方繼續：

```markdown
## Last Agent Handoff

- **From Agent**: [Agent 名稱] ($macro)
- **Completed**: [完成的任務摘要]
- **Output Artifacts**: [產出的檔案清單]
- **Next Step**: [建議下一個 macro 指令]
- **Blockers**: [任何阻塞項目，或「None」]
- **Context for Next Agent**: [下一個 Agent 需要知道的關鍵上下文]
```

### Step 3：DDD 循環確認

如果本次會話做了任何非瑣碎決策，確認：

- [ ] 所有 DDD 循環都已到達停止條件（不是中途中斷）
- [ ] 任何「Valid trade-off」分類的決策都已在相關文件中記錄

### Step 4：會話收尾摘要

向使用者展示簡短的工作收尾報告：

```
✅ 會話工作完成

完成項目：[本次完成的 1-3 項工作]
產出文件：[關鍵檔案列表]
下一步：執行 [建議的 macro] 繼續開發流程

SSDLC_TRACKER.md 與 AGENT_HANDOFF.md 已更新。
```

### Step 5：輸出 cavemem 友善的結構化摘要（如已安裝）

> 此步驟為**選用**，僅在 cavemem 已安裝時執行。
> cavemem 的 hooks 會自動捕捉會話內容；此步驟讓記憶**更精準可搜尋**。

在會話結尾，輸出一段結構化的摘要供 cavemem 捕捉：

```
[SSDLC OBSERVATION]
Project: [專案名稱或路徑]
Phase: [Phase 編號與名稱]
Agent: [執行的 Agent macro，如 $spec-architect]
Decisions:
  - [技術決策 1：選擇了 X 而非 Y，原因是 Z]
  - [安全決策 2：緩解了 STRIDE 威脅 T-003，使用 JWT 刷新機制]
Artifacts: [products/requirements.md, docs/architecture.mermaid]
Gate: [Gate P PASS / Gate D FAIL / 無 Gate]
Next: [$threat-modeler 分析認證邊界的 STRIDE 威脅]
<private>使用者提到的任何個人或機密資訊</private>
```

> **格式說明**：
> - 決策行使用主動語態（「選擇了」「緩解了」），有利於 cavemem 的語意壓縮與未來檢索
> - `<private>...</private>` 標籤內的內容在寫入 cavemem 前自動剝除，不會被記錄
> - 此摘要應在會話收尾報告（Step 4）**之後**輸出

---

## 注意事項

- 如果使用者沒有明確結束，但完成了一個完整的 Phase（例如 `$spec-architect` 交接給 `$threat-modeler`），也應執行此 hook
- Gate 等待中（Gate P / Gate D）時，在 tracker 中明確標記「等待人工確認」狀態
- cavemem 的自動 hooks 會捕捉會話全文；Step 5 的結構化摘要是**補充**，幫助 cavemem 在未來搜尋時優先找到關鍵決策
