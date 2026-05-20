# SSDLC Autopilot — install.ps1 Pester Test Suite
# Framework: Pester v5+ (https://pester.dev)
# Coverage: FR-01, FR-02, FR-06, T-SEC-001, T-SEC-004, NFR-02 + OI-001 AC-01~AC-06
# Run: Invoke-Pester ./tests/install/test_install_ps1.Tests.ps1 -Output Detailed
# NOTE: FR-PS-03 (sensitive system path) tests are Windows-only; skipped on Linux/macOS.

BeforeAll {
    $RepoDir  = Resolve-Path (Join-Path $PSScriptRoot ".." "..")
    $Script   = Join-Path $RepoDir "install.ps1"
    $TmpRoot  = [System.IO.Path]::GetTempPath()
}

# Pester v5: BeforeEach/AfterEach must live inside a Describe.
# Wrap everything in a root-level Describe so shared lifecycle hooks apply everywhere.

Describe "install.ps1 Test Suite" {

    BeforeEach {
        $TmpTarget = Join-Path $TmpRoot ("ssdlc-test-" + [System.IO.Path]::GetRandomFileName())
        New-Item -ItemType Directory -Force -Path $TmpTarget | Out-Null
    }

    AfterEach {
        if (Test-Path $TmpTarget) { Remove-Item $TmpTarget -Recurse -Force }
    }

    # ─── FR-01: 平台隔離安裝 ─────────────────────────────────────────

    Describe "FR-01: 平台隔離安裝" {

        It "Claude 平台安裝產出 CLAUDE.md 與完整目錄結構" {
            & $Script -TargetDir $TmpTarget -Platform claude
            $LASTEXITCODE | Should -Be 0
            Join-Path $TmpTarget "CLAUDE.md"                              | Should -Exist
            Join-Path $TmpTarget ".agents" "agents"                       | Should -Exist
            Join-Path $TmpTarget ".agents" "skills"                       | Should -Exist
            Join-Path $TmpTarget ".agents" "standards"                    | Should -Exist
            Join-Path $TmpTarget ".agents" "hooks"                        | Should -Exist
            Join-Path $TmpTarget ".agents" "agents" "00-pm.md"            | Should -Exist
        }

        It "Claude 平台安裝不建立其他平台 entry 檔案" {
            & $Script -TargetDir $TmpTarget -Platform claude
            Join-Path $TmpTarget "GEMINI.md"                              | Should -Not -Exist
            Join-Path $TmpTarget "AGENTS.md"                              | Should -Not -Exist
        }

        It "Gemini 平台安裝產出 GEMINI.md" {
            & $Script -TargetDir $TmpTarget -Platform gemini
            $LASTEXITCODE | Should -Be 0
            Join-Path $TmpTarget "GEMINI.md" | Should -Exist
            Join-Path $TmpTarget "CLAUDE.md" | Should -Not -Exist
        }

        It "Codex 平台安裝產出 AGENTS.md" {
            & $Script -TargetDir $TmpTarget -Platform codex
            $LASTEXITCODE | Should -Be 0
            Join-Path $TmpTarget "AGENTS.md" | Should -Exist
            Join-Path $TmpTarget "CLAUDE.md" | Should -Not -Exist
        }

        It "all 平台安裝產出所有 entry 檔案" {
            & $Script -TargetDir $TmpTarget -Platform all
            $LASTEXITCODE | Should -Be 0
            Join-Path $TmpTarget "CLAUDE.md"  | Should -Exist
            Join-Path $TmpTarget "GEMINI.md"  | Should -Exist
            Join-Path $TmpTarget "AGENTS.md"  | Should -Exist
        }

        It "安裝至不存在的目錄會自動建立" {
            $NewDir = Join-Path $TmpTarget "brand-new-subdir"
            $NewDir | Should -Not -Exist
            & $Script -TargetDir $NewDir -Platform claude
            $LASTEXITCODE | Should -Be 0
            $NewDir                          | Should -Exist
            Join-Path $NewDir "CLAUDE.md"    | Should -Exist
        }
    }

    # ─── FR-02: 現有設定保護 ─────────────────────────────────────────

    Describe "FR-02: 現有設定保護" {

        It "現有 settings.json 不被覆寫" {
            $ClaudeDir    = Join-Path $TmpTarget ".claude"
            New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
            $SettingsPath = Join-Path $ClaudeDir "settings.json"
            '{"custom":true}' | Set-Content $SettingsPath

            & $Script -TargetDir $TmpTarget -Platform claude
            $LASTEXITCODE | Should -Be 0
            Get-Content $SettingsPath | Should -Match '"custom":true'
        }

        It "現有 settings.json 時輸出警告訊息" {
            $ClaudeDir = Join-Path $TmpTarget ".claude"
            New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
            '{"custom":true}' | Set-Content (Join-Path $ClaudeDir "settings.json")

            $output = & $Script -TargetDir $TmpTarget -Platform claude *>&1 | Out-String
            $LASTEXITCODE | Should -Be 0
            $output | Should -Match "already exists|manually merge"
        }

        It "無現有 settings.json 時正常安裝" {
            & $Script -TargetDir $TmpTarget -Platform claude
            $LASTEXITCODE | Should -Be 0
            Join-Path $TmpTarget ".claude" "settings.json" | Should -Exist
        }
    }

    # ─── T-SEC-001: 路徑遍歷防禦 ─────────────────────────────────────
    # NOTE: 實作改用 exit 1（非 throw），測試使用 $LASTEXITCODE 驗證

    Describe "T-SEC-001: 路徑遍歷防禦" {

        It "拒絕含 .. 的路徑遍歷輸入（exit 非零）" {
            & $Script -TargetDir "../../../etc" -Platform claude 2>&1 | Out-Null
            $LASTEXITCODE | Should -Not -Be 0
        }

        It "拒絕空字串目標（exit 非零）" {
            & $Script -TargetDir "" -Platform claude 2>&1 | Out-Null
            $LASTEXITCODE | Should -Not -Be 0
        }
    }

    # ─── 核心資料完整性 ───────────────────────────────────────────────

    Describe "核心資料完整性" {

        It "完整安裝後 9 個以上 claude agent 檔案存在" {
            & $Script -TargetDir $TmpTarget -Platform claude
            $agentCount = (Get-ChildItem (Join-Path $TmpTarget ".agents" "agents") -Filter "*.md").Count
            $agentCount | Should -BeGreaterOrEqual 9
        }

        It "完整安裝後 ssdlc-core-rules.md 存在" {
            & $Script -TargetDir $TmpTarget -Platform claude
            Join-Path $TmpTarget ".agents" "standards" "ssdlc-core-rules.md" | Should -Exist
        }

        It "完整安裝後 session hooks 存在" {
            & $Script -TargetDir $TmpTarget -Platform claude
            Join-Path $TmpTarget ".agents" "hooks" "session-start.md" | Should -Exist
            Join-Path $TmpTarget ".agents" "hooks" "session-end.md"   | Should -Exist
        }
    }

    # ─── NFR-01: 效能 ─────────────────────────────────────────────────

    Describe "NFR-01: 效能" {

        It "完整安裝在 30 秒內完成" {
            $elapsed = Measure-Command { & $Script -TargetDir $TmpTarget -Platform all }
            $elapsed.TotalSeconds | Should -BeLessThan 30
        }
    }

    # ══════════════════════════════════════════════════════════════════
    # OI-001 安全強化測試（FR-PS-01 ~ FR-PS-06）
    # Coverage: AC-01 ~ AC-06 per docs/oi-001-requirements.md
    # ══════════════════════════════════════════════════════════════════

    # ─── FR-PS-01: 空字串偵測 (AC-01) ────────────────────────────────

    Describe "FR-PS-01: 空字串偵測 (AC-01)" {

        It "空字串 TargetDir 應以非零 exit code 失敗" {
            & $Script -TargetDir "" -Platform claude 2>&1 | Out-Null
            $LASTEXITCODE | Should -Not -Be 0
        }

        It "空字串 TargetDir 應輸出包含 empty 或 invalid 的錯誤訊息" {
            $output = & $Script -TargetDir "" -Platform claude *>&1 | Out-String
            $output | Should -Match "empty|invalid|空|不可"
        }

        It "空白字串 TargetDir 同樣應拒絕" {
            & $Script -TargetDir "   " -Platform claude 2>&1 | Out-Null
            $LASTEXITCODE | Should -Not -Be 0
        }
    }

    # ─── FR-PS-02: 路徑遍歷偵測 (AC-02) ──────────────────────────────

    Describe "FR-PS-02: 路徑遍歷偵測 (AC-02)" {

        It "含 .. 的路徑應失敗並輸出 path traversal 訊息" {
            $output = & $Script -TargetDir "../../etc" -Platform claude *>&1 | Out-String
            $LASTEXITCODE | Should -Not -Be 0
            $output | Should -Match "path traversal|路徑遍歷"
        }

        It "多層 .. 路徑同樣應被拒絕" {
            $output = & $Script -TargetDir "../.." -Platform claude *>&1 | Out-String
            $LASTEXITCODE | Should -Not -Be 0
            $output | Should -Match "path traversal|路徑遍歷"
        }
    }

    # ─── FR-PS-03: 敏感系統路徑封鎖 (AC-03) — Windows Only ───────────

    Describe "FR-PS-03: 敏感系統路徑封鎖 (AC-03) [Windows-only]" {

        BeforeAll {
            $IsWindowsHost = $IsWindows -or ($PSVersionTable.PSEdition -eq 'Desktop')
        }

        It "C:\Windows 應被封鎖並輸出 sensitive 訊息" -Skip:(-not $IsWindowsHost) {
            $output = & $Script -TargetDir "C:\Windows" -Platform claude *>&1 | Out-String
            $LASTEXITCODE | Should -Not -Be 0
            $output | Should -Match "sensitive|system path|敏感"
        }

        It "C:\Program Files 應被封鎖" -Skip:(-not $IsWindowsHost) {
            $output = & $Script -TargetDir "C:\Program Files" -Platform claude *>&1 | Out-String
            $LASTEXITCODE | Should -Not -Be 0
            $output | Should -Match "sensitive|system path|敏感"
        }

        It "C:\Windows\System32 子路徑同樣封鎖" -Skip:(-not $IsWindowsHost) {
            $output = & $Script -TargetDir "C:\Windows\System32" -Platform claude *>&1 | Out-String
            $LASTEXITCODE | Should -Not -Be 0
            $output | Should -Match "sensitive|system path|敏感"
        }
    }

    # ─── FR-PS-04: 來源目錄驗證 (AC-04) ──────────────────────────────

    Describe "FR-PS-04: 來源目錄驗證 (AC-04)" {

        It "缺少 core/ 目錄應失敗並輸出 not found 訊息" {
            # 建立假 repo（沒有 core/ 目錄）
            $FakeRepo   = Join-Path $TmpTarget "fake-repo-nocore"
            New-Item -ItemType Directory -Path $FakeRepo | Out-Null
            Copy-Item $Script $FakeRepo

            $FakeScript = Join-Path $FakeRepo "install.ps1"
            $Dest       = Join-Path $TmpTarget "dest-nocore"

            $output = & $FakeScript -TargetDir $Dest -Platform claude *>&1 | Out-String
            $LASTEXITCODE | Should -Not -Be 0
            $output | Should -Match "not found|找不到|missing|core"
        }
    }

    # ─── FR-PS-05: 失敗時回滾 (AC-05) ────────────────────────────────

    Describe "FR-PS-05: 安裝失敗後回滾 (AC-05)" {

        It "安裝失敗後應輸出 Rollback complete" {
            # 假 repo：core/ 存在（通過 FR-PS-04），platforms/ 不存在（觸發失敗）
            $FakeRepo = Join-Path $TmpTarget "fake-repo-rollback"
            New-Item -ItemType Directory -Path $FakeRepo | Out-Null
            Copy-Item $Script $FakeRepo

            foreach ($sub in @("skills","standards","templates","hooks")) {
                New-Item -ItemType Directory -Path (Join-Path $FakeRepo "core" $sub) -Force | Out-Null
            }

            $FakeScript = Join-Path $FakeRepo "install.ps1"
            $Dest       = Join-Path $TmpTarget "dest-rollback"

            $output = & $FakeScript -TargetDir $Dest -Platform claude *>&1 | Out-String
            $LASTEXITCODE | Should -Not -Be 0
            $output | Should -Match "Rollback complete|回滾完成"
        }

        It "回滾後新建立的目標目錄應被清除" {
            $FakeRepo = Join-Path $TmpTarget "fake-repo-rollback2"
            New-Item -ItemType Directory -Path $FakeRepo | Out-Null
            Copy-Item $Script $FakeRepo

            foreach ($sub in @("skills","standards","templates","hooks")) {
                New-Item -ItemType Directory -Path (Join-Path $FakeRepo "core" $sub) -Force | Out-Null
            }

            $FakeScript = Join-Path $FakeRepo "install.ps1"
            $Dest       = Join-Path $TmpTarget "dest-rollback2"   # 安裝前不存在

            & $FakeScript -TargetDir $Dest -Platform claude 2>&1 | Out-Null
            $LASTEXITCODE | Should -Not -Be 0
            $Dest | Should -Not -Exist
        }
    }

    # --- FR-PS-06: SHA256 Integrity Output (AC-06) ---

    Describe "FR-PS-06: SHA256 Integrity Output (AC-06)" {

        It "Claude platform install outputs SHA256 hash (64 hex chars)" {
            $output = & $Script -TargetDir $TmpTarget -Platform claude *>&1 | Out-String
            $LASTEXITCODE | Should -Be 0
            $output | Should -Match "[0-9a-fA-F]{64}"
        }

        It "SHA256 output references ssdlc-core-rules" {
            $output = & $Script -TargetDir $TmpTarget -Platform claude *>&1 | Out-String
            $output | Should -Match "ssdlc-core-rules"
        }

        It "Gemini platform should NOT output SHA256 (Claude-only)" {
            $dest   = Join-Path $TmpTarget "gemini-dest"
            $output = & $Script -TargetDir $dest -Platform gemini *>&1 | Out-String
            $LASTEXITCODE | Should -Be 0
            $output | Should -Not -Match "SHA256.*[0-9a-fA-F]{64}"
        }
    }

} # end Describe "install.ps1 Test Suite"
