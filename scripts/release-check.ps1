# release-check.ps1 - run the release-check skill headlessly via Codex.
#
# Composes the skill's inputs into one prompt and hands it to
# `codex exec` from this repo's root. Codex gathers the evidence with
# its MCP servers (github + doc-search) and writes the draft release
# assessment to a local file. Nothing is posted anywhere by this script.
#
# Usage:
#   .\scripts\release-check.ps1 -App demo-app -Version v1.1.0 -Since 2026-11-01
#   .\scripts\release-check.ps1 -App demo-app -Version v1.1.0 -Since v1.0.0 -OutFile C:\drafts\rc.md

param(
    [Parameter(Mandatory = $true)][string]$App,
    [Parameter(Mandatory = $true)][string]$Version,
    [Parameter(Mandatory = $true)][string]$Since,
    [string]$OutFile,
    [string]$CodexExe
)

# Note: no $ErrorActionPreference = 'Stop' here - with it, PowerShell 5.1
# turns the first stderr line of a native command ("Reading additional
# input from stdin...") into a terminating error before Codex even runs.
$root = Split-Path $PSScriptRoot -Parent

if (-not $CodexExe) {
    $cmd = Get-Command codex -ErrorAction SilentlyContinue
    if ($cmd) {
        $CodexExe = $cmd.Source
    } else {
        $CodexExe = Join-Path $env:LOCALAPPDATA 'Programs\OpenAI\Codex\bin\codex.exe'
    }
}
if (-not (Test-Path $CodexExe)) { throw "codex executable not found: $CodexExe" }

if (-not $OutFile) {
    $OutFile = Join-Path $root "release-notes-$App-$Version.draft.md"
}

$prompt = @"
Use the release-check skill in skills/release-check/SKILL.md for app '$App', version '$Version', change window since '$Since'.
Write the draft assessment to exactly this file: $OutFile
Then reply with the recommendation (GO or NO-GO), the blockers if any, and the draft file path. Draft-first: do not post, tag, or create anything anywhere.
"@

Push-Location $root
try {
    $output = $null | & $CodexExe exec --sandbox workspace-write $prompt 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) { throw "codex exec exited with $LASTEXITCODE" }
    Write-Output $output
} finally {
    Pop-Location
}
Write-Output "Draft (if Codex completed): $OutFile"
