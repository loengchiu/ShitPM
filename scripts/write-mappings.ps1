param(
    [Parameter(Mandatory = $true)][ValidateSet('copilot', 'codex', 'cursor', 'windsurf', 'trae', 'trae-cn', 'antigravity')][string]$HostKind
)

. (Join-Path $PSScriptRoot 'common-host.ps1')

$resolved = & (Join-Path $PSScriptRoot 'resolve-paths.ps1') -HostKind $HostKind

$hostBase = $resolved.Base
$hostBundle = $resolved.Bundle
$legacyHostSkills = Join-Path $hostBase 'skills'

$shitpmRoot = Get-ShitPmRoot

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
    $legacyPath = Join-Path $legacyHostSkills $legacySkill
    if (Test-Path -LiteralPath $legacyPath) {
        Backup-ExistingItem -Path $legacyPath -BackupRoot $backupRoot
    }
}

foreach ($skillName in (Get-ShitPmSkillNames -ShitPmRoot $shitpmRoot)) {
    $legacyPath = Join-Path $legacyHostSkills $skillName
    if (Test-Path -LiteralPath $legacyPath) {
        Backup-ExistingItem -Path $legacyPath -BackupRoot $backupRoot
    }
}

foreach ($legacyShared in @('shitpm-commands', 'shitpm-templates', 'shitpm-contracts')) {
    $legacyPath = Join-Path $hostBase $legacyShared
    if (Test-Path -LiteralPath $legacyPath) {
        Backup-ExistingItem -Path $legacyPath -BackupRoot $backupRoot
    }
}

Ensure-Junction -LinkPath $hostBundle -TargetPath $shitpmRoot -BackupRoot $backupRoot

