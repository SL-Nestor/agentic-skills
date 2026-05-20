# code-reviewer Skill — BDD 驗收測試
> **Author**: $implementer (BDD phase)  
> **SSDLC Phase**: 對應 Phase

## Feature: $code-reviewer

```gherkin
Scenario: 不審查自己寫的程式碼
  Given 本次會話的 $implementer 寫了 UserController.cs
  When $code-reviewer 執行審查
  Then 警告使用者：此次審查缺乏獨立性
  And 建議在新對話視窗執行

Scenario: 審查報告包含五個維度
  Given 存在待審查的程式碼
  When $code-reviewer 產出報告
  Then 報告包含資安評估（SQLi、XSS、IDOR 等）
  And 報告包含架構評估（層次分離、DI）
  And 報告包含效能評估（N+1、記憶體）
  And 報告包含測試評估（覆蓋率缺口）
  And 報告包含可讀性評估

Scenario: High 問題阻擋合併
  Given 發現 🔴 High SQL Injection 問題
  When 審查完成
  Then 報告標示「必須修改否則退回」
  And 詢問是否自動重構
```

## Verification Checklist
- [ ] Happy Path 情境至少 1 個
- [ ] Edge Case 或資安負面情境至少 1 個
- [ ] 每個 Scenario 的 Then 條件可觀測/可驗證
- [ ] 情境覆蓋 Verification checklist 中的關鍵項目
