# SSDLC Autopilot — BDD Task List v1.0
> **Author**: $spec-architect  
> **Date**: 2026-05-19

---

## Feature: 安裝腳本強化 (install.sh / install.ps1)

```gherkin
Scenario: T-001 路徑遍歷防禦
  Given TargetDir 輸入為 "../../etc/passwd"
  When 執行 install.sh
  Then 立即拒絕，exit 1，輸出 "Invalid target directory"

Scenario: T-002 失敗 rollback
  Given 安裝過程模擬在複製 skills/ 時失敗
  When install.sh 中途退出
  Then 目標目錄不留下任何部分安裝的檔案

Scenario: T-003 bash strict mode 相容
  Given 以 "bash -euo pipefail install.sh" 執行
  When 任何指令回傳非零
  Then 腳本立即停止，不繼續執行後續步驟

Scenario: T-004 平台隔離
  Given 執行 install.sh /tmp/proj claude
  When 安裝完成
  Then .github/copilot-instructions.md 不存在
  And GEMINI.md 不存在
  And AGENTS.md 不存在
```

## Feature: Ghost Skills

```gherkin
Scenario: T-005 $deep-interview 輸出恰好 5 問
  Given 使用者輸入 "$deep-interview 我要做一個登入系統"
  When Agent 執行
  Then 輸出問題數量為 5（不多不少）
  And 包含「目標用戶」相關問題
  And 包含「成功指標」相關問題

Scenario: T-006 $ccg 三聲音明確區分
  Given 使用者提出技術決策問題
  When $ccg 執行
  Then 輸出有明確標示 [Crazy]、[Clever]、[Grounded] 三個區塊
  And 每個區塊有不同的立場

Scenario: T-007 $ralph 不輸出中間過程
  Given 存在測試檔案且有 2 個失敗
  When 使用者輸入 "$ralph tests/foo.test.ts"
  Then 輸出不包含任何中間推理或程式碼片段
  And 最終輸出格式符合 "✅ X/Y tests fixed"

Scenario: T-008 $stack-advisor 包含被排除選項
  Given 使用者描述高並發 API 需求
  When $stack-advisor 執行
  Then 輸出推薦選項及理由
  And 輸出至少 1 個被排除選項及排除原因
```

## Feature: Gate 執行機制

```gherkin
Scenario: T-009 Gate P 阻擋缺少威脅模型的實作請求
  Given docs/threat-model.md 不存在
  When 使用者輸入含 "$implementer"
  Then Hook 輸出包含 "Gate P: BLOCKED"

Scenario: T-010 Gate P 允許前置條件齊全的請求
  Given 存在 docs/threat-model.md
  When 使用者輸入含 "$implementer"
  Then Hook 輸出包含 "Gate P: OK"

Scenario: T-011 Gate D 阻擋缺少安全閘口記錄的部署請求
  Given docs/security-gate-report.md 不存在
  When 使用者輸入含 "$devops"
  Then Hook 輸出包含 "Gate D: BLOCKED"
```
