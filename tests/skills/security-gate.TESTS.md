# security-gate Skill — BDD 驗收測試
> **Author**: $implementer (BDD phase)  
> **SSDLC Phase**: 對應 Phase

## Feature: $security-gate

```gherkin
Scenario: PASS/FAIL 二元判決
  Given Security Gate 完成所有檢查
  When $security-gate 輸出判決
  Then 輸出為「PASS」或「FAIL」其中之一
  And 不輸出「有條件通過」或「大致通過」

Scenario: FAIL 必須列出具體原因
  Given 存在未解決的 High 威脅
  When $security-gate 輸出 FAIL
  Then 每個 FAIL 項目有具體描述
  And 不能只說「發現問題」

Scenario: 不依賴 Code Review 報告的結論
  Given Code Review 說「已修復所有問題」
  When $security-gate 執行
  Then 獨立驗證而非接受前一個 Agent 的聲明
  And 直接檢查威脅緩解的實際狀態

Scenario: Override FAIL 需要記錄
  Given $security-gate 輸出 FAIL
  And 使用者明確接受已知風險
  When 人類 override 判決
  Then 決策依據記錄在 AGENT_HANDOFF.md 的 Conflict Log
```

## Verification Checklist
- [ ] Happy Path 情境至少 1 個
- [ ] Edge Case 或資安負面情境至少 1 個
- [ ] 每個 Scenario 的 Then 條件可觀測/可驗證
- [ ] 情境覆蓋 Verification checklist 中的關鍵項目
