# 🧬 Agentic Skills - Multi-Agent Network (v7.9.5)

這個儲存庫是針對軟體開發團隊所配置的**異質多代理協作網路 (Multi-Agent Orchestration)** 與 **SSDLC (安全軟體開發生命週期)** 大腦設定檔。

我們透過配置多位 AI 專家（如：架構師、威脅建模師、實作工程師、安檢閘口審查員），並運用不同底層模型（Claude, Gemini, GPT-4o）進行交叉防護與互相審查，徹底解決單一 LLM 的死角與包庇現象。

## 📖 官方操作手冊

**我們在 v7.9.5 已經大規模升級為多代理模式。請務必閱讀最新版手冊：**
👉 **[【🚀 SSDLC Autopilot: 多代理協作網路實戰手冊】](./docs/USER_MANUAL.md)**

---

## 🚀 部署教學 (安裝至你的目標專案)

透過執行內建的安裝腳本，可以一鍵將這個「虛擬團隊設定檔」佈署到你要實際開發的專案根目錄中（如 `.github/` 與 `.agents/`）。這些設定將直接融入 GitHub Copilot、Cline 或 Cursor 的原生開發流。

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
