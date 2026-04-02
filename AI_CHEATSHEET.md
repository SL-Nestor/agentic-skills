# 🚀 SSDLC Autopilot - 全功能操作手冊 (Prompt Cheat Sheet)

這套大腦檔案 (`.github/copilot-instructions.md`) 賦予了 AI 不同的運作模式。根據你交辦任務的「大小」與「階段」，你可以選擇使用 **Slash Command (全流程自動駕駛)** 或 **Shorthand Macros (中途介入的專家技能)**。

---

## 🌟 第一梯隊：Slash Command (全流程自動駕駛)
**適用時機**：當你要開發一個**全新的大功能**（例如：整個購物車模組、完整的登入系統），你寫好了一篇草稿，希望 AI 從零開始幫你「規劃 -> 寫扣 -> 測試 -> 審計 -> 寫報告」。

### 1️⃣ `/start-ssdlc` (啟動標準 10 階段開發)
AI 會嚴格執行 Phase 0 ~ 10，建立追蹤表 (`SSDLC_TRACKER.md`)，並在每個階段（Gate P, A, B, C, D, E, F）停下來等你簽核。

**📌 標準指令語法：**
```text
/start-ssdlc <SpecFile> <DevPlanFile> <DevTasksFile> <AcceptanceCriteria> [--mode=backend|frontend|fullstack]
```

#### 參數完全解析：
| 參數名稱 | 說明與作用 | 檔案是否需存在？ | 建議路徑範例 |
| :--- | :--- | :--- | :--- |
| `<SpecFile>` | **規格草稿檔**。<br>你（人類）自己寫的需求草稿，這是整個 AI 引擎的燃料。請把功能、商業邏輯、限制條件用白話文寫進去。 | **必須存在** | `docs/specs/feature-name.md` |
| `<DevPlanFile>` | **開發計畫檔**。<br>AI 用來存放「技術選型、架構圖、開發策略」的檔案。 | **不需要** (AI 會自動生成) | `docs/plan.md` |
| `<DevTasksFile>` | **任務拆解檔**。<br>AI 把大功能拆解成超級細小的「實作 Checklist」。 | **不需要** (AI 會自動生成) | `docs/tasks.md` |
| `<AcceptanceCriteria>`| **驗收標準與測試計畫**。<br>AI 將規格轉譯成 BDD 格式的檔案 (Given/When/Then)。負責綁定防漂移機制。 | **不需要** (AI 會自動生成) | `docs/acceptance.md` |
| `[--mode]` | **開發戰鬥模式** (選用，預設為 `backend`)。<br>• **`backend`**: 專注 API 與後端，產出前台串接文件。<br>• **`frontend`**: 專注 UI 元件，要求畫面錄影與截圖。<br>• **`fullstack`**: 火力全開，嚴格要求人類執行 Gate F (UAT) 打勾驗收才能發 PR。 | **選用** | `--mode=fullstack` |

**操作範例：(純後端預設)**
> `/start-ssdlc docs/specs/cart-feature.md docs/dev-plan.md docs/dev-tasks.md docs/acceptance-criteria.md`

---

## 🛸 第二梯隊：Omni-Skills (短指令巨集)
**適用時機**：當你在開發途中，臨時遇到一個具體問題（如解 Bug、釐清需求、重構、查資安），不需要跑完 10 個階段，只要呼叫「相對應的專家模式」即可。

### 2️⃣ `$deep-interview` (需求釐清過濾器)
最適合在「老闆剛丟一個模糊需求」時使用。AI 會**拒絕寫程式**，改用深度的「反問法 (Socratic questioning)」幫你把邊界、例外、非目標 (non-goals) 挖出來。
> **操作範例：** `$deep-interview 我們系統要加一個後台匯出報表的功能，你可以幫我列出最重要的三個防呆或設計盲點嗎？`

### 3️⃣ `$ccg` (跨領域架構決策委員會)
最適合在「技術選型」時使用。強制 AI 扮演三個極端角色互相碰撞（效能狂 vs 成本仔 vs 資安官），最後再給出綜合建議，避免 AI 給出敷衍的萬靈丹。
> **操作範例：** `$ccg 我們在猶豫要把暫存資料放在 SQL 資料庫還是另外架設 Redis，請幫我評估最適合我們目前專案的方案。`

