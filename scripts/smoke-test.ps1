param()

$ErrorActionPreference = 'Stop'

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

$requiredFiles = @(
    'README.md',
    'CHANGELOG.md',
    'VERSION',
    'docs\whitepaper.md',
    'docs\install.md',
    'docs\usage.md',
    'docs\troubleshooting.md',
    'docs\host-matrix.md',
    'docs\real-project-test.md',
    'docs\release-checklist.md',
    'skills\pm-go\SKILL.md',
    'skills\pm-scope\SKILL.md',
    'skills\pm-analysis\SKILL.md',
    'skills\pm-mm\SKILL.md',
    'skills\pm-fl\SKILL.md',
    'skills\pm-ps\SKILL.md',
    'skills\pm-prd\SKILL.md',
    'skills\pm-rv\SKILL.md',
    'skills\pm-fix\SKILL.md',
    'skills\pm-pt\SKILL.md',
    'skills\pm-pa\SKILL.md',
    'commands\pm-go.md',
    'commands\pm-mm.md',
    'commands\pm-fl.md',
    'commands\pm-ps.md',
    'commands\pm-prd.md',
    'commands\pm-rv.md',
    'commands\pm-fix.md',
    'commands\pm-pt.md',
    'commands\pm-pa.md',
    'templates\feature-list.md',
    'templates\page-structure.md',
    'templates\prd.md',
    'templates\review-checklist.md',
    'templates\fix-record.md',
    'templates\project-brief-lite.md',
    'templates\prototype-visual-baseline.md',
    'templates\prototype-annotation.md',
    'templates\copilot-instructions.md',
    'contracts\artifact-schema.md',
    'contracts\workflow-state.md',
    'contracts\done-criteria.md',
    'contracts\stage-gates.md',

    'scripts\status-read.ps1',
    'scripts\status-write.ps1',
    'scripts\stage-gate.ps1',
    'scripts\gate-regression.ps1',
    'scripts\detect-hosts.ps1',
    'installers\install.ps1',
    'installers\uninstall.ps1',
    'installers\copilot\install.ps1',
    'installers\copilot\verify.ps1',
    'installers\copilot\uninstall.ps1',
    'installers\codex\install.ps1',
    'installers\codex\verify.ps1',
    'installers\codex\uninstall.ps1'
)

$missing = @()
foreach ($relativePath in $requiredFiles) {
    $fullPath = Join-Path $projectRoot $relativePath
    if (-not (Test-Path -LiteralPath $fullPath)) {
        $missing += $relativePath
    }
}

if ($missing.Count -gt 0) {
    Write-Error ("missing files: " + ($missing -join ', '))
    exit 1
}

$skillDirs = Get-ChildItem -LiteralPath (Join-Path $projectRoot 'skills') -Directory | Select-Object -ExpandProperty Name | Sort-Object
$commandFiles = Get-ChildItem -LiteralPath (Join-Path $projectRoot 'commands') -File | ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) } | Sort-Object

$publicSkills = @('pm-go', 'pm-mm', 'pm-fl', 'pm-ps', 'pm-prd', 'pm-rv', 'pm-fix', 'pm-pt', 'pm-pa')

$missingCommands = @()
foreach ($skill in $publicSkills) {
    if ($commandFiles -notcontains $skill) {
        $missingCommands += $skill
    }
}

$extraCommands = @()
foreach ($command in $commandFiles) {
    if ($publicSkills -notcontains $command) {
        $extraCommands += $command
    }
}

if ($missingCommands.Count -gt 0) {
    Write-Error ("commands missing for skills: " + ($missingCommands -join ', '))
    exit 1
}

if ($extraCommands.Count -gt 0) {
    Write-Error ("commands without skills: " + ($extraCommands -join ', '))
    exit 1
}

$result = [pscustomobject]@{
    status = 'ok'
    skills = $publicSkills
    commands = $commandFiles
}

$result | ConvertTo-Json -Depth 3
