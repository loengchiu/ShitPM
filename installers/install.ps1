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
    Write-Warning '未检测到任何已知宿主目录（.copilot / .agents / .cursor / .windsurf / .trae / .trae-cn）。'
    Write-Warning '请先确认宿主 AI 工具已安装，或使用 -Hosts 参数手动指定。'
    exit 1
}

Write-Host "检测到宿主：$($targetHosts -join ', ')" -ForegroundColor Cyan

$results = @()

foreach ($hostKind in $targetHosts) {
    Write-Host "`n--- 安装 $hostKind ---" -ForegroundColor Yellow

    $individualInstaller = Join-Path $shitpmRoot "installers\$hostKind\install.ps1"

    if (Test-Path -LiteralPath $individualInstaller) {
        & $individualInstaller
        $ok = ($LASTEXITCODE -eq 0)
    } else {
        try {
            & (Join-Path $scriptsDir 'write-mappings.ps1') -HostKind $hostKind
            & (Join-Path $scriptsDir 'verify-mappings.ps1') -HostKind $hostKind
            $ok = $true
        } catch {
            Write-Warning "安装 $hostKind 失败: $_"
            $ok = $false
        }
    }

    $results += [pscustomobject]@{
        Host = $hostKind
        Status = if ($ok) { 'ok' } else { 'FAILED' }
    }
}

Write-Host "`n=== 安装结果 ===" -ForegroundColor Cyan
$results | ForEach-Object {
    $color = if ($_.Status -eq 'ok') { 'Green' } else { 'Red' }
    Write-Host ("  {0,-12} {1}" -f $_.Host, $_.Status) -ForegroundColor $color
}

$failed = $results | Where-Object { $_.Status -ne 'ok' }
if ($failed) {
    exit 1
}

exit 0

