param(
    [string[]]$Hosts
)

$ErrorActionPreference = 'Stop'
$shitpmRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$scriptsDir = Join-Path $shitpmRoot 'scripts'

if ($Hosts -and $Hosts.Count -gt 0) {
    $targetHosts = @()
    foreach ($value in $Hosts) {
        foreach ($part in ($value -split ',')) {
            $trimmed = $part.Trim()
            if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
                $targetHosts += $trimmed
            }
        }
    }
} else {
    $targetHosts = & (Join-Path $scriptsDir 'detect-hosts.ps1')
}

if ($targetHosts.Count -eq 0) {
    Write-Warning '未检测到任何已知宿主目录，跳过卸载。'
    exit 0
}

Write-Host "检测到宿主：$($targetHosts -join ', ')" -ForegroundColor Cyan

$results = @()

foreach ($hostKind in $targetHosts) {
    Write-Host "`n--- 卸载 $hostKind ---" -ForegroundColor Yellow

    $individualUninstaller = Join-Path $shitpmRoot "installers\$hostKind\uninstall.ps1"

    if (Test-Path -LiteralPath $individualUninstaller) {
        & $individualUninstaller
        $ok = ($LASTEXITCODE -eq 0)
    } else {
        . (Join-Path $scriptsDir 'common-host.ps1')
        $resolved = & (Join-Path $scriptsDir 'resolve-paths.ps1') -HostKind $hostKind
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
        $ok = $true
    }

    $results += [pscustomobject]@{
        Host = $hostKind
        Status = if ($ok) { 'ok' } else { 'FAILED' }
    }
}

Write-Host "`n=== 卸载结果 ===" -ForegroundColor Cyan
$results | ForEach-Object {
    $color = if ($_.Status -eq 'ok') { 'Green' } else { 'Red' }
    Write-Host ("  {0,-12} {1}" -f $_.Host, $_.Status) -ForegroundColor $color
}

$failed = $results | Where-Object { $_.Status -ne 'ok' }
if ($failed) {
    exit 1
}

exit 0

