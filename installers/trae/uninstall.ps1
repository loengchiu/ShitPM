param()

. (Join-Path (Resolve-Path (Join-Path $PSScriptRoot '..\\..')).Path 'scripts\\common-host.ps1')

$shitpmRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\\..')).Path
$resolved = & (Join-Path $shitpmRoot 'scripts\resolve-paths.ps1') -HostKind 'trae'
$hostBase = $resolved.Base
$skillsDir = $resolved.Skills

function Remove-SafeJunctionOrDir {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $item = Get-Item -LiteralPath $Path -Force
    if ($item.LinkType -eq 'Junction') {
        [System.IO.Directory]::Delete($Path, $false)
    } else {
        Remove-Item -LiteralPath $Path -Force -Recurse
    }
}

foreach ($skillName in (Get-ShitPmSkillNames -ShitPmRoot $shitpmRoot)) {
    Remove-SafeJunctionOrDir -Path (Join-Path $skillsDir $skillName)
}

foreach ($shared in @('shitpm-commands', 'shitpm-templates', 'shitpm-contracts')) {
    Remove-SafeJunctionOrDir -Path (Join-Path $hostBase $shared)
}

& (Join-Path $shitpmRoot 'scripts\remove-global-rules.ps1') -HostKind 'trae'

Write-Output 'uninstall:ok'
