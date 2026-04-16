# 🚀 SSDLC Autopilot: 多代理協作網路 (Multi-Agent Network) 實戰手冊

歡迎進入 v7.9.5 全新時代！我們已將原本的單點「AI 輔助」升級為**「9 段式異質多代理生產管線」**。本架構透過強制讓 Claude 生產規格、Gemini 審視威脅、GPT-4o 撰寫代碼並交由另一位 AI Review 的方式，徹底解決 AI 產生幻覺或「自己寫錯自己包庇」的問題，實踐 Zero-Trust Agentic Workflow。

---

## 🧭 操作核心原則

在使用這套系統時，請忘記過去「自己親手叫 AI 寫扣」的習慣。您現在是這座虛擬軟體工廠的**發包方**。

您唯一的起點與入口是：
👉 **`00-coordinator` (路由樞紐 / 專案經理)**

### 啟動方式 (兩者皆可)：
1. **VS Code / IDE 介面**：開啟您的 Copilot / Cline 介面，在選單點選或輸入 `@00-coordinator`。
2. **純文字指令巨集**：在任何 AI 聊天對話框輸入 `$coordinator [我今天要做的任務 / 規格文件路徑]`。

---

## 🛣️ 開發路線圖 (4 種自動規劃模式)

當 `00-coordinator` 盤點完您提供的需求後，會自動選擇一條對應的開發流，並透過 `Handoffs` 將工作依序交接給後面的專門 Agent。

| 開發路線 (Mode) | 適用情境 | 發生了什麼事？ |
| :--- | :--- | :--- |
| **🏢 `$enterprise` (企業模式)** | 需求明確，有事先定義的 OpenAPI 合約或規格文件。 | 強制遵守「合約金律 (Contract is King)」。不准 AI 自行發明未定義的端點。遇到規格缺口會暫停開發，強制作成 GOV-004 紀錄並等您點頭。 |
| **📝 `$agile` (敏捷模式)** | 只有初步構想草稿、口頭指令。 | 會先呼叫 `01-req-analyst` 把口語翻譯成專業需求，接著交給 `02-spec-architect` 自動產出架構圖與測試腳本。 |
| **🪶 `$light` (任務模式)** | 小型實作（非整個子系統）。 | 跳過繁雜的 10 階段追蹤表。釐清意圖 ➡️ TDD 紅燈 ➡️ 修改 ➡️ 綠燈，然後產出簡報。 |
| **🧰 `$tactical` (救火維護)** | 線上 Bug 修復、查錯、修改不守規矩的 Legacy Code。 | 完全拔除資安掃描框架負擔，採「偵查 ➡️ 特徵固定 ➡️ 精準打擊 ➡️ 撤退」的特種作戰流。 |

---

## 🤖 九段接力：Agent 職責大解密

在完整模式 ($enterprise / $agile) 下，您會看到以下的 Agent 發生「職權跑馬燈」與「互相攻擊」，這是預期且刻意的設計！

1. `00-coordinator`: 判斷意圖，按下啟動按鈕。
2. `01-req-analyst` & `02-spec-architect`: 將草稿繪製成 Mermaid 系統圖與 BDD 驗證步驟。
3. `03-threat-modeler` **(Gemini)**: 扮演黑帽駭客，針對剛剛寫出來的規格找出 3-5 個邏輯盲點 (STRIDE)。
4. `04-implementer` **(GPT-4o)**: 真正寫下主要實作程式碼的工程師。
5. `05-code-reviewer` **(Gemini)**: 鐵血 Reviewer。負責踢回 GPT-4o 寫錯或硬幹的 N+1 Query / SQL Injection。
6. `06-test-engineer`: 根據 Review 建議，掛載端到端 (E2E) 或自動化覆蓋測試。
7. `07-security-gate` **(Claude)**: 發布前的最終裁判。如果不符合資安規範，直接退件。
8. `08-devops`: 將通過考驗的專案包裝成 GitHub Actions 或 GitLab CI pipeline，並交還棒子。
9. 🏆 **結案歸檔 (最後再由 00-coordinator 接棒)**：根據專案歷史，**自動翻譯並產出給非技術主管看的「高階進度報告」(`Executive_Progress_Report_XXX.md`)**。

---

## 🛑 我該何時介入？ (物理檢查哨)

為了防止 Agent 跑偏、黑箱焦慮以及預算浪費，我們設計了無法被 Auto-Run 覆蓋的「雙重閘口 (Gates)」。無論 AI 跑得多順，都**一定**會停在這些節點等您。

- **`Gate P (計畫確認閘口)`**：在架構師寫完圖表與任務後、工程師開工之前。您需要在這裡說「Approve，可以寫扣了」。
- **`Gate D (部署前閘口)`**：寫完代碼並通過資安閘門，要送去建置 Pipeline 前。您必須對這段代碼擔保。

> 如果你想知道現在跑到哪了？我們有啟用「實體追蹤」，你可以隨時打開根目錄的 `SSDLC_TRACKER.md` 來看目前的勾選狀態！

---

## 💬 Omni-Skills 個別召喚 (中途微調)

雖說主推 Multi-Agent 連環船，但如果你只想拜託一位專家幫你處理單點業務，可以直接對對話框下達呼喚巨集：

*   `$deep-interview` ➡ 叫 AI 問你 5 個需求關鍵問題，幫助你釐清思緒。
*   `$ccg` ➡ 叫 AI 變成三個極端的架構師開會，為你決策技術選型。
*   `$ralph` ➡ 讓 AI 閉上嘴巴。不需要問候語，只管把測試從紅燈改成綠燈。
*   `$stack-advisor` ➡ 當規格未明，讓 AI 幫你選擇前端該用什麼框架 (React/Vue/Vite/Next)。
