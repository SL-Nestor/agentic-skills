param (
    [string]$TargetDir = ".",
    [ValidateSet("copilot", "claude", "gemini", "codex", "all")]
    [string]$Platform = "all"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
if (-not $ScriptDir) {
    $ScriptDir = $PWD.Path
}

$CoreDir      = Join-Path $ScriptDir "core"
$PlatformsDir = Join-Path $ScriptDir "platforms"

# ── Security Validation ────────────────────────────────────────────────────────
# Mirrors the safety checks in install.sh (T-SEC-001 ~ T-SEC-004)

function Test-PathSafe {
    param([string]$Path)

    # FR-PS-01: Reject empty / whitespace target
    if ([string]::IsNullOrWhiteSpace($Path)) {
        Write-Host "ERROR: TargetDir cannot be empty or whitespace. Provide a valid target path." -ForegroundColor Red
        exit 1
    }

    # FR-PS-02: Reject path traversal (..)
    if ($Path -match '\.\.') {
        Write-Host "ERROR: path traversal detected in TargetDir: '$Path'" -ForegroundColor Red
        exit 1
    }

    # FR-PS-03: Reject sensitive system paths
    $resolved = $Path
    try { $resolved = [System.IO.Path]::GetFullPath($Path) } catch {}
    $resolved = $resolved.TrimEnd('\')

    $sensitiveBases = @(
        $env:SystemRoot,
        $env:ProgramFiles,
        ${env:ProgramFiles(x86)},
        "C:\Windows",
        "C:\Program Files",
        "C:\Program Files (x86)",
        "C:\System Volume Information",
        "C:\ProgramData",
        "C:\Users\Default",
        $env:windir
    ) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

    foreach ($base in $sensitiveBases) {
        $normalised = $base
        try { $normalised = [System.IO.Path]::GetFullPath($base) } catch {}
        $normalised = $normalised.TrimEnd('\')

        $isExact  = $resolved -ieq $normalised
        $isChild  = $resolved.StartsWith("$normalised\", [System.StringComparison]::OrdinalIgnoreCase)

        if ($isExact -or $isChild) {
            Write-Host "ERROR: sensitive system path blocked: '$resolved'" -ForegroundColor Red
            exit 1
        }
    }
}

function Test-SourceDirs {
    # FR-PS-04: Validate that the repo's core/ subdirectories are present
    $required = @(
        (Join-Path $CoreDir "skills"),
        (Join-Path $CoreDir "standards"),
        (Join-Path $CoreDir "templates"),
        (Join-Path $CoreDir "hooks")
    )
    foreach ($dir in $required) {
        if (-not (Test-Path $dir -PathType Container)) {
            Write-Host "ERROR: core/ directory not found: '$dir'. Ensure install.ps1 is run from the agentic-skills repo root." -ForegroundColor Red
            exit 1
        }
    }
}

# ── Rollback Support ───────────────────────────────────────────────────────────
# FR-PS-05: On any error, undo what was written to $TargetDir.

function Invoke-Rollback {
    param(
        [string]$Target,
        [bool]$TargetWasNew
    )
    Write-Host ""
    Write-Host "  Installation failed. Rolling back..." -ForegroundColor Red

    if ($TargetWasNew -and (Test-Path $Target)) {
        # Target was created by this run — remove entirely
        Remove-Item $Target -Recurse -Force -ErrorAction SilentlyContinue
    } else {
        # Target pre-existed — best-effort removal of known artifacts only
        $artifacts = @(
            (Join-Path $Target "CLAUDE.md"),
            (Join-Path $Target "GEMINI.md"),
            (Join-Path $Target "AGENTS.md"),
            (Join-Path $Target ".agents"),
            (Join-Path $Target ".claude"),
            (Join-Path $Target ".github")
        )
        foreach ($a in $artifacts) {
            if (Test-Path $a) {
                Remove-Item $a -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }

    Write-Host "  Rollback complete." -ForegroundColor Yellow
}

# ── Core + Platform Install Functions ─────────────────────────────────────────

function Copy-CoreAgentAssets {
    param([string]$Target)
    $agentsDir = Join-Path $Target ".agents"

    # Skills
    $skillsDest = Join-Path $agentsDir "skills"
    if (-not (Test-Path $skillsDest)) { New-Item -ItemType Directory -Force -Path $skillsDest | Out-Null }
    Copy-Item -Path (Join-Path $CoreDir "skills\*") -Destination $skillsDest -Recurse -Force

    # Standards
    $standardsDest = Join-Path $agentsDir "standards"
    if (-not (Test-Path $standardsDest)) { New-Item -ItemType Directory -Force -Path $standardsDest | Out-Null }
    Copy-Item -Path (Join-Path $CoreDir "standards\*") -Destination $standardsDest -Recurse -Force

    # Templates
    $templatesDest = Join-Path $agentsDir "templates"
    if (-not (Test-Path $templatesDest)) { New-Item -ItemType Directory -Force -Path $templatesDest | Out-Null }
    Copy-Item -Path (Join-Path $CoreDir "templates\*") -Destination $templatesDest -Recurse -Force

    # Hooks
    $hooksDest = Join-Path $agentsDir "hooks"
    if (-not (Test-Path $hooksDest)) { New-Item -ItemType Directory -Force -Path $hooksDest | Out-Null }
    Copy-Item -Path (Join-Path $CoreDir "hooks\*") -Destination $hooksDest -Recurse -Force
}

function Install-Copilot {
    param([string]$Target)
    Write-Host "  [Copilot] Installing GitHub Copilot platform..." -ForegroundColor Cyan

    $platformDir = Join-Path $PlatformsDir "copilot"

    # .github/ entry files
    $githubDest = Join-Path $Target ".github"
    if (-not (Test-Path $githubDest)) { New-Item -ItemType Directory -Force -Path $githubDest | Out-Null }
    Copy-Item -Path (Join-Path $platformDir "entry\*") -Destination $githubDest -Recurse -Force

    # GitHub Actions workflows
    $workflowsDest = Join-Path $githubDest "workflows"
    if (-not (Test-Path $workflowsDest)) { New-Item -ItemType Directory -Force -Path $workflowsDest | Out-Null }
    Copy-Item -Path (Join-Path $platformDir "workflows\*") -Destination $workflowsDest -Recurse -Force

    # .agents/agents/ - Copilot .agent.md format
    $agentsDest = Join-Path $Target ".agents\agents"
    if (-not (Test-Path $agentsDest)) { New-Item -ItemType Directory -Force -Path $agentsDest | Out-Null }
    Copy-Item -Path (Join-Path $platformDir "agents\*") -Destination $agentsDest -Recurse -Force

    # Shared core assets
    Copy-CoreAgentAssets -Target $Target

    Write-Host "  [Copilot] Done. Entry: .github/copilot-instructions.md" -ForegroundColor Green
}

function Install-Claude {
    param([string]$Target)
    Write-Host "  [Claude] Installing Claude (Claude Code / Cowork) platform..." -ForegroundColor Cyan

    $platformDir = Join-Path $PlatformsDir "claude"

    # CLAUDE.md at project root
    Copy-Item -Path (Join-Path $platformDir "entry\CLAUDE.md") -Destination $Target -Force

    # .agents/agents/ - plain markdown format
    $agentsDest = Join-Path $Target ".agents\agents"
    if (-not (Test-Path $agentsDest)) { New-Item -ItemType Directory -Force -Path $agentsDest | Out-Null }
    Copy-Item -Path (Join-Path $platformDir "agents\*") -Destination $agentsDest -Recurse -Force

    # Claude Code settings.json (hooks config)
    $claudeDir = Join-Path $Target ".claude"
    if (-not (Test-Path $claudeDir)) { New-Item -ItemType Directory -Force -Path $claudeDir | Out-Null }
    $settingsTarget = Join-Path $claudeDir "settings.json"
    if (Test-Path $settingsTarget) {
        Write-Host "    [Claude] NOTE: .claude\settings.json already exists. Manually merge hooks from platforms\claude\hooks\settings.json" -ForegroundColor Yellow
    } else {
        Copy-Item -Path (Join-Path $platformDir "hooks\settings.json") -Destination $settingsTarget -Force
        Write-Host "    [Claude] Installed: .claude\settings.json (session hooks)" -ForegroundColor Gray
    }

    # Shared core assets
    Copy-CoreAgentAssets -Target $Target

    # FR-PS-06: SHA256 integrity output for core rules file
    $rulesFile = Join-Path $Target ".agents\standards\ssdlc-core-rules.md"
    if (Test-Path $rulesFile) {
        $hash = (Get-FileHash $rulesFile -Algorithm SHA256).Hash
        Write-Host "  [Integrity] SHA256 ssdlc-core-rules.md: $hash" -ForegroundColor Gray
    }

    Write-Host "  [Claude] Done. Entry: CLAUDE.md + .claude\settings.json" -ForegroundColor Green
}

function Install-Gemini {
    param([string]$Target)
    Write-Host "  [Gemini] Installing Gemini CLI platform..." -ForegroundColor Cyan

    $platformDir = Join-Path $PlatformsDir "gemini"

    # GEMINI.md at project root
    Copy-Item -Path (Join-Path $platformDir "entry\GEMINI.md") -Destination $Target -Force

    # .agents/agents/ - plain markdown format
    $agentsDest = Join-Path $Target ".agents\agents"
    if (-not (Test-Path $agentsDest)) { New-Item -ItemType Directory -Force -Path $agentsDest | Out-Null }
    Copy-Item -Path (Join-Path $platformDir "agents\*") -Destination $agentsDest -Recurse -Force

    # Shared core assets
    Copy-CoreAgentAssets -Target $Target

    Write-Host "  [Gemini] Done. Entry: GEMINI.md" -ForegroundColor Green
}

function Install-Codex {
    param([string]$Target)
    Write-Host "  [Codex] Installing OpenAI Codex CLI platform..." -ForegroundColor Cyan

    $platformDir = Join-Path $PlatformsDir "codex"

    # AGENTS.md at project root (Codex CLI convention)
    Copy-Item -Path (Join-Path $platformDir "entry\AGENTS.md") -Destination $Target -Force

    # .agents/agents/ - plain markdown format
    $agentsDest = Join-Path $Target ".agents\agents"
    if (-not (Test-Path $agentsDest)) { New-Item -ItemType Directory -Force -Path $agentsDest | Out-Null }
    Copy-Item -Path (Join-Path $platformDir "agents\*") -Destination $agentsDest -Recurse -Force

    # Shared core assets
    Copy-CoreAgentAssets -Target $Target

    Write-Host "  [Codex] Done. Entry: AGENTS.md" -ForegroundColor Green
}

# ── Main ──────────────────────────────────────────────────────────────────────

# Security gates — must pass before any file I/O
Test-PathSafe   -Path $TargetDir
Test-SourceDirs

Write-Host ""
Write-Host "🧬 SSDLC Autopilot Installer v8.0.1" -ForegroundColor Yellow
Write-Host "   Target : $TargetDir" -ForegroundColor Gray
Write-Host "   Platform: $Platform" -ForegroundColor Gray
Write-Host ""

# Record whether the target already existed (used by rollback)
$TargetWasNew = -not (Test-Path $TargetDir)

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
}

try {
    switch ($Platform) {
        "copilot" { Install-Copilot -Target $TargetDir }
        "claude"  { Install-Claude  -Target $TargetDir }
        "gemini"  { Install-Gemini  -Target $TargetDir }
        "codex"   { Install-Codex   -Target $TargetDir }
        "all" {
            Install-Copilot -Target $TargetDir
            Install-Claude  -Target $TargetDir
            Install-Gemini  -Target $TargetDir
            Install-Codex   -Target $TargetDir
        }
    }
} catch {
    Write-Host ""
    Write-Host "ERROR: $_" -ForegroundColor Red
    Invoke-Rollback -Target $TargetDir -TargetWasNew $TargetWasNew
    exit 1
}

Write-Host ""
Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Quick start:" -ForegroundColor Yellow
switch ($Platform) {
    "copilot" { Write-Host '  Open VS Code -> GitHub Copilot Chat -> type: @00-pm' }
    "claude"  { Write-Host '  Open Claude Code -> type: $pm [your task]' }
    "gemini"  { Write-Host '  In terminal: gemini -p "$pm [your task]" or open GEMINI.md context' }
    "codex"   { Write-Host '  In terminal: codex "$pm [your task]" (reads AGENTS.md automatically)' }
    "all"     { Write-Host '  See README.md for per-platform quick start instructions.' }
}
Write-Host ""
exit 0
