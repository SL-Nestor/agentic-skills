# SSDLC Autopilot — Requirements v1.0
> **Author**: $req-analyst  
> **Date**: 2026-05-19  
> **Status**: Approved (Gate P pending)  
> **Version**: 1.0.0

---

## 1. 專案範圍 (Project Scope)

SSDLC Autopilot 是一個**多平台 AI 開發框架安裝工具**，讓任何軟體專案能夠一鍵安裝符合 SSDLC（Secure Software Development Lifecycle）規範的 9-Agent 協作系統，支援 Claude Code、Gemini CLI、OpenAI Codex、GitHub Copilot 四種平台。

**In Scope:**
- 安裝腳本（install.sh / install.ps1）的行為與安全性
- 9 個核心 Agent 的職責定義與行為規範
- 4 個 Omni-Skill（Ghost Skills）的完整實作
- Claude Code Hook 的 Gate 執行機制
- 測試套件（bats / Pester / BDD TESTS.md）
- GitHub Actions CI Pipeline

**Out of Scope:**
- 使用者專案本身的程式碼（那是 Agent 服務的對象）
- AI 模型訓練或 fine-tuning
- 商業授權管理

---

## 2. 功能需求 (Functional Requirements)

### FR-01: 多平台安裝

**Given** 使用者在專案根目錄執行安裝腳本，  
**When** 指定平台參數（claude / gemini / codex / copilot / all），  
**Then** 安裝腳本必須：
- 在目標目錄建立正確的資料夾結構（`.agents/agents/`, `.agents/skills/`, `.agents/standards/`, `.agents/templates/`, `.agents/hooks/`）
- 只複製該平台對應的 entry 檔案（CLAUDE.md / GEMINI.md / AGENTS.md / .github/copilot-instructions.md）
- 不安裝其他平台的 entry 檔案
- 在目標目錄不存在時自動建立

**Acceptance Criteria (BDD):**

```gherkin
Feature: 平台隔離安裝

  Scenario: 安裝 Claude 平台
    Given 目標目錄 /tmp/test-project 存在
    When 執行 install.sh /tmp/test-project claude
    Then 存在 /tmp/test-project/CLAUDE.md
    And 存在 /tmp/test-project/.claude/settings.json
    And 存在 /tmp/test-project/.agents/agents/00-pm.md
    And 不存在 /tmp/test-project/GEMINI.md
    And 不存在 /tmp/test-project/AGENTS.md

  Scenario: 安裝全平台
    Given 目標目錄 /tmp/test-project 存在
    When 執行 install.sh /tmp/test-project all
    Then 存在 /tmp/test-project/CLAUDE.md
    And 存在 /tmp/test-project/GEMINI.md
    And 存在 /tmp/test-project/AGENTS.md
    And 存在 /tmp/test-project/.github/copilot-instructions.md

  Scenario: 安裝至新目錄
    Given 目標目錄 /tmp/brand-new-project 不存在
    When 執行 install.sh /tmp/brand-new-project claude
    Then 自動建立 /tmp/brand-new-project
    And 安裝成功完成
    And 回傳 exit code 0
```

---

### FR-02: 現有設定保護

**Given** 目標專案已有 `.claude/settings.json`，  
**When** 安裝 Claude 平台，  
**Then** 安裝腳本必須：
- 不覆蓋現有的 settings.json
- 輸出明確的警告訊息，提示使用者手動合併
- 繼續安裝其他檔案（不中斷）

```gherkin
Feature: 設定檔保護

  Scenario: 現有 settings.json 保留
    Given 存在 /tmp/test-project/.claude/settings.json 內容為 {"custom": true}
    When 執行 install.sh /tmp/test-project claude
    Then /tmp/test-project/.claude/settings.json 內容仍為 {"custom": true}
    And stdout 包含 "already exists"
    And 回傳 exit code 0
```

---

### FR-03: Agent 召喚機制

**Given** SSDLC Autopilot 已安裝於專案，  
**When** 使用者在 Claude Code 輸入 `$pm [任務]`，  
**Then** Claude 必須：
- 靜默讀取 `.agents/agents/00-pm.md`
- 完全採用 PM Agent 的角色與規則
- 輸出符合 PM 格式的路由判斷

