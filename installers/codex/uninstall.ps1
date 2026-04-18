param()

. (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..\\..')).Path 'scripts\\common-host.ps1')

$shitpmRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\\..')).Path
$resolved = & (Join-Path $shitpmRoot 'scripts\resolve-paths.ps1') -HostKind 'codex'
$hostBase = $resolved.Base
$hostBundle = $resolved.Bundle
$legacySkillsDir = Join-Path $hostBase 'skills'

foreach ($skillName in (Get-ShitPmSkillNames -ShitPmRoot $shitpmRoot)) {
    Remove-SafeJunctionOrDir -Path (Join-Path $legacySkillsDir $skillName)
}

foreach ($shared in @('shitpm-commands', 'shitpm-templates', 'shitpm-contracts')) {
    Remove-SafeJunctionOrDir -Path (Join-Path $hostBase $shared)
}

Remove-SafeJunctionOrDir -Path $hostBundle

& (Join-Path $shitpmRoot 'scripts\remove-global-rules.ps1') -HostKind 'codex'

Write-Output 'uninstall:ok'
