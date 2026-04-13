# 🛡️ SSDLC Autopilot 規格交付與開發對接指南 (Specification Handover Guide)

為了讓開發團隊（包含 AI 代理人網路與工程師）能夠以最高效率、零誤差地執行 SSDLC v6.6 框架，規格端 (Product / Spec Team) 提供的信息質量至關重要。

本指南詳細列出了如果要無縫套用 SSDLC 模型，規格端應該提供哪些文件、內容細節，以及哪些是**必備 (Mandatory)** 或 **選填 (Optional)**。

---

## 1. 核心規格書 (PRD / The Core Spec) —— 【絕對必備】

這是啟動 AI 代理人引擎的「燃料」。沒有這份文件，開發流程將拒絕啟動（防禦性暫停）。

### 必備內容 (Mandatory Content)
為了讓 AI 能夠產出符合「源頭窮舉矩陣 (Rule 2)」與「狀態枚舉公式 (Rule 4)」的原子化開發規格，PRD 必須包含以下要素：

1. **技術棧與開發模式宣告 (Tech Stack & Mode)**
   - **內容**：明確定義是 Backend, Frontend 還是 Fullstack。若含前端，需指定框架（例如：`Next.js 14`, `Vite + React`, `TailwindCSS` 等）。
   - **為什麼重要**：若未填寫，系統會觸發防禦性停止，強行中斷開發流程直到管理層回覆。
2. **具名物件與角色 (Named Actors & Entities)**
   - **內容**：系統中有哪些具體身分？（例如：`SystemAdmin`, `Payer`, `Guest`）。操作的領域物件是什麼？（例如：`Invoice`, `UserProfile`）。
   - **為什麼重要**：AI 會提取這些做為「源頭意圖庫 (Source Intent)」，確保不會憑空捏造不存在的權限。
3. **具名外部依賴 (Named Dependencies)**
   - **內容**：如果有對接外部系統，必須明確寫出名稱（例如：`Stripe Payment API`, `Azure AD`, `SendGrid`）。不接受「串接金流」這類模糊字眼。
4. **狀態機與枚舉值 (State Machines & Enums)**
   - **內容**：清楚列出領域物件的所有可能狀態（例如：訂單狀態包含 `Pending, Paid, Failed, Refunded`）。
   - **為什麼重要**：AI 將依據此資訊啟動 N+1 測試規格生成，如果狀態未給齊，將導致嚴重的負面場景漏洞。
5. **不變量與約束 (Invariants & Constraints)**
   - **內容**：絕對不能發生的事，或必須遵守的死規則（例如：「密碼必須大於12字元」、「發票開立後金額絕對不可修改」）。

### 選填但強烈建議內容 (Highly Recommended)
1. **UI 線框圖 / UX 流程敘述 (UI/UX Flows)** *【前端開發必備】*
   - **內容**：不一定要是精美的 Figma，但必須有文字化或結構化的版面敘述（例如：「左側是選單，主畫面有一個 DataGrid 顯示用戶列表，點擊單列展開詳情」）。
   - **為什麼重要**：SSDLC 採用「UI 驅動開發」，需要這些資訊來建立合約與 Mock Data。
2. **非功能性需求與合規性 (NFRs & Compliance)**
   - **內容**：明確的效能指標（例如：「API 回應時間 < 200ms」）或資安合規（「PII 資料必須落地加密」）。

---

## 2. 驗收標準 (Acceptance Criteria / AC) —— 【強烈建議】

雖然 AI 在 Phase 0 會有能力自行將 PRD 轉化為驗收標準，但由規格端直接提供，能最大程度收斂「解釋漂移 (Interpretive Drift)」。

### 標準化格式要求
最好的 AC 應該具備「可測試性 (Testable)」。建議規格端採用 **Given-When-Then** (BDD) 格式撰寫，涵蓋：

1. **快樂路徑 (Happy Path) [必備]**
   - *Example:* Given 一個具備 Admin 權限的活躍帳號，When 點擊匯出報表，Then 系統應在 3 秒內提供 CSV 下載連結。
2. **異常路徑 (Sad/Negative Path) [必備]**
   - *Example:* Given 一個已鎖定的帳號，When 嘗試登入，Then 系統應阻擋並顯示「帳號停權」，且不應產生 JWT Token。
3. **邊界條件 (Edge Cases) [選填]**
   - 對於空集合、第一筆資料、極大值等的處理期待。

---

## 3. 架構與技術設計計畫 (DevPlan / Tech Design) —— 【選填 (大型架構優化時必備)】

如果是全新的中小型功能，AI 可以在 Phase 3 (Plan) 自行推演出這個文件。但如果是架構重構或跨系統整合，則需要由規格端或架構師提供。

### 內容建議
1. **資料庫 Schema 綱要設計**
   - 如果規格端已經確定了資料表設計或欄位要求，請直接提供 YAML 或 Markdown 表格。
2. **API 合約 (API Contract / OpenAPI Spec)**
   - 如果是前後端分離開發，且由不同團隊進行，提前提供 Swagger JSON 或 API 介面定義，可以讓 AI 直接進入 Mock 與開發階段。

---

## 🤷‍♂️ 規格端的 3 大常見地雷 (Anti-Patterns)

為了避免在開發過程中 AI 產生「能力缺失 (Missing Capability)」或交付錯誤，請規格端避開以下寫法：

| 地雷寫法 (模糊 / 依賴直覺) | 本系統要求的高品質寫法 (精確 / 可機讀) | 可能造成的系統偏誤 |
| :--- | :--- | :--- |
| **「功能要很快」** | 「主要名單 API Latency 必須 < 300ms，需支援分頁，每頁 50 筆。」 | AI 因為缺乏明確的成功指標，會在效能審查 (Gate E) 隨意放行。 |
| **「使用者可以管理訂單」** | 「`StoreManager` 可以 `CRUD` 自己店鋪的訂單；`SystemAdmin` 可以 `Read` 所有訂單但不能修改。」 | 未定義具名角色與權限邊界，導致嚴重的越權漏洞 (Broken Access Control)。 |
| **「有錯誤時提示使用者」** | 「密碼錯誤時回傳 `401 Unauthorized`；帳號鎖定時回傳 `403 Forbidden` 並附加 RetryAfter Header。」 | 只寫了 UI 表面現象，未定義 Backend 的錯誤碼配對，導致自動化測試無法精確斷言。 |

---
## 總結工作流整合

規格端交付文件後，您可以使用以下指令一鍵啟動自動化開發引擎：

```bash
/start-ssdlc docs/specs/PRD.md docs/specs/Acceptance.md --mode=fullstack
```

AI 會先執行 **Gate P 審核**，若它發現「狀態沒給齊」或「缺乏負面路徑 AC」，它會主動列出 **「源頭窮舉矩陣缺口」** 並退回要求澄清。透過這種文件互動，規格與開發的認知將達到 100% 同步。
