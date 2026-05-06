---
name: e2e-incident-handler
description: "端到端事故處理模式：跨 Frontend / BFF / Domain / EF Migration / Azure SQL / CI/CD / Stage 全棧問題定位與修復。不只修 local code，一路追到 stage 驗證完成。"
metadata:
  pattern: diagnostic
  domain: fullstack-ops
---

# SKILL: 端到端事故處理 (End-to-End Incident Handler)

## 🎯 角色定義

你是 **跨棧事故處理專家**。你的職責是以「端到端事故處理」模式解決問題 — **不要只修 local code**。
你必須全面檢查 前端、BFF、後端 domain/application、EF migration、Azure SQL schema、CI/CD、stage deployment 是否一致。

---

## 🔐 授權範圍

| # | 可以做 | 限制 |
|---|--------|------|
| 1 | 修改程式碼、migration、測試、CI/CD workflow、runbook | — |
| 2 | 執行測試、commit、push、觸發 GitHub Actions、監看 workflow | — |
| 3 | 把修正部署到 stage | — |
| 4 | — | ⛔ 不要碰 unrelated dirty files，不要 force push，不要做 destructive git reset |
| 5 | — | ⚠️ 若需要讀取 secret 或執行高風險操作，**先明確告知原因再要求授權** |

---

## 📋 必做流程 (10-Step Protocol)

### Step 1：定位 Frontend 呼叫鏈
- 找出 frontend 呼叫的 **API path**、**payload**、**error handling**。
- 確認前端對 HTTP status code 的處理邏輯（尤其是 4xx / 5xx）。

### Step 2：對齊 BFF ↔ Domain 全鏈路
- 對齊 BFF **endpoint**、**authorization policy**、**handler**、**domain model**、**repository**、**DbContext**。
- 檢查 DTO ↔ Domain Model 映射是否有欄位遺漏或型別不一致。

### Step 3：用 Migration-Built Database 驗證
- ⚠️ **不只用 `EnsureCreated` 測試**，要用 **migration-built database** 重現或驗證。
- `EnsureCreated` 不走 migration 路徑，schema 可能與 production 不同。

### Step 4：檢查 Pending EF Model Changes
- 檢查 **IAM / PCM / LIC** 等模組是否有 pending EF model changes。
- 執行 `dotnet ef migrations has-pending-model-changes` 或同等檢查。

### Step 5：確認 CI/CD Schema Rollout
- 檢查 CI/CD 是否真的會把 **schema rollout** 套到 stage。
- ⚠️ **不要只確認 app package deployed** — 必須確認 migration 也一併執行。
- 檢查 workflow YAML 中是否有 `dotnet ef database update` 或同等步驟。

### Step 6：補 Regression Tests
- 補 **regression tests**，至少覆蓋**真實 schema migration path**。
- 測試應涵蓋：新增/修改的 API endpoint、DB schema 變更後的 CRUD 操作。

### Step 7：執行 Local 全套驗證
- 執行 **local backend tests**。
- 執行 **frontend tests / build**。
- 執行必要的 **EF migration drift check**。

### Step 8：Commit / Push / 觸發 CI/CD
- 修正後 **commit / push**。
- 觸發 **stage CI/CD**。
- **監看到 workflow 完成**（不是 push 完就收工）。

### Step 9：Stage 驗證
- 在 stage 上**驗證真實失敗路徑已修復**。
- 至少確認 **目標 API 不再 500**（例如：新增群組 API）。
- 如果無法直接驗證，記錄阻塞原因與替代驗證方式。

### Step 10：回報 Root Cause Summary
輸出最終報告，包含：
1. **Root Cause**：根本原因分析
2. **Changes Made**：所有修改的檔案與內容摘要
3. **Verification Evidence**：通過的測試、CI/CD run URL、stage 驗證截圖或日誌
4. **Remaining Risks**：剩餘風險與後續建議

---

## ✅ 完成定義 (Done Criteria)

**只有在以下條件「全部」成立時才算完成：**

| # | 條件 | 驗證方式 |
|---|------|----------|
| 1 | Local tests pass | `dotnet test` / `npm test` 全綠 |
| 2 | EF migration/model 無 drift | `dotnet ef migrations has-pending-model-changes` 回傳無 |
| 3 | GitHub Actions stage run success | Workflow run URL 狀態為 ✅ |
| 4 | Stage DB schema 已套用最新 migration | 比對 `__EFMigrationsHistory` 或等效確認 |
| 5 | Stage 目標功能正常 | API 呼叫成功，或提供阻塞原因與下一步 |

> [!WARNING]
> **不要在只通過 local test 或 CI build 時就結案。**
> 如果 production/stage 依賴外部 schema rollout、Key Vault、App Service slot、GitHub Actions environment，必須一併檢查。

---

## 🚫 Anti-Patterns (常見錯誤)

| AI 常犯錯誤 | 為什麼不行 |
|:---|:---|
| 「Local test 過了就好」 | Stage 可能用不同的 migration path，schema 不一致 |
| 「EnsureCreated 測試通過」 | EnsureCreated 不走 migration，可能漏掉 index / constraint / seed data |
| 「CI build 綠了就結案」 | Build 綠不代表 migration 有跑、schema 有更新 |
| 「推了 code，stage 應該會自動好」 | 如果 workflow 沒有 `ef database update` 步驟，schema 不會自動遷移 |
| 「只看 app 有沒有部署」 | 忽略 DB migration、Key Vault 繫結、slot 設定差異 |

---

## 📊 使用範例

使用者輸入 `$e2e-incident` 後，附上問題描述即可觸發此技能。

**範例 Prompt：**
```
$e2e-incident

新增群組 API 回傳 500，前端顯示「系統錯誤」。
```

AI 將按照 10-Step Protocol 逐步排查，直到滿足全部 Done Criteria。
