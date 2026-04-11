param(
    # 可选：显式指定宿主，不指定则自动探测
    [string[]]$Hosts
)

$ErrorActionPreference = 'Stop'
$shitpmRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$scriptsDir = Join-Path $shitpmRoot 'scripts'

if ($Hosts -and $Hosts.Count -gt 0) {
    $targetHosts = $Hosts
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
        # 通用卸载：移除 skills junction 和共享目录
        . (Join-Path $scriptsDir 'common-host.ps1')
        $resolved = & (Join-Path $scriptsDir 'resolve-paths.ps1') -HostKind $hostKind
        $hostBase  = $resolved.Base
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

        $ok = $true
    }

    $results += [pscustomobject]@{
        Host   = $hostKind
        Status = if ($ok) { 'ok' } else { 'FAILED' }
    }
}

Write-Host "`n=== 卸载结果 ===" -ForegroundColor Cyan
$results | ForEach-Object {
    $color = if ($_.Status -eq 'ok') { 'Green' } else { 'Red' }
    Write-Host ("  {0,-12} {1}" -f $_.Host, $_.Status) -ForegroundColor $color
}

$failed = $results | Where-Object { $_.Status -ne 'ok' }
if ($failed) { exit 1 }
exit 0
