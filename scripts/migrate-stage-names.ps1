param(
    [string]$StatusPath = ''
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
if (-not $StatusPath) {
    $StatusPath = Join-Path $root 'docs\\project-status.json'
}

if (-not (Test-Path -LiteralPath $StatusPath)) {
    Write-Error "未找到状态文件：$StatusPath"
    exit 1
}

$map = @{
    'pm-scope'    = 'scope'
    'pm-analysis' = 'sum'
    'pm-mm'       = 'mind'
    'pm-fl'       = 'feat'
    'pm-ps'       = 'page'
    'pm-prd'      = 'prd'
    'pm-rv'       = 'rev'
    'pm-fix'      = 'fix'
    'pm-pt'       = 'mock'
    'pm-pa'       = 'note'
}

$status = Get-Content -LiteralPath $StatusPath -Raw | ConvertFrom-Json

if ($status.current_stage -and $map.ContainsKey([string]$status.current_stage)) {
    $status.current_stage = $map[[string]$status.current_stage]
}

if ($status.next_recommended) {
    foreach ($old in $map.Keys) {
        $status.next_recommended = [string]$status.next_recommended -replace [regex]::Escape($old), $map[$old]
    }
}

$status | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $StatusPath -Encoding UTF8
Write-Host "[ShitPM] 已迁移阶段名：$StatusPath" -ForegroundColor Green
