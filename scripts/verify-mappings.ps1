param(
    [Parameter(Mandatory = $true)][ValidateSet('copilot', 'codex', 'cursor', 'windsurf', 'trae', 'antigravity')][string]$HostKind
)

. (Join-Path $PSScriptRoot 'common-host.ps1')

$resolved = & (Join-Path $PSScriptRoot 'resolve-paths.ps1') -HostKind $HostKind
$base = $resolved.Base
$skillsDir = $resolved.Skills
$commandsDir = $resolved.Commands
$templatesDir = $resolved.Templates
$contractsDir = $resolved.Contracts

$requiredSkills = @('pm-go', 'pm-mm', 'pm-fl', 'pm-ps', 'pm-prd', 'pm-rv', 'pm-fix', 'pm-pt', 'pm-pa')
$missing = @()

foreach ($skill in $requiredSkills) {
    if (-not (Test-Path -LiteralPath (Join-Path $skillsDir $skill))) {
        $missing += "skill:$skill"
    }
}

if (-not (Test-Path -LiteralPath $templatesDir)) {
    $missing += 'templates'
}

if (-not (Test-Path -LiteralPath $contractsDir)) {
    $missing += 'contracts'
}

if (-not (Test-Path -LiteralPath $commandsDir)) {
    $missing += 'commands'
}

if ($missing.Count -gt 0) {
    Write-Error ("verify failed: " + ($missing -join ', '))
    exit 1
}

Write-Output 'verify:ok'