### 4️⃣ `$team` (微型團隊管線)
最適合「修 Bug」或「加個小功能」時使用。你一行指令，AI 必須強迫自己用 4 個段落回覆（架構師先想 -> 工程師去寫 -> SDET 給測試 -> 資安做稽核）。
> **操作範例：** `$team 幫我修改 src/Utils/SecurityHelper.cs，加上密碼複雜度驗證邏輯（必須包含大小寫和特殊符號）。`

### 5️⃣ `$architect` (純繪圖架構師)
最適合剛接手專案或是準備寫文件時使用。AI 只會讀取檔案（絕對不改 Code），並畫出 Mermaid 流程圖或架構元件樹。
> **操作範例：** `$architect 請幫我閱讀目前 src/Services/Payment/ 目錄下的所有檔案，並畫出一張完整的付款狀態機與元件依賴的 Mermaid 圖。`

### 6️⃣ `$plan` (純企劃模式)
最適合「不想讓 AI 亂動程式碼，只想先看它打算怎麼下手」時使用。它只會列出步驟與策略。
> **操作範例：** `$plan 我想要升級專案裡的 Entity Framework Core 版本，請給我最安全的移轉步驟計畫。`

### 7️⃣ `$ralph` (無情重構機器人 / TDD 執行者)
最適合「Specs 都寫好了、測試也寫好了，你只想趕快把實作幹出來」時使用。AI 會關閉所有廢話、問候語，無視瑣碎的提問，純粹以極高效率產出程式碼讓你貼。
> **操作範例：** `$ralph 測試案例都在 tests/Services/OrderTest.cs 裡，都是紅燈。請幫我實作 src/Services/OrderService.cs 讓它們全變綠燈！`

### 8️⃣ `$reviewer` (資安與程式碼審查員)
最適合在發 PR 前，或是寫完一段複雜邏輯後呼叫。它會跳過開發流程，直接啟動 Phase 4 的嚴格代碼審查模式。
> **操作範例：** `$reviewer 請幫我檢查這份剛寫好的 CheckoutController.cs，特別留意防止 SQL Injection 和權限越權 (IDOR) 的問題。`

### 9️⃣ `$qa-tester` (E2E 測試與防呆專家)
汲取自 Anthropic 官方的測試最佳實踐。最適合用來補測試案例，或是幫你思考如何做 Playwright/Cypress 端到端測試。
> **操作範例：** `$qa-tester 幫我寫一個登入頁面的 E2E 測試腳本，請特別考量邊界條件操作、鍵盤無障礙操作、以及避免寫出易碎的 DOM 綁定。`

### 🔟 `$ui-designer` (前端與設計規範糾察隊)
汲取自 Anthropic 官方的設計規範思維。最適合處理前端元件，確保產出的 UI 符合無障礙標準、RWD、以及企業的色系與 Tone調。
> **操作範例：** `$ui-designer 請幫我把這段純 HTML 按鈕改成使用 Tailwind 樣式，必須包含 Hover 特效，且符合我們內部「深色模式」的設計規範要求。`

### 1️⃣1️⃣ `$mcp-dev` (MCP 外部大腦工程師)
最適合用來規劃與實作「外部 Context/API 與 AI 的橋樑」(Model Context Protocol)。
> **操作範例：** `$mcp-dev 我想寫一個能讓 AI 讀取我們公司 Jira 任務的 MCP Server，請幫我定義標準的 Tool Schema 並完成 Node.js 實作。`

### 1️⃣2️⃣ `$ai-integration` (AI API 與 LLM 串接專家)
汲取自 Google Gemini API 的最佳實踐。最適合在處理 AI 串接任務時呼叫，強迫 AI 實作重試機制 (Exponential Backoff)、防止幻覺，並嚴謹定義結構化輸出。
> **操作範例：** `$ai-integration 幫我寫一段呼叫 Gemini API 解析 PDF 的程式碼。請提供嚴謹的 response_format，而且必須加上處理 429 Rate Limit 的防禦性重試機制。`

