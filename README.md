# Agentic Skills & Instructions Installation Guide

這個儲存庫包含了統一的 AI Skills 與設定檔（例如 `.github` 的指令與 `.agents` 的技能庫）。為了讓不同的專案能夠快速套用這些設定，我們提供了幾種不同的安裝方式。

---

## 🚀 推薦做法：直接 Clone 並執行安裝腳本

這是最直覺的方式，透過執行內建的安裝腳本，可以精準地將設定檔佈署到目標專案的正確位置（如根目錄的 `.github/` 與 `.agents/`），完全符合 AI 工具（如 GitHub Copilot、Cursor）預設的讀取路徑。

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

---

## ⚡ 進階做法：透過 Git Submodule 保持更新

如果你希望你的專案能隨時同步 GitHub 上的更新（當你更新了某個 Skill，專案也能同步更新），可以使用 Git Submodule 的方式。

```bash
git submodule add https://github.com/SL-Nestor/agentic-skills.git .agents/shared-skills
```

**⚠️ 注意事項：工具讀取路徑問題**
使用 Submodule 會改變檔案的相對路徑。例如，Copilot 預設尋找的檔案會變成位在 `.agents/shared-skills/payload/.github/copilot-instructions.md`，這會導致部分 AI IDE 無法**自動**在背景載入。

**💡 解決方案：建立符號連結 (Symlink)**
為了解決路徑問題，建議在使用 Submodule 後，將需要的設定檔做符號連結回專案根目錄預設的位置。

*Windows 範例:*
```powershell
# 將 submodule 內的設定檔連結到專案根目錄的 .github 底下
New-Item -ItemType SymbolicLink -Path ".\.github\copilot-instructions.md" -Target ".\.agents\shared-skills\payload\.github\copilot-instructions.md"
```

*Linux / macOS 範例:*
```bash
ln -s ./.agents/shared-skills/payload/.github/copilot-instructions.md ./.github/copilot-instructions.md
```

這樣既能保持 Submodule 退出的連動更新優勢，也能完全相容各大 AI IDE 的預設路徑掃描與讀取。
