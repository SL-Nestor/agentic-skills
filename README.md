# 🧬 Agentic Skills - Multi-Agent Network (v9.2.0)

這個儲存庫是針對軟體開發團隊所配置的**異質多代理協作網路 (Multi-Agent Orchestration)** 與 **SSDLC (安全軟體開發生命週期)** 大腦設定檔。

我們透過配置多位 AI 專家（如：架構師、威脅建模師、實作工程師、安檢閘口審查員），並運用 **Claude Code** 與 **OpenAI Codex** 作為主力開發引擎，搭配其他模型進行交叉防護與互相審查，徹底解決單一 LLM 的死角與包庇現象。

## ✨ 核心亮點：實體交接單驅動 (Handoff-Driven)
告別冗長對話導致的「Token 爆炸」與「AI 幻覺」！本系統內建 **Universal Handoff Protocol**。
每個任務階段 (Phase) 結束、或是遇到 Debug 卡關時，AI 會自動產出**雙軌交接**：`.ai/handoff/latest_memo.md`（散文版）+ `.ai/handoff/latest_state.json`（結構化狀態 SSOT）。你隨時可以開啟全新的對話視窗（甚至切換給不同的 AI 模型），並輸入指令 `$pm continue`。新的 AI 將先讀取 JSON 狀態確認進度，再讀散文補充上下文，實現**「跨部門、跨模型」**的極致效能協作。

## 🆕 v9.2.0：主力引擎切換至 Codex + Claude

本版本正式將開發主力引擎從 Copilot / Cline 切換至 **OpenAI Codex** 與 **Claude Code**：

- **🎯 雙主力引擎**：`AGENTS.md`（Codex VSCode + CLI）與 `CLAUDE.md`（Claude Code）為第一優先開發入口
- **📘 SSOT 重新定位**：`.github/copilot-instructions.md` 維持作為核心 SSDLC 協議文件，所有入口檔統一導向此 SSOT
- **🔧 向下相容**：Cursor (`.cursorrules`) 與 Gemini CLI (`.geminirules`) 持續保留支援

## 📖 官方操作手冊

👉 **[【🚀 SSDLC Autopilot: 多代理協作網路實戰手冊】](./docs/USER_MANUAL.md)**

---

## 🚀 部署教學 (安裝至你的目標專案)

透過執行內建的安裝腳本，可以一鍵將這個「虛擬團隊設定檔」佈署到你要實際開發的專案根目錄中（如 `AGENTS.md`、`CLAUDE.md`、`.github/` 與 `.agents/`）。這些設定將直接融入 **OpenAI Codex (VSCode / CLI)** 與 **Claude Code** 的原生開發流，同時向下相容 Cursor 與 Gemini CLI。

### Windows (PowerShell)
在需要套用的專案中，開啟 PowerShell：

```powershell
git clone https://github.com/SL-Nestor/agentic-skills.git "$env:TEMP\ai-skills"
cd "$env:TEMP\ai-skills"
.\install.ps1 -TargetDir "C:\你的\目標專案\路徑"
Remove-Item -Recurse -Force "$env:TEMP\ai-skills"
```

### Linux / macOS (Unix)
在需要套用的專案中，開啟終端機：

```bash
git clone https://github.com/SL-Nestor/agentic-skills.git /tmp/ai-skills
cd /tmp/ai-skills
bash ./install.sh /你的/目標專案/路徑
rm -rf /tmp/ai-skills
```
