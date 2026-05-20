# SSDLC Autopilot — Remote Installer (PowerShell)
# Usage:
#   irm https://raw.githubusercontent.com/SL-Nestor/agentic-skills/main/install-remote.ps1 | iex
#
# With parameters (save first, then run):
#   $script = irm https://raw.githubusercontent.com/.../install-remote.ps1
#   & ([scriptblock]::Create($script)) -TargetDir "C:\my-project" -Platform claude
#
param(
    [string]$TargetDir = ".",
    [ValidateSet("copilot", "claude", "gemini", "codex", "all")]
    [string]$Platform = "claude"
)

$ErrorActionPreference = "Stop"

$RepoOwner  = "SL-Nestor"
$RepoName   = "agentic-skills"
$Branch     = "main"
$ArchiveUrl = "https://github.com/$RepoOwner/$RepoName/archive/refs/heads/$Branch.zip"

# ── 路徑驗證 ────────────────────────────────────────────────────
if ([string]::IsNullOrWhiteSpace($TargetDir)) {
    Write-Error "Invalid target directory (empty string)"
    exit 1
}
if ($TargetDir -match '\.\.') {
    Write-Error "Invalid target directory (path traversal detected)"
    exit 1
}

Write-Host ""
Write-Host "SSDLC Autopilot — Remote Installer (PowerShell)"
Write-Host "   Repository : $RepoOwner/$RepoName@$Branch"
Write-Host "   Target     : $TargetDir"
Write-Host "   Platform   : $Platform"
Write-Host ""

# ── 暫存目錄 ────────────────────────────────────────────────────
$TempDir = Join-Path $env:TEMP "ssdlc-install-$(Get-Random)"
New-Item -ItemType Directory -Path $TempDir | Out-Null

try {
    # 下載 repo zip
    $ZipPath = Join-Path $TempDir "repo.zip"
    Write-Host "Downloading repository..."
    Invoke-WebRequest -Uri $ArchiveUrl -OutFile $ZipPath -UseBasicParsing

    # 解壓
    $ExtractDir = Join-Path $TempDir "extracted"
    Expand-Archive -Path $ZipPath -DestinationPath $ExtractDir
    $RepoDir = Get-ChildItem -Path $ExtractDir -Directory | Select-Object -First 1

    # 執行安裝
    Write-Host "Running installer..."
    & "$($RepoDir.FullName)\install.ps1" -TargetDir $TargetDir -Platform $Platform

    Write-Host ""
    Write-Host "SSDLC Autopilot installed successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:"
    switch ($Platform) {
        "claude" {
            Write-Host "  1. Open $TargetDir in Claude Code"
            Write-Host "  2. Type: `$pm [your task]"
        }
        "codex" {
            Write-Host "  1. Open $TargetDir in OpenAI Codex CLI"
            Write-Host "  2. Type: `$pm [your task]"
        }
        default {
            Write-Host "  Open $TargetDir in your AI tool and type: `$pm [your task]"
        }
    }
    Write-Host ""
}
finally {
    Remove-Item -Recurse -Force $TempDir -ErrorAction SilentlyContinue
}
