# implementer Skill — BDD 驗收測試
> **Author**: $implementer (BDD phase)  
> **SSDLC Phase**: 對應 Phase

## Feature: $implementer

```gherkin
Scenario: TDD 紅燈先行
  Given 使用者要求實作新功能
  When $implementer 執行
  Then 先輸出測試描述（期望行為）
  And 再實作通過測試的最小程式碼
  And 最後重構消除重複

Scenario: 不 hardcode secret
  Given 實作需要 API key 或資料庫密碼
  When $implementer 寫程式碼
  Then 程式碼不包含任何明文 secret
  And 使用環境變數或設定檔注入

Scenario: 安全需求轉化為測試
  Given threat-model.md 有 T-001 SQL Injection 威脅
  When $implementer 實作資料庫查詢
  Then 實作使用參數化查詢（非字串拼接）
  And 有對應的 SQL Injection 負面測試

Scenario: $ralph 模式靜默執行
  Given 使用者輸入 "$ralph tests/auth.test.ts"
  When 測試有 3 個失敗
  Then 修復過程不輸出推理文字
  And 最終輸出 "✅ X/3 tests fixed"
```

## Verification Checklist
- [ ] Happy Path 情境至少 1 個
- [ ] Edge Case 或資安負面情境至少 1 個
- [ ] 每個 Scenario 的 Then 條件可觀測/可驗證
- [ ] 情境覆蓋 Verification checklist 中的關鍵項目