```gherkin
Feature: Macro 召喚

  Scenario: $pm 診斷未知模式需求
    Given SSDLC Autopilot 已安裝
    And 不存在 SSDLC_TRACKER.md
    When 使用者輸入 "$pm 我想做一個購物車功能"
    Then 輸出包含模式判斷（enterprise/agile/light/tactical 之一）
    And 輸出包含下一步指令
    And 不直接開始寫程式碼

  Scenario: $pm 偵測進行中工作
    Given 存在 SSDLC_TRACKER.md 顯示 Phase 3 進行中
    When 使用者輸入 "$pm"
    Then 輸出包含目前 Phase 狀態
    And 提供繼續或開始新任務的選項
```

---

### FR-04: Ghost Skills 完整實作

**Given** 使用者輸入以下 Omni-Skill macro，  
**Then** 每個 macro 都有對應的明確行為定義：

| Macro | 期望行為 |
|-------|---------|
| `$deep-interview` | 以 5 個結構化問題訪談使用者，涵蓋目標用戶、業務價值、限制、指標、禁止事項 |
| `$ccg` | 召喚三位極端架構師（Crazy/Clever/Grounded）辯論並達成決策 |
| `$ralph` | 靜默 TDD：讀取失敗測試 → 修正程式碼 → 報告紅燈變綠燈數量，不輸出中間過程 |
| `$stack-advisor` | 分析需求與限制，推薦技術選型並比較被排除的替代方案 |

```gherkin
Feature: Ghost Skills 行為

  Scenario: $deep-interview 完整訪談流程
    Given 使用者輸入 "$deep-interview 我想建一個通知系統"
    When $deep-interview 執行
    Then 輸出恰好 5 個問題
    And 問題涵蓋目標用戶
    And 問題涵蓋量化成功指標
    And 問題涵蓋技術與法規限制
    And 等待使用者回答後才繼續

  Scenario: $ccg 三架構師辯論
    Given 使用者輸入 "$ccg 我們應該用 REST 還是 GraphQL"
    When $ccg 執行
    Then 輸出包含 Crazy 架構師觀點（極端創新）
    And 輸出包含 Clever 架構師觀點（平衡可行）
    And 輸出包含 Grounded 架構師觀點（保守穩健）
    And 輸出包含三者共識或分歧點

  Scenario: $ralph 靜默 TDD
    Given 存在失敗的測試檔案 tests/auth.test.ts
    When 使用者輸入 "$ralph tests/auth.test.ts"
    Then 不輸出程式碼修改過程
    And 最終報告格式為 "✅ X/Y tests fixed"
    And 若有無法修復的測試，說明原因

  Scenario: $stack-advisor 技術選型
    Given 使用者描述需求（高並發、小團隊、需快速交付）
    When $stack-advisor 執行
    Then 輸出推薦技術棧及理由
    And 輸出至少 2 個被排除選項及排除原因
    And 標示各選項的 trade-off
```

---

### FR-05: Gate 執行機制

**Given** Claude Code 已安裝 SSDLC Autopilot hooks，  
**When** 使用者召喚 `$implementer`，  
**Then** Hook 必須在執行前檢查前置條件：

```gherkin
Feature: Gate P 執行

  Scenario: 前置條件齊全，允許實作
    Given 存在 docs/threat-model.md
    And 存在 docs/specs/requirements.md
    When 使用者輸入包含 "$implementer"
    Then Hook 輸出 "[SSDLC] Gate P: OK — threat model found"
    And 允許繼續執行

  Scenario: 缺少威脅模型，阻擋實作
    Given 不存在 docs/threat-model.md
    When 使用者輸入包含 "$implementer"
    Then Hook 輸出 "[SSDLC] Gate P: BLOCKED — run $threat-modeler first"
    And 提示使用者先執行 $threat-modeler

  Scenario: Gate D 部署前確認
    Given 存在 docs/security-gate-report.md 標記為 PASS
    When 使用者輸入包含 "$devops"
    Then Hook 輸出 "[SSDLC] Gate D: OK — security gate passed"
    And 允許繼續

  Scenario: 缺少安全閘口報告
    Given 不存在 docs/security-gate-report.md
    When 使用者輸入包含 "$devops"
    Then Hook 輸出 "[SSDLC] Gate D: BLOCKED — run $security-gate first"
```

