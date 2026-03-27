# 🚀 終極 SSDLC 自動駕駛 (Autopilot) 完整實戰指南

這份文件將帶你走完一個完整的開發週期：從「把 AI 專家團部署進全新專案」，到「建立需求」，最後「一鍵啟動自動駕駛開發流程」。

---

## 🛠️ 第一階段：部署專家團隊到新專案

要賦予專案 AI Agent (Copilot / Cursor) 頂級架構師的思維，你只需要**一行指令**：

### 1. 安裝環境設定檔與 Skills

在你的目標專案（新專案或現有專案）根目錄，打開終端機：

**Windows (PowerShell):**
```powershell
git clone https://github.com/SL-Nestor/agentic-skills.git "$env:TEMP\ai-skills"
cd "$env:TEMP\ai-skills"
.\install.ps1 -TargetDir "C:\你的\專案\真實路徑"
Remove-Item -Recurse -Force "$env:TEMP\ai-skills"
```

**Linux / macOS:**
```bash
git clone https://github.com/SL-Nestor/agentic-skills.git /tmp/ai-skills
cd /tmp/ai-skills
chmod +x install.sh
./install.sh /你的/專案/真實路徑
rm -rf /tmp/ai-skills
```

### 2. 驗證部署是否成功
執行完畢後，你的專案根目錄應該出現以下兩個資料夾：
1. `.github/copilot-instructions.md` (這是最高指導原則與自動駕駛大腦檔)
2. `.agents/skills/` (這裡面包含了 `spec-architect`, `code-review-expert`, `ssdlc-threat-modeling` 以及幾十個微軟 `.NET 官方專家庫`)

> **🎉 恭喜！你的專案已經武裝完畢，準備迎接自動駕駛！**

---

## 📝 第二階段：準備啟動素材

自動駕駛需要「導航目標」。請在你的專案中建立一個資料夾（例如 `docs/` 或 `specs/`），並準備一份**原始需求規格檔**。

舉例，你建立了一個檔名為 `docs/feature-login.md`：
```markdown
# 需求：會員登入功能
1. 允許使用者使用 Email 與 密碼 登入。
2. 密碼需要符合複雜度要求（至少 12 碼，包含大小寫與特殊符號）。
3. 登入失敗 5 次需鎖定帳號 15 分鐘。
```

這時候，對於 `開發計畫`、`開發任務`、`驗證條件`，你**不需要自己寫**，因為我們的 `spec-architect` 專家會來幫你寫！

---

## 🚀 第三階段：一鍵呼叫自動駕駛 (`/autopilot`)

打開你的 AI 聊天介面 (GitHub Copilot Chat 或 Cursor Chat)。

對著對話框，直接下達我們寫在設定檔裡的客製化指令，並給它四個檔案路徑（存在的當成輸入，不存在的 AI 會自動生成或填入）：

```text
/autopilot docs/feature-login.md docs/dev-plan.md docs/dev-tasks.md docs/acceptance-criteria.md
```

### 🤖 接下來的自動駕駛流程 (What happens next?)

當你按下 Enter 之後，奇蹟即將發生。AI 大腦（因為讀了 `.github/copilot-instructions.md`）會立刻展開以下操作，**不需你手動引導**：

1. **[環境偵測]**：啟動 Phase 0，AI 發現指令裡有 OpenSpec 要求，會自動檢查能不能用，如果不行，它會自動呼叫 `npx openspec` 確保環境不會爛掉。
2. **[建立追蹤表]**：它會在專案根目錄自動幫你生出一個 `SSDLC_TRACKER.md` 追蹤表格，把接下來要跑的 10 個 Phase 整整齊齊地列出來，並標上「✅ / 🔄 / 🔲」。
3. **[召喚規格架構師]**：AI 發現要產出任務跟驗證條件，它會去翻 `.agents/skills/spec-architect` 的守則。
   - 它會開始填寫 `docs/dev-plan.md`，並幫你**畫出 Mermaid 的 Clean Architecture 系統架構圖**。
   - 填寫 `docs/dev-tasks.md`，用**表格產出 Jira 可用的開發任務清單**。
   - 填寫 `docs/acceptance-criteria.md`，寫出完美的 **BDD (Given-When-Then) 測試案例**。
4. **[煞車與等待授權 - GATE P]**：AI 做完上述架構與分析後，會根據「最高指示」踩下煞車。
   它會對你說：*「規格與計畫已經準備完畢（Gate P），請問是否 Approve 進入下一階段開發？」*

---

## 🚧 第四階段：審查、修改與繼續 (The Dev Loop)

### 情境 A：你同意開發 ✅
回覆 AI：**「Approve，繼續 Phase 1 到 Phase 3」**。
AI 就會：
1. 呼叫 `ssdlc-threat-modeling` 專家，幫你建立 STRIDE 威脅模型報告。
2. 開始寫會 Fail 的單元測試 (TDD Red)。
3. 使用 `.NET 專家庫` 的各種神技，開始實作 C# 邏輯讓測試通過 (TDD Green)。

### 情境 B：你想修改需求 ❌
如果你發現 AI 畫的架構圖或寫的任務不符合預期，對 AI 說：*「密碼長度改回 8 碼就好」*。
- `spec-architect` 專家會**發動能力**：它不會直接去改程式碼，而是乖乖去修改 `feature-login.md`，並在文件最底下加上嚴格的 **Changelog 版本控制紀錄**。

### 情境 C：啟動無情程式碼審查員 🧐
當 AI 實作完成（來到 Phase 4），它會自動呼喚最後的魔王 `code-review-expert`。
- 這個專家會用最嚴苛的眼光審視剛才 AI 自己（或你）寫出來的程式。
- 尋找 SQLi 漏洞、效能 N+1 Query，或是沒有遵守 Clean Architecture 的地方。
- **它只會產出 Markdown 表格報告 (Code Review Report)，然後雙手離開鍵盤**，等待你說：「請根據建議重構」。

---

這就是一套結合了**自動化部署、最高權限架構大腦、加上數十位專業 AI 外包專家**的完美企業級 開發/審查/部署 循環！