### 1️⃣3️⃣ `$devops-eng` (SRE 與雲端架構師)
最適合在維護基礎設施即代碼 (IaC)，例如撰寫 Dockerfile、GitHub Actions 或 Azure Bicep 時呼叫。它會強迫套用最小權限原則與資安最佳規範。
> **操作範例：** `$devops-eng 幫我為這個 .NET 專案寫一個 Dockerfile，請確保不使用 root 權限執行，並且採用 Multi-stage build 盡量壓縮 Image 大小。`

### 1️⃣4️⃣ `$tech-writer` (技術文件寫手)
專門將艱澀的程式碼轉換為容易理解的文件。適合用來撰寫 README、Swagger 註解，或是每次迭代結束後的 Release Note。
> **操作範例：** `$tech-writer 我剛寫好了最新的 CheckoutController，請幫我依據程式碼與 Swagger，寫出一篇面向使用者的 API 串接指南與 Release Note。`

### 1️⃣5️⃣ `$db-architect` (資料庫與 EF Core 專家)
最適合在撰寫複雜 LINQ、設計 Schema 或建立 Migration 時呼叫。他會優先抓出 N+1 查詢問題，並確保 Migration 安全。
> **操作範例：** `$db-architect 幫我審查這段 EF Core 查詢，請指出有沒有潛在的 N+1 效能瓶頸，如果有，請幫我把它改成具備適當 Include/Select 的寫法，並建議合適的 Index。`

### 1️⃣6️⃣ `$copilotkit-dev` (Generative UI 與前端 AI 串接專家)
專門處理如何在自家前端介面（React/Next.js/Vite）優雅地整合 AI 聊天窗。它會強制使用 `CopilotKit` 生態系，並且實作狀態同步 (Shared State) 與動態出圖 (Generative UI)。
> **操作範例：** `$copilotkit-dev 我想在購物車介面加上 AI 助理，請幫我寫一份使用 CopilotKit 將 Zustand 訂單狀態與 Agent 同步的 React Component。`

### 1️⃣7️⃣ `$meta-skill` (技能創造者)
一個用來「教 AI 怎麼寫新的 AI 技能」的超強指令。AI 會依據你的需求，吐出完美的 `SKILL.md` 格式，讓你可以存放在大腦庫中永久擴充自己。
> **操作範例：** `$meta-skill 我想要未來有一個指令叫 $react-guru，專門處理 React 效能優化與 Hooks 使用。請幫我輸出他該有的 Markdown Skill 說明檔。`

---

## 🌍 附錄：跨平台 AI 工具支援 (Cross-Platform CLI)
為了避免在各地複製貼上這份龐大的 SSDLC 提示詞，我們採用了 **統一入口 (Single Source of Truth) 與 跳板檔案 (Trampoline Files)** 的架構：
所有大腦神經中樞與防呆規則皆維護在 `.github/copilot-instructions.md` 與 `.agents/skills/` 之中。

當你在各種不同的 IDE 或是 Terminal CLI 載入這個 Payload 時，它們會透過以下專屬的環境設定檔自動引導(跳轉)到主檔案去讀取指令：

*   🖥️ **VS Code / GitHub Copilot Chat**：原生讀取 `.github/copilot-instructions.md`。
*   🖥️ **Cursor IDE**：透過專案根目錄的 `.cursorrules` 引導讀取主指令。
*   ⌨️ **Claude Code (Anthropic CLI)**：透過專案根目錄的 `CLAUDE.md` 自動注入 Context。
*   ⌨️ **Gemini CLI / Vertex AI**：透過專案根目錄的 `.geminirules` 引導。

**⚠ 工程師維護須知**：
如果你要修改規則或加入新指令，**請絕對不要**去修改 `.cursorrules` 或 `CLAUDE.md` 裡面那些短短一行的跳板設定，請**永遠只修改**：
1. `payload/.github/copilot-instructions.md` (主流程管線)
2. `payload/.agents/skills/*.md` (單一專家技能檔)
這樣一來，你的設定就能立即生效在全公司的各種 AI 工具上了！
