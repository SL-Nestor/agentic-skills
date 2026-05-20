# SSDLC Autopilot — Threat Model v1.0
> **Author**: $threat-modeler (independent context)  
> **Date**: 2026-05-19  
> **Scope**: install.sh, install.ps1, settings.json hooks, agent 載入機制  
> **Method**: STRIDE  
> **Status**: Gate P pending

---

## 信任邊界 (Trust Boundaries Recap)

| TB-ID | 邊界 | 來源 | 目標 |
|-------|------|------|------|
| TB-01 | 使用者輸入 → 檔案系統 | TargetDir 參數 | cp / mkdir 操作 |
| TB-02 | 使用者輸入 → Agent 行為 | macro 指令字串 | Hook 觸發 |
| TB-03 | 安裝腳本 → 現有設定 | install.sh 執行 | .claude/settings.json |
| TB-04 | repo 來源 → 目標複製 | core/ / platforms/ | .agents/ |

---

## STRIDE 威脅登記表

### 🔴 High / Critical

| ID | STRIDE | 邊界 | 威脅描述 | 業務影響 | 緩解措施 | 狀態 |
|----|--------|------|---------|---------|---------|------|
| T-SEC-001 | **Tampering** | TB-01 | `TargetDir` 參數含路徑遍歷（`../../etc/`），install.sh 將 core/ 內容寫入系統目錄 | 系統檔案覆寫、任意寫入 | 安裝前驗證 TargetDir：必須為相對路徑或在 $HOME 下；拒絕含 `..` 的路徑 | ⏳ Open |
| T-SEC-002 | **Elevation of Privilege** | TB-02 | 使用者以 `$implementer` 繞過 Gate P（未做威脅建模就開始實作），AI 接受指令 | 跳過安全評估、引入未審查漏洞 | Hook 在 `UserPromptSubmit` 偵測 `$implementer` 關鍵字，檢查 `docs/threat-model.md` 存在性 | ⏳ Open |
| T-SEC-003 | **Elevation of Privilege** | TB-02 | 使用者以 `$devops` 繞過 Gate D（未完成 Security Gate 就部署），AI 接受指令 | 帶漏洞的程式碼被部署到生產環境 | Hook 偵測 `$devops` 關鍵字，檢查 `docs/security-gate-report.md` 存在且標記 PASS | ⏳ Open |
| T-SEC-004 | **Tampering** | TB-03 | install.sh 在使用者已有自訂 settings.json 時覆寫（若判斷邏輯有 bug），破壞 Claude Code 設定 | 使用者現有工作流程中斷 | 明確的 `-f` 旗標確認、先讀取再比對、只在不存在時寫入；測試覆蓋此案例 | ⏳ Open |

### 🟡 Medium

| ID | STRIDE | 邊界 | 威脅描述 | 業務影響 | 緩解措施 | 狀態 |
|----|--------|------|---------|---------|---------|------|
| T-SEC-005 | **Information Disclosure** | TB-02 | Hook 腳本錯誤時將系統路徑（home dir、專案路徑）輸出到 stdout，Claude Code 捕捉並顯示 | 洩漏本地路徑資訊 | Hook 腳本只輸出固定格式訊息；錯誤時 `exit 0`（不阻斷）但不輸出路徑 | ⏳ Open |
| T-SEC-006 | **Denial of Service** | TB-01 | TargetDir 指向網路掛載點（NFS/SMB），install.sh 因 I/O 等待導致無限掛起 | 安裝卡住，使用者無法中斷 | 對 mkdir / cp 操作設定 timeout（`timeout 30 cp -Rf ...`）；bash strict mode 確保失敗時退出 | ⏳ Open |
| T-SEC-007 | **Repudiation** | TB-04 | 安裝後無法確認安裝的 core/ 版本是否與 repo 一致（無 checksum） | 使用者跑的是被篡改版本的 agent 規則 | 在安裝完成後輸出關鍵檔案的 sha256 checksum；CI 驗證 checksum | ⏳ Open |
| T-SEC-008 | **Spoofing** | TB-02 | 惡意 macro 名稱（`$implementer-hack`）被 Hook 誤判為 Gate 通過或阻擋 | Gate 執行邏輯錯誤 | Hook 使用**字串精確比對**而非 grep/contains；正則表達式錨定詞邊界 | ⏳ Open |

### 🟢 Low

| ID | STRIDE | 邊界 | 威脅描述 | 緩解措施 | 狀態 |
|----|--------|------|---------|---------|------|
| T-SEC-009 | **Information Disclosure** | TB-04 | `cp -Rf` 在 verbose 模式下輸出所有複製路徑 | 預設不用 `-v`；只有明確指定 `--verbose` 時輸出 | ⏳ Open |
| T-SEC-010 | **Tampering** | TB-04 | 若 core/ 目錄不存在（不完整 clone），install.sh 的 `cp` 靜默失敗（不帶 `-e` 旗標時） | bash strict mode `set -e` + 安裝前驗證 CORE_DIR 存在性 | ⏳ Open |

---

## 安全需求注入（注入 tasks.md）

以下任務由威脅建模師注入，標記為 🛡️ 安全需求：

```gherkin
🛡️ Scenario: T-SEC-001-impl 路徑驗證函式
  Given TargetDir 輸入為 "../../etc"
  When validate_target_path() 執行
  Then 函式回傳非零 exit code
  And 不執行任何 mkdir 或 cp 操作

🛡️ Scenario: T-SEC-002-impl Gate P Hook 精確比對
  Given UserPromptSubmit 事件，輸入含 "$implementer-extra"
  When Hook 執行
  Then 不觸發 Gate P 阻擋（因為不是精確的 $implementer）

🛡️ Scenario: T-SEC-007-impl Checksum 輸出
  Given install.sh 完成安裝
  When 執行結束前
  Then 輸出 ssdlc-core-rules.md 的 sha256 值
```

---

## 與架構師決策的對照（交叉驗證）

> 以下為 $threat-modeler 對 $spec-architect 架構決策的獨立評估

| 架構決策 | 威脅建模師評估 | 建議 |
|---------|--------------|------|
| Hook 使用 shell script 檢查檔案存在性 | ✅ 合理，快速，無網路依賴 | 確保 Hook 腳本有單元測試 |
| Plugin skill 嵌入完整行為（雙模式） | ✅ 消除了 OI-002 的依賴風險 | 確保 plugin skills 不包含路徑資訊 |
| 安裝腳本不依賴外部工具 | ✅ 減少供應鏈攻擊面 | 維持此原則 |
| 現有 settings.json 不覆寫 | ✅ 但需要測試覆蓋 | T-SEC-004 必須有 bats 測試案例 |

---

## 總結

- **Critical/High 威脅**：4 個（T-SEC-001 到 T-SEC-004），全部需要在 Phase 4 實作緩解
- **Medium 威脅**：4 個，建議在 Phase 4 同步處理
- **Low 威脅**：2 個，可延後到後續版本
- **Gate P 建議**：所有 High 威脅已有明確緩解方案，架構設計可行，**建議核准進入 Phase 4**
