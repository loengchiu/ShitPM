param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('pm-go','pm-scope','pm-mm','pm-fl','pm-ps','pm-prd','pm-rv','pm-fix','pm-pt','pm-pa')]
    [string]$Target
)

$ErrorActionPreference = 'Stop'

$root       = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$statusFile = Join-Path $root 'docs\project-status.json'

function Fail([string]$msg) {
    Write-Host "[ShitPM gate] BLOCKED ($Target): $msg" -ForegroundColor Red
    exit 1
}

function Pass([string]$msg) {
    Write-Host "[ShitPM gate] OK ($Target): $msg" -ForegroundColor Green
}

function Assert-FileExists([string]$label, [string]$relPath) {
    if (-not $relPath) {
        Fail "$label 缺少稳定锚点。请先通过 pm-go 确认当前稳定版，或修复当前项目状态后再继续。"
    }
    $full = Join-Path $root ($relPath -replace '/', '\')
    if (-not (Test-Path -LiteralPath $full)) {
        Fail "$label 文件不存在：$relPath"
    }
}

# 无强制前置的阶段：直接放行
$softStages = @('pm-go', 'pm-scope', 'pm-mm', 'pm-fl')
if ($softStages -contains $Target) {
    Pass '无强制文件前置，放行。'
    exit 0
}

# 以下阶段需要 project-status.json 存在
if (-not (Test-Path -LiteralPath $statusFile)) {
    Fail '未发现项目状态文件，请先通过 pm-go 恢复或初始化当前项目状态。'
}

$s = Get-Content -LiteralPath $statusFile -Raw | ConvertFrom-Json

# --- blockers / pending_confirmations 强制门禁 ---
$blockers = @($s.blockers | Where-Object { $_ })
if ($blockers.Count -gt 0) {
    $list = ($blockers | ForEach-Object { "  - $_" }) -join "`n"
    Fail "存在未解决的阻塞项，必须先清除后才能继续：`n$list"
}

$pending = @($s.pending_confirmations | Where-Object { $_ })
if ($pending.Count -gt 0) {
    $list = ($pending | ForEach-Object { "  - $_" }) -join "`n"
    Fail "存在待确认项，必须先确认后才能继续：`n$list"
}

switch ($Target) {

    'pm-ps' {
        Assert-FileExists 'Feature List [stable_baselines]' $s.stable_baselines.feature_list
        Pass 'Feature List 稳定版存在，前置通过。'
    }

    'pm-prd' {
        Assert-FileExists 'Feature List [stable_baselines]'   $s.stable_baselines.feature_list
        Assert-FileExists 'Page Structure [stable_baselines]' $s.stable_baselines.page_structure
        Pass 'Feature List + Page Structure 稳定版均存在，前置通过。'
    }

    'pm-rv' {
        Assert-FileExists 'PRD [latest_artifacts]' $s.latest_artifacts.prd
        Pass 'PRD 最新产物存在，前置通过。'
    }

    'pm-fix' {
        $prdPath = if ($s.latest_artifacts.prd) { $s.latest_artifacts.prd } else { $s.stable_baselines.prd }
        Assert-FileExists 'PRD' $prdPath
        Pass 'PRD 存在，前置通过。'
    }

    'pm-pt' {
        Assert-FileExists 'PRD [stable_baselines]' $s.stable_baselines.prd
        Pass 'PRD 稳定版存在，前置通过。'
    }

    'pm-pa' {
        Assert-FileExists 'PRD [stable_baselines]'       $s.stable_baselines.prd
        Assert-FileExists 'Prototype [stable_baselines]' $s.stable_baselines.prototype
        Pass 'PRD + Prototype 稳定版均存在，前置通过。'
    }
}

exit 0
