# 驗收標準規格 (Acceptance Spec)

此文件定義了該模組「如何被證明為成功（或正確失敗）」。工程團隊與自動化測試腳本應以此文件為依據。

## 寫作慣例 (Formatting Convention)
強烈建議遵循 **BDD (Behavior-Driven Development) 的 Given-When-Then** 句型撰寫。這有助於消除自然語言的歧義，並能與機器可讀的測試報告 (Traceability) 直接掛鉤。

例如：
- **Given (前提)**: `給定 [什麼角色] 處於 [什麼系統狀態]`
- **When (觸發)**: `當他執行 [什麼樣的操作/傳入什麼 Payload]`
- **Then (斷言)**: `那麼系統應該 [回傳什麼結果/資料庫變成什麼狀態]`

---

## 1. 快樂路徑 (Happy Paths)
定義一切正常時，系統的預期行為。
- **AC-Happy-1**: `[例: Given 登入的管理員, When 送出合法的建立表單, Then 系統存入資料庫並回傳 201 Created]`

## 2. 邊界與異常路徑 (Negative & Sad Paths) [防禦性開發必備]
（※注意：高品質的規格中，異常路徑的數量通常等於或大於快樂路徑，這也是防堵越權與系統崩潰的防線。）
- **AC-Sad-1 (權限異常)**: `[例: Given 一般使用者, When 嘗試呼叫 Admin 刪除 API, Then 系統應立即回傳 403 Forbidden 且不執行邏輯]`
- **AC-Sad-2 (狀態越界)**: `[例: Given 一張已標記為 Paid 的 Invoice, When 再次呼叫 Payment API, Then 系統應回傳 409 Conflict 且狀態不變]`
- **AC-Sad-3 (資料空缺)**: `[例: Given 搜索條件為空, When 點擊查詢, Then 不應報錯，應回傳包含 0 筆資料的空陣列 []]`

## 3. 非功能性驗收 (NFR Acceptance)
- **效能**: `[例: 查詢 API P99 延遲必須 < 300ms]`
- **安全**: `[例: 密碼不可顯示於任何回傳的 JSON Payload]`
