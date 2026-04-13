# 產品需求規格書 (Formal PRD)

此文件為業務行為與情境的主軸（注意：系統資料結構真相仍以 OpenAPI 契約為 SSOT）。

## 1. 功能目標與商業價值 (Purpose)
- **What**: 這次要開發什麼樣子功能？
- **Why**: 達成什麼商業價值或解決什麼痛點？

## 2. 關係人與領域物件 (Actory & Entity) [SSDLC 首要對接點]
系統運作的核心角色與資料載體，必須在此**具名化**，以防 AI 開發時捏造權限。
- **具名使用者 (Actors)**: 
  - `[例如: SystemAdmin - 最高權限者]`
  - `[例如: SubscribedUser - 已付費的一般帳號]`
- **核心領域物件 (Entities)**:
  - `[例如: Invoice - 代表一張電子發票的生命週期]`

## 3. 狀態枚舉與流轉 (State Enums & Transitions) [SSDLC 首要對接點]
必須窮舉物件的所有可能狀態，SSDLC 驗證引擎將依此執行 `N+1` 測試公式覆蓋。
- **目標物件**: `[例如: PaymentRecord]`
- **可能狀態 (Enums)**: `[Pending, Paid, Failed, Refunded]`
- **流轉限制**: `[Paid 只能轉 Refunded，Failed 不可重試]`

## 4. 不變量與系統約束 (Invariants & Constraints) [SSDLC 首要對接點]
無論發生什麼事，系統都不能違背的鐵律（資安、法規、商業邏輯）。
- `[約束 1: 密碼必須加密落地，不可進入 Log 即便是 Debug 模式]`
- `[約束 2: 發票金額在開立後，Update 介面絕對不可修改金額欄位]`
- `[約束 3: 依賴外部服務: 只能使用 SendGrid 發送 Mail]`

## 5. UI 線框與行為敘述 (UI / UX Flow)
- *請提供線框圖截圖連結，或結構化的列點描述（版面佈局、彈跳窗時機、表單必填項等）。*

*(此範本已對齊 SSDLC Autopilot 驗證需求，補充了 Enum/Actor/Constraints 段落，但設計上完全獨立不綁定任何 AI 工具名稱。)*
