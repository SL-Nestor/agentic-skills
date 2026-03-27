# Agentic Skills & Instructions Installation Guide

這個儲存庫包含了統一的 AI Skills 與設定檔（例如 `.github` 的指令與 `.agents` 的技能庫）。為了讓不同的專案能夠快速套用這些設定，請依照下方步驟取得與安裝。

---

## 🚀 推薦做法：直接 Clone 並執行安裝腳本

這是最直覺且推薦的方式，透過執行內建的安裝腳本，可以精準地將設定檔佈署到目標專案的正確位置（如根目錄的 `.github/` 與 `.agents/`），完全符合各大 AI 工具（如 GitHub Copilot、Cursor）預設的讀取路徑。

### Linux / macOS (Unix 環境)
在任何需要套用的專案中，開啟終端機並執行：

```bash
git clone https://github.com/SL-Nestor/agentic-skills.git /tmp/ai-skills
cd /tmp/ai-skills
./install.sh /你的/目標專案/路徑
rm -rf /tmp/ai-skills # 安裝完畢後可刪除暫存
```

*(註：如果不在最後指定 `/你的/目標專案/路徑`，腳本預設會安裝在當前目錄 `.`)*

### Windows (PowerShell 環境)
在任何需要套用的專案中，開啟 PowerShell 並執行：

```powershell
git clone https://github.com/SL-Nestor/agentic-skills.git "$env:TEMP\ai-skills"
cd "$env:TEMP\ai-skills"
.\install.ps1 -TargetDir "C:\你的\目標專案\路徑"
Remove-Item -Recurse -Force "$env:TEMP\ai-skills" # 安裝完畢後可刪除暫存
```

*(註：如果不指定 `-TargetDir`，腳本預設會安裝在當前目錄)*
