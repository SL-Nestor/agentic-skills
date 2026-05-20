# Ghost Skills — BDD 行為驗收測試
> **Red Phase（TDD）**: 定義期望行為，實作前先確立合約

## Feature: $deep-interview

```gherkin
Scenario: 輸出恰好 5 個問題
  Given 使用者輸入 "$deep-interview 我要做一個登入系統"
  When $deep-interview 執行
  Then 輸出問題數量為 5（不多不少）
  And 每個問題有明確編號（1. 2. 3. 4. 5.）
  And 在輸出問題後明確等待使用者回答

Scenario: 問題涵蓋五個維度
  Given 任何需求描述作為輸入
  When $deep-interview 執行
  Then 問題涵蓋「目標用戶」維度
  And 問題涵蓋「核心業務價值」維度
  And 問題涵蓋「限制條件（技術/法規/時程）」維度
  And 問題涵蓋「量化成功指標」維度
  And 問題涵蓋「絕對禁止事項（Anti-goals）」維度

Scenario: 問題前不寫程式碼
  Given 使用者輸入 "$deep-interview 建一個 REST API"
  When $deep-interview 執行
  Then 輸出不包含任何程式碼區塊
  And 輸出不包含技術選型建議
  And 輸出不包含架構圖
```

## Feature: $ccg

```gherkin
Scenario: 三位架構師聲音明確區分
  Given 使用者提出技術決策問題
  When $ccg 執行
  Then 輸出包含標示 [Crazy] 或 🤪 的區塊
  And 輸出包含標示 [Clever] 或 🧠 的區塊
  And 輸出包含標示 [Grounded] 或 🪨 的區塊
  And 三個區塊有明顯不同的技術立場

Scenario: Crazy 架構師提出革命性方案
  Given 任何技術問題
  When Crazy 架構師發言
  Then 提出最激進或最創新的方案
  And 不考慮實際限制（預算、團隊規模等）

Scenario: Grounded 架構師聚焦穩定性
  Given 任何技術問題
  When Grounded 架構師發言
  Then 推薦最保守、最成熟的方案
  And 強調維護性、團隊熟悉度、降低風險

Scenario: 輸出共識或分歧摘要
  Given 三位架構師完成各自陳述
  When $ccg 執行完畢
  Then 輸出「共識點」或「建議決策」區塊
  And 若有明顯分歧，明確標示分歧點
  And 詢問使用者偏好哪個方向
```

## Feature: $ralph

```gherkin
Scenario: 不輸出中間推理過程
  Given 存在失敗的測試檔案
  When 使用者輸入 "$ralph tests/foo.test.ts"
  Then 輸出不包含「讓我分析…」或「首先我需要…」等推理文字
  And 輸出不包含任何 markdown 程式碼區塊（修改過程）
  And 最終只輸出結果摘要

Scenario: 結果格式標準化
  Given 2 個失敗測試，成功修復 1 個，1 個無法修復
  When $ralph 執行完畢
  Then 輸出格式符合 "✅ 1/2 tests fixed"
  And 輸出說明無法修復的 1 個測試的具體原因（一行）

Scenario: 全部通過時的輸出
  Given 所有測試原本就通過
  When 使用者輸入 "$ralph tests/"
  Then 輸出 "✅ All tests already passing"
  And 不做任何程式碼修改

Scenario: 檔案不存在時
  Given 測試檔案路徑不存在
  When 使用者輸入 "$ralph tests/nonexistent.test.ts"
  Then 輸出 "❌ Test file not found: tests/nonexistent.test.ts"
  And 不嘗試修改任何檔案
```

## Feature: $stack-advisor

```gherkin
Scenario: 推薦包含理由
  Given 使用者描述需求（高並發、小團隊、需快速交付）
  When $stack-advisor 執行
  Then 輸出推薦的技術棧（語言、框架、資料庫等）
  And 每個推薦項目附有具體理由（符合哪個需求）

Scenario: 列出被排除的替代方案
  Given 任何技術選型問題
  When $stack-advisor 執行
  Then 輸出至少 2 個被排除的替代方案
  And 每個被排除方案說明排除原因

Scenario: Trade-off 表格
  Given 使用者的需求與限制
  When $stack-advisor 執行
  Then 輸出一個 Trade-off 比較表
  And 表格欄位包含：方案、優點、缺點、適合情境

Scenario: 不假設使用者的限制
  Given 使用者只說「我要做一個 web app」
  When $stack-advisor 執行
  Then 在給出建議前先詢問關鍵限制（團隊規模、效能需求、預算）
  And 不直接給出單一推薦
```
