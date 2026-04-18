param(
    [Parameter(Mandatory = $true)][ValidateSet('copilot', 'codex', 'cursor', 'windsurf', 'trae', 'trae-cn', 'antigravity')][string]$HostKind
)

. (Join-Path $PSScriptRoot 'common-host.ps1')

$resolved = & (Join-Path $PSScriptRoot 'resolve-paths.ps1') -HostKind $HostKind

$hostBase = $resolved.Base
$hostSkills = $resolved.Skills
$hostCommands = $resolved.Commands
$hostTemplates = $resolved.Templates
$hostContracts = $resolved.Contracts

$shitpmRoot = Get-ShitPmRoot
$sourceSkillsDir = Join-Path $shitpmRoot 'skills'
$sourceCommands = Join-Path $shitpmRoot 'commands'
$sourceTemplates = Join-Path $shitpmRoot 'templates'
$sourceContracts = Join-Path $shitpmRoot 'contracts'

if (-not (Test-Path -LiteralPath $hostSkills)) {
    New-Item -ItemType Directory -Force -Path $hostSkills | Out-Null
}

$backupRoot = New-BackupRoot -HostBase $hostBase

$legacySkillNames = @(
    'pm-discovery',
    'pm-feature-list',
    'pm-followup-interview',
    'pm-mindmap',
    'pm-orchestrator',
    'notege-structure',
    'pm-prototype',
    'pm-prototype-annotation',
    'pm-review',
    'pm-wiki-sync'
)

foreach ($legacySkill in $legacySkillNames) {
    $legacyPath = Join-Path $hostSkills $legacySkill
    if (Test-Path -LiteralPath $legacyPath) {
        Backup-ExistingItem -Path $legacyPath -BackupRoot $backupRoot
    }
}

foreach ($skillName in (Get-ShitPmSkillNames -ShitPmRoot $shitpmRoot)) {
    $source = Join-Path $sourceSkillsDir $skillName
    $dest = Join-Path $hostSkills $skillName
    Ensure-Junction -LinkPath $dest -TargetPath $source -BackupRoot $backupRoot
}

Ensure-Junction -LinkPath $hostCommands -TargetPath $sourceCommands -BackupRoot $backupRoot
Ensure-Junction -LinkPath $hostTemplates -TargetPath $sourceTemplates -BackupRoot $backupRoot
Ensure-Junction -LinkPath $hostContracts -TargetPath $sourceContracts -BackupRoot $backupRoot

