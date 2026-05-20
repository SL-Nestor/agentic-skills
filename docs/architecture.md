# SSDLC Autopilot — Architecture v1.0
> **Author**: $spec-architect  
> **Date**: 2026-05-19  
> **Input**: docs/requirements.md  
> **Status**: Gate P pending

---

## 1. 系統架構圖

```mermaid
graph TD
    subgraph "Repository (Source of Truth)"
        CORE["core/\n─ skills/\n─ standards/\n─ templates/\n─ hooks/"]
        PLAT["platforms/\n─ claude/ ─ gemini/\n─ codex/ ─ copilot/"]
        PLUGIN[".claude-plugin/\n─ plugin.json\n─ skills/"]
        INSTALL["install.sh\ninstall.ps1"]
    end

    subgraph "Target Project (After Install)"
        AGENTS[".agents/\n─ agents/  ← platform-specific\n─ skills/  ← from core\n─ standards/\n─ hooks/"]
        ENTRY["Entry Files\nCLAUDE.md / GEMINI.md\nAGENTS.md / copilot-instructions.md"]
        CLAUDE_CFG[".claude/\n─ settings.json (hooks)"]
        TRACKER["SSDLC_TRACKER.md"]
        HANDOFF["AGENT_HANDOFF.md"]
    end

    subgraph "AI Runtime"
        AI["AI Agent\n(Claude / Gemini / Codex)"]
        CAVEMEM["cavemem\n(optional MCP)"]
    end

    INSTALL -->|"copy core/"| AGENTS
    INSTALL -->|"copy platform entry"| ENTRY
    INSTALL -->|"install hooks"| CLAUDE_CFG

    ENTRY -->|"SSDLC session init"| AI
    CLAUDE_CFG -->|"UserPromptSubmit hook"| AI
    AI -->|"reads"| AGENTS
    AI -->|"writes"| TRACKER
    AI -->|"writes"| HANDOFF
    AI <-->|"search / get_observations"| CAVEMEM
```

---

## 2. 安裝流程架構圖

```mermaid
sequenceDiagram
    participant U as User
    participant I as install.sh
    participant V as Validator
    participant F as FileSystem

    U->>I: install.sh <target> <platform>
    I->>V: validate_target_path(target)
    V-->>I: OK / REJECT (path traversal)
    
    alt Path Invalid
        I->>U: "Invalid target directory" + exit 1
    else Path Valid
        I->>F: mkdir -p target/.agents/{agents,skills,standards,templates,hooks}
        I->>F: cp -Rf core/skills → .agents/skills
        I->>F: cp -Rf core/standards → .agents/standards
        I->>F: cp -Rf core/hooks → .agents/hooks
        
        alt Platform = claude
            I->>F: cp CLAUDE.md → target/
            I->>F: cp platform/agents/* → .agents/agents/
            I->>V: check_existing_settings(target/.claude/settings.json)
            alt settings.json exists
                I->>U: WARNING: "already exists, merge manually"
            else
                I->>F: cp settings.json → target/.claude/
            end
        end
        
        I->>U: "✅ Installation complete!"
        I->>U: exit 0
    end
```

---

## 3. Hook 觸發鏈（Gate 執行機制）

```mermaid
flowchart LR
    subgraph "Claude Code Runtime"
        UPS["UserPromptSubmit\nevent"]
        STOP["Stop\nevent"]
    end

    subgraph "Hook Scripts"
        H1["check-ssdlc-installed.sh\n→ .agents/ exists?"]
        H2["check-gate-p.sh\n→ $implementer detected?\n→ docs/threat-model.md exists?"]
        H3["check-gate-d.sh\n→ $devops detected?\n→ docs/security-gate-report.md PASS?"]
        H4["session-end-reminder.sh\n→ SSDLC_TRACKER.md exists?"]
    end

    UPS --> H1
    UPS --> H2
    UPS --> H3
    STOP --> H4

    H2 -->|"BLOCKED"| WARN_P["⛔ Gate P: run $threat-modeler first"]
    H3 -->|"BLOCKED"| WARN_D["⛔ Gate D: run $security-gate first"]
    H2 -->|"OK"| ALLOW["✅ Proceed"]
    H3 -->|"OK"| ALLOW
```

