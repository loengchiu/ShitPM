param(
    # 可选：只输出某个顶层字段，如 current_stage / stable_baselines / latest_artifacts
    [string]$Field = ''
)

$ErrorActionPreference = 'Stop'

$root       = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$statusFile = Join-Path $root 'docs\project-status.json'

if (-not (Test-Path -LiteralPath $statusFile)) {
    Write-Host '[ShitPM] project-status.json 不存在，视为新项目。' -ForegroundColor Yellow
    exit 0
}

$json = Get-Content -LiteralPath $statusFile -Raw | ConvertFrom-Json

if ($Field) {
    $val = $json.$Field
    if ($null -eq $val) {
        Write-Warning "字段 '$Field' 不存在"
        exit 1
    }
    Write-Output ($val | ConvertTo-Json -Depth 10)
} else {
    Write-Output ($json | ConvertTo-Json -Depth 10)
}
