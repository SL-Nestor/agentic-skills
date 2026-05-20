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

---

## 注意事項

- 如果使用者沒有明確結束，但完成了一個完整的 Phase（例如 `$spec-architect` 交接給 `$threat-modeler`），也應執行此 hook
- Gate 等待中（Gate P / Gate D）時，在 tracker 中明確標記「等待人工確認」狀態
