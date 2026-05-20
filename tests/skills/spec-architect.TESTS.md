# spec-architect Skill — BDD 驗收測試
> **Author**: $implementer (BDD phase)
> **Skill**: spec-architect
> **SSDLC Phase**: Phase 1 / 2


## Feature: $spec-architect 規格架構

```gherkin
Scenario: 輸出 Mermaid 架構圖
  Given requirements.md 存在且有效
  When $spec-architect 執行
  Then 輸出包含 Mermaid 程式碼區塊
  And 架構圖包含系統邊界標示

Scenario: 識別信任邊界
  Given 系統有外部 API 依賴
  When $spec-architect 分析架構
  Then 輸出包含信任邊界分析
  And 標示哪些資料流跨越邊界

Scenario: Gate P 停止等待確認
  Given $spec-architect 完成架構文件
  When 輸出 Gate P 檢查清單
  Then 明確詢問使用者確認
  And 不在確認前繼續至下一個 Agent

Scenario: 架構變更記錄 Changelog
  Given 已有架構文件
  When 使用者要求修改架構
  Then 先更新架構文件
  And 在文件底部加入 Changelog 條目（含版本號與日期）
  Then 才更新任何程式碼
```

## Verification Checklist
- [ ] Happy Path 情境至少 1 個
- [ ] Edge Case 情境至少 1 個
- [ ] 資安負面測試情境至少 1 個（如適用）
- [ ] 每個 Scenario 有可觀測的 Then 條件