---

## 4. 信任邊界分析 (Trust Boundaries)

```mermaid
graph TD
    subgraph "Trusted Zone — Repository Content"
        REPO_FILES["core/ + platforms/ 檔案\n（由 repo owner 控制）"]
    end

    subgraph "Untrusted Zone — User Input"
        TARGET_PATH["TargetDir 參數\n（使用者輸入，可能含惡意路徑）"]
        USER_CMD["AI macro 指令\n（使用者輸入，可能繞過 Gate）"]
    end

    subgraph "Semi-Trusted Zone — Target Project"
        EXISTING_FILES["目標專案現有檔案\n（可能已被修改）"]
        SETTINGS["settings.json\n（已安裝的設定）"]
    end

    TARGET_PATH -->|"必須驗證"| REPO_FILES
    USER_CMD -->|"Hook 攔截"| SETTINGS
    EXISTING_FILES -->|"合併時檢查"| SETTINGS
```

**識別的信任邊界：**
1. **TB-01**: `TargetDir` 參數 → 檔案系統寫入（路徑遍歷風險）
2. **TB-02**: 使用者 macro 指令 → Agent 角色採用（Gate 繞過風險）
3. **TB-03**: 現有 settings.json → 安裝覆寫（設定損毀風險）
4. **TB-04**: `core/` 來源 → 目標複製（來源完整性風險）

---

## 5. 開放問題解決方案

### OI-002: Plugin 安裝後 .agents/agents/ 不存在問題

**決策**：Plugin skill 文件採用「嵌入 + 引用」雙模式：
- 嵌入模式：`.claude-plugin/skills/*.md` 包含完整 agent 行為描述（自給自足）
- 引用模式：如果 `.agents/agents/` 存在（完整安裝），優先讀取完整版

每個 plugin skill 文件更新為包含完整行為定義，`> 完整版：請參閱 .agents/agents/` 降為提示而非必要依賴。

---

## 6. 元件清單與職責

| 元件 | 路徑 | 職責 | 被誰依賴 |
|------|------|------|---------|
| Core Skills | `core/skills/` | 91 個 SKILL.md | 所有平台安裝 |
| Core Standards | `core/standards/` | SSDLC 規則、Agent 網絡定義 | AI Agent runtime |
| Core Hooks | `core/hooks/` | Session start/end 行為規範 | 安裝後的專案 |
| Platform Agents | `platforms/{p}/agents/` | 平台特定格式的 Agent 指令 | install 腳本 |
| Hook Scripts | `tests/hooks/` (新增) | Gate 前置條件 shell 腳本 | settings.json hooks |
| bats Tests | `tests/install/` (新增) | install.sh 行為驗證 | CI Pipeline |
| Ghost Skills | `platforms/{p}/agents/` (補完) | $deep-interview等4個 Agent | Claude/Gemini/Codex runtime |

---

## 7. 新增目錄結構（Phase 4 後）

```
agentic-skills/
├── core/
│   ├── hooks/
│   │   ├── session-start.md
│   │   ├── session-end.md
│   │   └── gate-checks/           ← 新增
│   │       ├── check-gate-p.sh
│   │       └── check-gate-d.sh
│   ├── skills/
│   └── standards/
├── docs/                          ← 新增
│   ├── requirements.md
│   ├── architecture.md
│   ├── threat-model.md
│   └── tasks.md
├── tests/                         ← 新增
│   ├── install/
│   │   ├── test_install_sh.bats
│   │   └── test_install_ps1.Tests.ps1
│   └── skills/
│       ├── pm.TESTS.md
│       ├── req-analyst.TESTS.md
│       └── ... (9 個)
├── platforms/
│   └── claude/
│       ├── agents/
│       │   ├── omni-deep-interview.md  ← 新增
│       │   ├── omni-ccg.md             ← 新增
│       │   ├── omni-ralph.md           ← 新增
│       │   └── omni-stack-advisor.md   ← 新增
│       └── hooks/
│           └── settings.json           ← 強化
└── .github/
    └── workflows/
        └── ci.yml                      ← 新增
```
