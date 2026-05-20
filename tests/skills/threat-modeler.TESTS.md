# threat-modeler Skill — BDD 驗收測試
> **Author**: $implementer (BDD phase)  
> **SSDLC Phase**: 對應 Phase

## Feature: $threat-modeler

```gherkin
Scenario: STRIDE 六類別全部覆蓋
  Given 架構文件與信任邊界分析存在
  When $threat-modeler 執行
  Then 輸出包含 Spoofing 分析
  And 輸出包含 Tampering 分析
  And 輸出包含 Repudiation 分析
  And 輸出包含 Information Disclosure 分析
  And 輸出包含 Denial of Service 分析
  And 輸出包含 Elevation of Privilege 分析

Scenario: High 威脅必須有緩解措施
  Given STRIDE 分析完成
  When 存在嚴重性為 High 的威脅
  Then 每個 High 威脅必須有對應的緩解措施描述
  And 不能標示為「待討論」或「TBD」

Scenario: 威脅建模在實作前完成
  Given 使用者要求在還沒有架構文件時做威脅建模
  When $threat-modeler 執行
  Then 要求使用者先完成 $spec-architect
  And 不產出空的威脅登記表

Scenario: 安全需求注入 tasks.md
  Given 存在 High 級威脅 T-001
  When 威脅建模完成
  Then tasks.md 包含對應 T-001 的安全實作任務
```

## Verification Checklist
- [ ] Happy Path 情境至少 1 個
- [ ] Edge Case 或資安負面情境至少 1 個
- [ ] 每個 Scenario 的 Then 條件可觀測/可驗證
- [ ] 情境覆蓋 Verification checklist 中的關鍵項目
