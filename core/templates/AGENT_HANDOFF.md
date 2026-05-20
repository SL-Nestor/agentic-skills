# Agent Handoff — [專案名稱]

> **給接手 AI 的說明**：這份文件是你接手工作的唯一來源。
> 開啟這個專案後，先讀這份文件，10 秒內就能知道現在的狀態與下一步。

---

## ⚡ 快速接手摘要

```
專案：[專案名稱]
目前階段：Phase [X] — [Phase 名稱]（[完成 / 進行中 / 等待確認]）
上次操作：$[macro 名稱]（[Claude / Codex / Gemini]）於 [日期]
下一步：執行 $[next-agent-macro]
阻塞項目：[若有 Gate 需確認，說明；否則填 None]
```

---

## 📊 整體進度

| Phase | 名稱 | 狀態 | 操作 Agent | 日期 |
|-------|------|------|-----------|------|
| Phase 1 | 需求分析 | ⬜ 待開始 | — | — |
| Phase 2 | 規格架構 | ⬜ 待開始 | — | — |
| Phase 3 | 威脅建模 | ⬜ 待開始 | — | — |
| Gate P | 人工確認 | ⬜ 待確認 | — | — |
| Phase 4 | 實作 | ⬜ 待開始 | — | — |
| Phase 5 | 程式審查 | ⬜ 待開始 | — | — |
| Phase 6 | 測試 | ⬜ 待開始 | — | — |
| Phase 7 | 安全閘口 | ⬜ 待開始 | — | — |
| Gate D | 人工確認 | ⬜ 待確認 | — | — |
| Phase 8 | DevOps | ⬜ 待開始 | — | — |

**狀態說明**：⬜ 待開始 ｜ 🔄 進行中 ｜ ✅ 完成 ｜ ⏳ 等待人工確認 ｜ ❌ 失敗

---

## 📄 產出文件清單

| Phase | 檔案 | 說明 | 狀態 |
|-------|------|------|------|
| Phase 1 | `docs/requirements.md` | BDD 需求規格 | ⬜ |
| Phase 2 | `docs/architecture.md` | 架構圖 + 信任邊界 | ⬜ |
| Phase 2 | `docs/tasks.md` | 開發任務清單 | ⬜ |
| Phase 3 | `docs/threat-model.md` | STRIDE 威脅模型 | ⬜ |
| Phase 5 | `docs/review.md` | 程式審查報告 | ⬜ |
| Phase 7 | `docs/security-gate-report.md` | 安全閘口報告 | ⬜ |
| Phase 8 | `.github/workflows/ci.yml` | CI/CD Pipeline | ⬜ |

---

## 🔍 上次 Agent 的關鍵決策

> 接手 AI 必須知道的決策背景，不需要重新分析

| 決策 | 選擇了 | 理由 |
|------|--------|------|
| [待填寫] | — | — |

---

## ⚠️ 未解決問題

| ID | 嚴重度 | 說明 | 是否阻擋下一步 |
|----|--------|------|--------------|
| — | — | — | — |

---

## 💬 給下一個 AI 的補充說明

> 上次 Agent 想特別交代的事——範例：「Task T-003 的實作比預期複雜，建議 $implementer 先從 auth-service.ts 入手」

[由各 Agent 完成後填寫]

---

## 📝 Changelog

| 版本 | 日期 | Agent | 更新內容 |
|------|------|-------|---------|
| v0.1 | [日期] | $pm | 初始建立 |
