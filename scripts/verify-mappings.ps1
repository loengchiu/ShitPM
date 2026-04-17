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

$requiredSkills = @('scope', 'sum', 'mind', 'feat', 'page', 'prd', 'rev', 'fix', 'mock', 'note')
$requiredCommands = @('start.md', 'sum.md', 'mind.md', 'feat.md', 'page.md', 'prd.md', 'rev.md', 'fix.md', 'mock.md', 'note.md')
$requiredTemplates = @('project-brief-lite.md', 'mindmap-spec.md', 'feature-list.md', 'page-structure.md', 'prd.md', 'review-checklist.md', 'fix-record.md', 'prototype-visual-baseline.md', 'prototype-annotation.md')
$requiredContracts = @('workflow-state.md', 'done-criteria.md', 'stage-gates.md', 'error-handling.md')
$missing = @()

if (-not (Test-Path -LiteralPath $skillsDir)) {
    $missing += 'skills'
} else {
    foreach ($skill in $requiredSkills) {
        if (-not (Test-Path -LiteralPath (Join-Path $skillsDir $skill))) {
            $missing += "skill:$skill"
        }
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

if (Test-Path -LiteralPath $commandsDir) {
    foreach ($command in $requiredCommands) {
        if (-not (Test-Path -LiteralPath (Join-Path $commandsDir $command))) {
            $missing += "command:$command"
        }
    }
}

if (Test-Path -LiteralPath $templatesDir) {
    foreach ($template in $requiredTemplates) {
        if (-not (Test-Path -LiteralPath (Join-Path $templatesDir $template))) {
            $missing += "template:$template"
        }
    }
}

if (Test-Path -LiteralPath $contractsDir) {
    foreach ($contract in $requiredContracts) {
        if (-not (Test-Path -LiteralPath (Join-Path $contractsDir $contract))) {
            $missing += "contract:$contract"
        }
    }
}

if ($missing.Count -gt 0) {
    Write-Error ("verify failed: " + ($missing -join ', '))
    exit 1
}

Write-Output 'verify:ok'

