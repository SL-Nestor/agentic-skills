# OI-001 需求規格 — install.ps1 安全強化

> **Sprint**: OI-001  
> **模式**: $agile  
> **目標**: 使 install.ps1 達到與 install.sh 相同的安全等級

---

## 功能需求

### FR-PS-01：空字串防禦
**Given** 使用者執行 `.\install.ps1 -TargetDir ""`  
**When** 腳本啟動  
**Then** 輸出錯誤訊息並以非零 exit code 終止，**不建立任何檔案**

### FR-PS-02：路徑遍歷防禦
**Given** 使用者輸入 `-TargetDir "..\..\Windows"`  
**When** 腳本啟動  
**Then** 偵測到 `..`，輸出 `Error: path traversal detected`，exit 1

### FR-PS-03：敏感系統路徑阻擋
**Given** 使用者輸入 `-TargetDir "C:\Windows"` 或 `C:\Windows\System32`  
**When** 腳本執行路徑驗證  
**Then** 輸出 `Error: sensitive system path`，exit 1  
**受保護路徑**：`C:\Windows`、`C:\Program Files`、`C:\Program Files (x86)`、`C:\System32`

### FR-PS-04：來源目錄驗證
**Given** `core/` 或 `platforms/` 目錄不存在  
**When** 腳本啟動  
**Then** 輸出 `Error: core/ directory not found`，exit 1

### FR-PS-05：Rollback 機制
**Given** 安裝過程中任何步驟發生例外（Exception）  
**When** `$ErrorActionPreference = "Stop"` 捕捉到錯誤  
**Then** 已複製的目標檔案與目錄被清除，輸出 `Rollback complete.`

### FR-PS-06：完整性驗證輸出
**Given** Claude 平台安裝成功  
**When** 安裝完成後  
**Then** 輸出 `ssdlc-core-rules.md` 的 SHA256 hash（使用 `Get-FileHash`）

---

## 非功能需求

### NFR-PS-01：相容性
- 支援 PowerShell 5.1（Windows 內建）與 PowerShell 7+
- 不依賴任何額外模組

### NFR-PS-02：錯誤訊息一致性
- 錯誤訊息格式與 install.sh 對應項目保持一致，方便使用者對照文件

### NFR-PS-03：測試可驗證
- 所有 FR 必須有對應的 Pester v5 測試覆蓋

---

## 驗收標準

| ID | 情境 | 預期結果 |
|----|------|---------|
| AC-01 | `-TargetDir ""` | exit 非零，無檔案產生 |
| AC-02 | `-TargetDir "..\..\etc"` | exit 1，含 `path traversal` 訊息 |
| AC-03 | `-TargetDir "C:\Windows"` | exit 1，含 `sensitive system path` 訊息 |
| AC-04 | core/ 不存在 | exit 1，含 `core/ directory not found` 訊息 |
| AC-05 | 安裝中途失敗 | 目標目錄清除，輸出 `Rollback complete.` |
| AC-06 | Claude 平台安裝成功 | 輸出含 SHA256 hash 的一行訊息 |
