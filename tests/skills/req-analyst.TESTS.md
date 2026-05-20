# req-analyst Skill — BDD 驗收測試
> **Author**: $implementer (BDD phase)
> **Skill**: req-analyst
> **SSDLC Phase**: Phase 1 / 2


## Feature: $req-analyst 需求分析

```gherkin
Scenario: 訪談未完成前不輸出規格
  Given 使用者輸入 "$req-analyst 我要做登入系統"
  When 使用者資訊不足
  Then 先輸出澄清問題，不直接產出 requirements.md

Scenario: 輸出 BDD 格式驗收標準
  Given 使用者已回答所有關鍵問題
  When $req-analyst 產出規格
  Then requirements.md 包含至少一個 Given/When/Then 情境
  And 情境包含 Happy Path
  And 情境包含至少一個 Edge Case

Scenario: 需求衝突必須標記
  Given 使用者描述有相互矛盾的需求
  When $req-analyst 處理衝突
  Then 輸出標記 [CONFLICT]
  And 不自行解決衝突
  And 等待人類決策

Scenario: 不假設技術實作
  Given 使用者說「我要一個快速的 API」
  When $req-analyst 記錄需求
  Then 需求文件不包含技術選型（如 Node.js、PostgreSQL）
  And 只記錄業務需求（如「回應時間 < 200ms」）
```

## Verification Checklist
- [ ] Happy Path 情境至少 1 個
- [ ] Edge Case 情境至少 1 個
- [ ] 資安負面測試情境至少 1 個（如適用）
- [ ] 每個 Scenario 有可觀測的 Then 條件