---

### FR-06: 安裝腳本安全性

```gherkin
Feature: 安裝腳本安全性

  Scenario: 路徑遍歷攻擊防禦
    Given 攻擊者輸入 TargetDir 為 "../../etc"
    When 執行 install.sh "../../etc" claude
    Then 安裝腳本拒絕執行
    And 輸出錯誤訊息 "Invalid target directory"
    And 回傳 exit code 1

  Scenario: 安裝失敗不留殘留
    Given 安裝過程中模擬磁碟空間不足
    When install.sh 中途失敗
    Then 已複製的檔案被清理（rollback）
    And 目標目錄回到安裝前狀態
    And 回傳非零 exit code

  Scenario: 來源路徑驗證
    Given 腳本的 CORE_DIR 或 PLATFORMS_DIR 被竄改為不存在路徑
    When 執行 install.sh
    Then 腳本偵測到路徑無效
    And 輸出具體錯誤，不執行任何 cp 操作
```

---

## 3. 非功能需求 (Non-Functional Requirements)

### NFR-01: 效能
- install.sh 完整安裝（all 平台）必須在 **30 秒內**完成（本地 SSD）
- Hook 腳本回應時間 **< 500ms**（不阻塞使用者輸入）

### NFR-02: 可靠性
- install.sh 在以下環境必須無錯誤執行：
  - macOS 13+（bash 5.x）
  - Ubuntu 22.04+（bash 5.x）
  - Windows 11（PowerShell 7.x）
- install.sh 在 bash strict mode（`set -euo pipefail`）下必須通過

### NFR-03: 安全性
- 安裝腳本不得執行任何網路請求
- 不得在任何輸出中暴露使用者的 home 路徑或系統資訊
- settings.json 的 permissions.allow 範圍最小化原則

### NFR-04: 可維護性
- 每個 Agent 角色有對應的 TESTS.md（BDD 格式驗收標準）
- 版本變更在 plugin.json 的 `version` 欄位明確標示
- CHANGELOG.md 記錄每次版本的變更

### NFR-05: 可觀測性
- 安裝腳本每個重要步驟輸出可讀的 log 訊息
- Hook 腳本的執行結果必須輸出到 stdout（讓 Claude Code 可捕捉）

---

## 4. 限制條件 (Constraints)

- **技術**：只使用 bash / PowerShell 標準函式庫（不依賴 Python、Node 等外部工具）
- **相依性**：install.sh 不得要求使用者預先安裝任何工具（除了 bash 本身）
- **隱私**：`<private>` 標籤機制必須在文件規範中明確定義
- **授權**：所有產出採 MIT License

---

## 5. 開放問題與衝突 (Open Issues)

| ID | 描述 | 狀態 |
|----|------|------|
| OI-001 | `$tactical` 模式的完整 agent 定義尚未實作 | [OPEN] — 列入 Phase 4a 範圍 |
| OI-002 | Plugin Marketplace 安裝的 skill 如何存取 `.agents/agents/` | [OPEN] — 需要在 Phase 2 架構決策 |
| OI-003 | bats-core 是否需要納入 repo 或要求使用者預先安裝 | [OPEN] — 建議 CI 環境使用，本地可選 |
| OI-004 | 版本升級時已安裝專案如何更新 agent 文件 | [OPEN] — 列入後續 roadmap |

---

## 6. 驗收標準摘要 (Acceptance Criteria Summary)

| ID | 需求 | 測試類型 | 優先級 |
|----|------|---------|--------|
| FR-01 | 平台隔離安裝 | bats / Pester | 🔴 High |
| FR-02 | 現有設定保護 | bats / Pester | 🔴 High |
| FR-03 | Agent 召喚 | BDD TESTS.md | 🔴 High |
| FR-04 | Ghost Skills | BDD TESTS.md | 🟡 Medium |
| FR-05 | Gate 執行 | bats / TESTS.md | 🔴 High |
| FR-06 | 安裝腳本安全 | bats（安全負面測試）| 🔴 High |
| NFR-01 | 效能 | bats timing | 🟡 Medium |
| NFR-02 | 跨平台相容 | CI matrix | 🟡 Medium |
| NFR-03 | 安全性 | threat-modeler → implementer | 🔴 High |
