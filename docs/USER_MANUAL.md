# 🚀 SSDLC Autopilot: 多代理協作網路 (Multi-Agent Network) 實戰手冊

歡迎進入 v9.1.0 全新時代！我們已將原本的單點「AI 輔助」與「肥胖的單一會話」升級為**「跨部門實體交接 (Handoff-Driven) 異質多代理生產管線」**。本架構透過強制讓 Claude 生產規格、Gemini 審視威脅、GPT-4o / Codex 撰寫代碼並交由另一位 AI Review 的方式，徹底解決 AI 產生幻覺或「自己寫錯自己包庇」的問題，實踐 Zero-Trust Agentic Workflow。

---

## 🧭 操作核心原則

在使用這套系統時，請忘記過去「自己親手叫 AI 寫扣」的習慣。您現在是這座虛擬軟體工廠的**發包方**。

您唯一的起點與入口是：
👉 **`00-pm` (路由樞紐 / 專案經理)**

### 啟動方式 (任選其一)：
1. **VS Code / IDE 介面 (Copilot / Cline)**：開啟您的 Copilot / Cline 介面，在選單點選或輸入 `@00-pm`。
2. **VS Code + Codex Extension**：在 Codex 面板的 Agent 模式中輸入 `$pm [任務描述]`。Codex 會自動讀取專案根目錄的 `AGENTS.md` 載入 SSDLC 指令。
3. **Codex CLI (終端機)**：在終端機執行 `codex` 後輸入 `$pm [任務描述]`。Codex CLI 支援 hierarchical `AGENTS.md` discovery（全域 → 專案根 → 子目錄）。
4. **純文字指令巨集**：在任何其他 AI 聊天對話框（Cursor / Gemini / Claude）輸入 `$pm [我今天要做的任務 / 規格文件路徑]`。

### 🔄 跨部門交接 (Token 最佳化 / 防幻覺機制)
當開發進入各階段檢查哨 (Gate)，或是中途除錯卡關需要暫停時，`$pm` 會主動產出**雙軌交接單**：
- 📄 `latest_memo.md`（散文版，給人類閱讀）
- 🔧 `latest_state.json`（JSON 結構化版，給 Agent 解析，AI 不會隨意改寫）

為了避免聊天紀錄過長導致 AI 產生幻覺與 Token 費用爆炸，請**勇敢關閉視窗**。在全新的對話框中輸入：
👉 **`$pm continue`** （新的 AI 將先讀 JSON 狀態確認進度，再讀散文補充上下文，完全不需看歷史對話即可無縫接手！）

---

## 🛣️ 開發路線圖 (4 種自動規劃模式)

當 `00-pm` 盤點完您提供的需求後，會自動選擇一條對應的開發流，並透過 `Handoffs` 將工作依序交接給後面的專門 Agent。

| 開發路線 (Mode) | 適用情境 | 發生了什麼事？ |
| :--- | :--- | :--- |
| **🏢 `$enterprise` (企業模式)** | 需求明確，有事先定義的 OpenAPI 合約或規格文件。 | 強制遵守「合約金律 (Contract is King)」。不准 AI 自行發明未定義的端點。遇到規格缺口會暫停開發，強制作成 GOV-004 紀錄並等您點頭。 |
| **📝 `$agile` (敏捷模式)** | 只有初步構想草稿、口頭指令。 | 會先呼叫 `01-req-analyst` 把口語翻譯成專業需求，接著交給 `02-spec-architect` 自動產出架構圖與測試腳本。 |
| **🪶 `$light` (任務模式)** | 小型實作（非整個子系統）。 | 跳過繁雜的 10 階段追蹤表。釐清意圖 ➡️ TDD 紅燈 ➡️ 修改 ➡️ 綠燈，然後產出簡報。 |
| **🧰 `$tactical` (救火維護)** | 線上 Bug 修復、查錯、修改不守規矩的 Legacy Code。 | 完全拔除資安掃描框架負擔，採「偵查 ➡️ 特徵固定 ➡️ 精準打擊 ➡️ 撤退」的特種作戰流。 |

---

## 🤖 九段接力：Agent 職責大解密

在完整模式 ($enterprise / $agile) 下，您會看到以下的 Agent 發生「職權跑馬燈」與「互相攻擊」，這是預期且刻意的設計！

1. `00-pm`: 判斷意圖，按下啟動按鈕。
2. `01-req-analyst` & `02-spec-architect`: 將草稿繪製成 Mermaid 系統圖與 BDD 驗證步驟。
3. `03-threat-modeler` **(Gemini)**: 扮演黑帽駭客，針對剛剛寫出來的規格找出 3-5 個邏輯盲點 (STRIDE)。
4. `04-implementer` **(GPT-4o)**: 真正寫下主要實作程式碼的工程師。
5. `05-code-reviewer` **(Gemini)**: 鐵血 Reviewer。負責踢回 GPT-4o 寫錯或硬幹的 N+1 Query / SQL Injection。
6. `06-test-engineer`: 根據 Review 建議，掛載端到端 (E2E) 或自動化覆蓋測試。
7. `07-security-gate` **(Claude)**: 發布前的最終裁判。如果不符合資安規範，直接退件。
8. `08-devops`: 將通過考驗的專案包裝成 GitHub Actions 或 GitLab CI pipeline，並交還棒子。
9. 🏆 **結案歸檔 (最後再由 00-pm 接棒)**：根據專案歷史，**自動翻譯並產出給非技術主管看的「高階進度報告」(`Executive_Progress_Report_XXX.md`)**。

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

---

## 🔌 支援平台一覽

安裝後，以下所有 AI 開發工具皆可直接使用本系統，**無需額外設定**：

| 平台 | 入口檔 | 備註 |
|------|--------|------|
| GitHub Copilot / Cline | `.github/copilot-instructions.md` | 核心 SSOT (Single Source of Truth) |
| Cursor | `.cursorrules` | 薄代理，自動載入 SSOT |
| Gemini CLI / Vertex AI | `.geminirules` | 薄代理，自動載入 SSOT |
| Claude Code / Anthropic | `CLAUDE.md` | 薄代理，自動載入 SSOT |
| **OpenAI Codex (VSCode + CLI)** | **`AGENTS.md`** | **v9.1.0 新增**，薄代理，自動載入 SSOT |
