# pm Skill — BDD 驗收測試
> **Author**: $implementer (BDD phase)
> **Skill**: pm
> **SSDLC Phase**: Phase 1 / 2


## Feature: $pm 路由診斷

```gherkin
Scenario: 無進行中工作時，判斷開發模式
  Given 不存在 SSDLC_TRACKER.md
  When 使用者輸入 "$pm 我想做一個購物車"
  Then 輸出包含模式判斷（enterprise/agile/light/tactical 之一）
  And 輸出包含下一步指令（$req-analyst 或 $spec-architect 或 $implementer）
  And 不直接開始寫程式碼

Scenario: 有進行中工作時，提示繼續或重啟
  Given 存在 SSDLC_TRACKER.md 顯示 Phase 3 進行中
  When 使用者輸入 "$pm"
  Then 輸出包含目前 Phase 狀態
  And 提供 A) 繼續 / B) 新任務 的選項

Scenario: $enterprise 模式直接路由
  When 使用者輸入 "$pm $enterprise [規格路徑]"
  Then 直接路由至 $spec-architect
  And 不再詢問模式

Scenario: 不自行開始實作
  When 使用者輸入 "$pm 幫我寫一個 login API"
  Then 輸出路由判斷，不直接輸出任何程式碼
```

## Verification Checklist
- [ ] Happy Path 情境至少 1 個
- [ ] Edge Case 情境至少 1 個
- [ ] 資安負面測試情境至少 1 個（如適用）
- [ ] 每個 Scenario 有可觀測的 Then 條件
