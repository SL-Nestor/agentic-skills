param (
    [string]$TargetDir = "."
)

$ErrorActionPreference = "Stop"

$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
if (-not $PSScriptRoot) {
    if ($host.Name -eq 'ConsoleHost') {
        $PSScriptRoot = $PWD.Path
    } else {
        $PSScriptRoot = '.'
    }
}

$SourceDir = Join-Path $PSScriptRoot "payload"

Write-Host "Installing skills and instructions to $TargetDir..."

if (Test-Path (Join-Path $SourceDir ".github")) {
    $targetGithub = Join-Path $TargetDir ".github"
    if (-not (Test-Path $targetGithub)) {
        New-Item -ItemType Directory -Force -Path $targetGithub | Out-Null
    }
    Copy-Item -Path (Join-Path $SourceDir ".github\*") -Destination $targetGithub -Recurse -Force
}

if (Test-Path (Join-Path $SourceDir ".agents")) {
    $targetAgents = Join-Path $TargetDir ".agents"
    if (-not (Test-Path $targetAgents)) {
        New-Item -ItemType Directory -Force -Path $targetAgents | Out-Null
    }
    Copy-Item -Path (Join-Path $SourceDir ".agents\*") -Destination $targetAgents -Recurse -Force
}

$rootFiles = @(".cursorrules", ".geminirules", "CLAUDE.md", "AGENTS.md")
foreach ($file in $rootFiles) {
    $srcPath = Join-Path $SourceDir $file
    if (Test-Path $srcPath) {
        Copy-Item -Path $srcPath -Destination $TargetDir -Force
    }
}

Write-Host "Installation complete!"
