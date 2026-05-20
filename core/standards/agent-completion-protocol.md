# Agent 完成報告協議 — SSDLC Autopilot

> **適用對象**：所有 Agent（$req-analyst、$spec-architect … $devops）  
> **觸發時機**：完成本 Phase 的全部工作後，在回應結尾強制執行

---

## 完成時必須執行的三個步驟

### Step 1：更新 SSDLC_TRACKER.md

```markdown
| Phase X | [Phase 名稱] | ✅ Done | — | $[macro 名稱] | [今日日期] |
```

若本 Phase 有 Gate，同步更新 Gate Summary 表格。

---

### Step 2：寫入 AGENT_HANDOFF.md

覆寫整份文件，使用以下格式：

```markdown
## Last Agent Handoff

- **From Agent**: $[macro 名稱]（[模型名稱，如 Claude / Codex]）
- **Phase Completed**: Phase [X] — [Phase 名稱]
- **Completed At**: [日期]

### 本次產出
| 檔案 | 說明 |
|------|------|
| `docs/[file].md` | [一行說明] |

### 本次關鍵決策
- [決策 1：選擇了 X 而非 Y，因為 Z]
- [決策 2：發現風險 R，採取緩解措施 M]

### 下一步
- **建議執行**：`$[next-agent-macro]`
- **前置條件**：[如有 Gate 需人工確認，在此說明]
- **輸入檔案**：`docs/[next-phase-input].md`

### 阻塞項目
[若無，填 None]
```

---

### Step 3：向使用者輸出完成報告

**格式固定，不可省略任何區塊：**

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅  Phase [X] — [Phase 名稱] 完成
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📄  產出文件
    • [檔案路徑 1] — [一行說明]
    • [檔案路徑 2] — [一行說明]

🔍  本次重點（最多 3 項）
    • [關鍵決策或發現]
    • [關鍵決策或發現]

📊  目前進度
    ✅ Phase 1 需求分析
    ✅ Phase 2 規格架構
    ✅ Phase 3 威脅建模      ← 剛完成
    ⏳ Gate P — 等待你確認
    ○  Phase 4 實作
    ○  Phase 5 審查
    ○  Phase 7 安全閘口
    ○  Phase 8 DevOps

⏭️  建議下一步
    執行 $[next-agent-macro]
    [一句話說明這個 Agent 會做什麼]

💬  你也可以
    • 直接說「確認」繼續
    • 提出修改意見，我來調整
    • 換一個 AI 繼續：AGENT_HANDOFF.md 已更新，新 AI 開啟專案後即可接手
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 各 Phase 的下一步對照表

### Enterprise 完整流程

| 當前 Phase | 建議下一步 | 前置條件 |
|-----------|-----------|---------|
| Phase 0 ux-analyst | `$req-analyst` | 無 |
| Phase 1 req-analyst | `$spec-architect` | 無 |
| Phase 2 spec-architect | `$data-modeler` | 無 |
| Phase 2a data-modeler | `$api-designer` | 無 |
| Phase 2b api-designer | `$threat-modeler` | 無 |
| Phase 3 threat-modeler | `$dependency-auditor` | 威脅全部 MITIGATED |
| Phase 3a dependency-auditor | Gate P 人工確認 | 無 High+ 未解決漏洞 |
| Gate P 確認後 | `$implementer` | 人工輸入「確認」 |
| Phase 4 implementer | `$code-reviewer` | 無 |
| Phase 5 code-reviewer | `$test-engineer` | 無 High findings |
| Phase 6 test-engineer | `$performance-engineer` | 所有測試通過 |
| Phase 6a performance-engineer | `$security-gate` | NFR 達標或已記錄缺口 |
| Phase 7 security-gate | `$compliance-checker` | 判決為 PASS |
| Phase 7a compliance-checker | Gate D 人工確認 | 無 Must Fix 未解決 |
| Gate D 確認後 | `$devops` | 人工輸入「確認」 |
| Phase 8 devops | `$tech-writer` | CI/CD 就緒 |
| Phase 9 tech-writer | `$retrospective` | 文件完成 |
| Phase 10 retrospective | `$pm`（下一 Sprint） | Action Items 已記錄 |

### Agile 精簡流程（跳過選用 Phase）

| 當前 Phase | 建議下一步 |
|-----------|-----------|
| Phase 1 req-analyst | `$spec-architect` |
| Phase 2 spec-architect | `$threat-modeler` |
| Phase 3 threat-modeler | Gate P |
| Gate P 後 | `$implementer` |
| Phase 4 implementer | `$code-reviewer` |
| Phase 5 code-reviewer | `$test-engineer` |
| Phase 6 test-engineer | `$security-gate` |
| Phase 7 security-gate | Gate D |
| Gate D 後 | `$devops` |
| Phase 8 devops | `$retrospective` |

### On-demand（不在主流程中，隨時可啟動）

| 觸發情境 | 使用 Agent |
|---------|-----------|
| 生產事故發生 | `$incident-responder` |

---

## 換 AI 時的說明

當你在完成報告中提到「換一個 AI 繼續」時，補充以下說明：

```
🔄  換 AI 繼續的方式
    1. 在新的 AI 工具中開啟本專案資料夾
    2. 新 AI 的 session-start hook 會自動讀取：
       • SSDLC_TRACKER.md  → 整體進度
       • AGENT_HANDOFF.md  → 上次做了什麼、下一步是什麼
    3. 輸入 $[next-agent-macro] 即可接手
```

---

## 注意事項

- 進度條中的 Phase 清單根據 `SSDLC_TRACKER.md` 的實際狀態動態填寫
- Gate P / Gate D 必須明確標示為「等待你確認」，不可自動跳過
- 若本 Phase 有未解決問題，列在「🔍 本次重點」中並標記 `[待確認]`
- 完成報告是給**人類**看的，不是給下一個 Agent 看的——用人話寫，不用技術術語堆砌
