# test-engineer Skill — BDD 驗收測試
> **Author**: $implementer (BDD phase)  
> **SSDLC Phase**: 對應 Phase

## Feature: $test-engineer

```gherkin
Scenario: 資安負面測試覆蓋所有 STRIDE 威脅
  Given threat-model.md 有 5 個威脅
  When $test-engineer 設計測試
  Then 每個威脅都有對應的負面測試情境

Scenario: 使用可靠的元素選取器
  Given 存在 UI 元件需要測試
  When $test-engineer 寫 Playwright 測試
  Then 選取器使用 data-testid 或 aria-role
  And 不使用 CSS class 或 XPath

Scenario: 不使用 hardcoded sleep
  Given 非同步操作需要等待
  When $test-engineer 處理等待邏輯
  Then 使用 waitFor 或 page.waitForResponse
  And 不使用 sleep(3000) 等固定延遲

Scenario: live smoke test 優先（若有 Playwright MCP）
  Given 環境有 Playwright MCP 工具
  When $test-engineer 開始工作
  Then 先執行 live smoke test 確認 UI 狀態
  And 再產出測試腳本
```

## Verification Checklist
- [ ] Happy Path 情境至少 1 個
- [ ] Edge Case 或資安負面情境至少 1 個
- [ ] 每個 Scenario 的 Then 條件可觀測/可驗證
- [ ] 情境覆蓋 Verification checklist 中的關鍵項目
