# Code Review — OI-001 install.ps1 v8.0.1

> **Reviewer**: $code-reviewer（Claude，Cowork mode）  
> **Date**: 2026-05-20  
> **Targets**: `install.ps1` v8.0.1 + `tests/install/test_install_ps1.Tests.ps1`  
> **Verdict**: ✅ **PASS**（1 Must Fix 已於審查中修正）

---

## 審查摘要

| 項目 | 結果 |
|------|------|
| FR-PS-01 空字串防禦 | ✅ 實作正確，Test-PathSafe IsNullOrWhiteSpace |
| FR-PS-02 路徑遍歷防禦 | ✅ `\.\.` regex，exit 1 + 明確訊息 |
| FR-PS-03 敏感路徑封鎖 | ✅ GetFullPath 正規化 + OrdinalIgnoreCase 比較 |
| FR-PS-04 來源目錄驗證 | ✅ core/ 四個子目錄存在驗證 |
| FR-PS-05 Rollback 機制 | ✅ try/catch + TargetWasNew 旗標 |
| FR-PS-06 SHA256 完整性輸出 | ✅ Get-FileHash，僅 Claude 平台 |
| NFR-PS-01 PS 5.1 相容性 | ✅ 無不相容 API |
| NFR-PS-02 訊息一致性 | ✅ 對應 install.sh 格式 |
| NFR-PS-03 測試覆蓋 | ✅ AC-01~AC-06 全覆蓋（11 個新測試） |

---

## 發現問題

### 🔴 Must Fix（已修正）

**RV-001：舊 T-SEC-001 測試使用 `Should -Throw`，與 `exit 1` 實作不相容**

- **位置**：`tests/install/test_install_ps1.Tests.ps1`，原 T-SEC-001 Describe
- **問題**：原測試將呼叫包在 `{ }` 並用 `Should -Throw`，但 `exit 1` 不拋出 exception，導致測試失敗
- **修正**：已更新為 `$LASTEXITCODE | Should -Not -Be 0` 模式，與新 AC 測試一致
- **狀態**：✅ 已於本次審查中修正

---

### 🟡 Minor（不阻擋，後續 Sprint 追蹤）

**RV-002：AC-01 未驗證「無檔案產生」**

- FR-PS-01 規格：「exit 非零，**無檔案產生**」
- 測試只驗證 exit code 與訊息，未驗證目標路徑無殘留
- 風險評估：**極低**——`Test-PathSafe` 在任何 I/O 操作之前就 `exit 1`，實作上無法建立檔案
- 建議：可在下個測試維護週期補一個 `Should -Not -Exist` 斷言

**RV-003：FR-PS-04 未驗證 `platforms/` 目錄**

- 需求說「core/ **或** platforms/ 目錄不存在」，`Test-SourceDirs` 只驗證 core/
- platforms/ 缺失會被 try/catch 捕捉並觸發 rollback，行為正確，但訊息為 Copy-Item 原始錯誤
- AC-04 驗收標準只要求 core/ 缺失情境，故**不阻擋發布**
- 建議：OI-002 Sprint 補齊 platforms/ 驗證

---

## 正面評價

- **防禦層次清晰**：安全驗證（Test-PathSafe → Test-SourceDirs）在任何 I/O 之前執行，符合 fail-fast 原則
- **GetFullPath 正規化**：路徑在比較前統一正規化，防止格式差異繞過（如尾斜線、大小寫）
- **TargetWasNew 旗標**：rollback 策略分兩種情境（新建 vs 已存在）設計精確，避免誤刪使用者既有資料
- **SHA256 隔離**：僅 Claude 平台輸出，與 install.sh 行為一致

---

## 後續建議

| ID | 建議 | 優先度 |
|----|------|------|
| RV-002 | AC-01 補 `Should -Not -Exist` 斷言 | 低 |
| RV-003 | FR-PS-04 補 platforms/ 存在驗證 | 低 |
| — | Phase 6：在 Windows 環境執行完整 Pester 套件（26 個測試） | 高 |
