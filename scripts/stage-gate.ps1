param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('pm-go','pm-scope','pm-analysis','pm-mm','pm-fl','pm-ps','pm-prd','pm-rv','pm-fix','pm-pt','pm-pa')]
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
$softStages = @('pm-go', 'pm-scope', 'pm-analysis', 'pm-mm', 'pm-fl')
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
        $hasMindmap = [bool]$s.latest_artifacts.mindmap
        $hasFeatureList = [bool]($s.latest_artifacts.feature_list -or $s.stable_baselines.feature_list)
        $hasPageStructure = [bool]($s.latest_artifacts.page_structure -or $s.stable_baselines.page_structure)
        $hasPrd = [bool]($s.latest_artifacts.prd -or $s.stable_baselines.prd)

        if (-not ($hasMindmap -or $hasFeatureList -or $hasPageStructure -or $hasPrd)) {
            Fail '未发现可评审的 Mindmap / Feature List / Page Structure / PRD，请先生成至少一个评审对象，或显式指定当前评审路径。'
        }

        if ($hasMindmap) {
            Assert-FileExists 'Mindmap [latest_artifacts]' $s.latest_artifacts.mindmap
        }
        if ($s.stable_baselines.feature_list) {
            Assert-FileExists 'Feature List [stable_baselines]' $s.stable_baselines.feature_list
        } elseif ($s.latest_artifacts.feature_list) {
            Assert-FileExists 'Feature List [latest_artifacts]' $s.latest_artifacts.feature_list
        }
        if ($s.stable_baselines.page_structure) {
            Assert-FileExists 'Page Structure [stable_baselines]' $s.stable_baselines.page_structure
        } elseif ($s.latest_artifacts.page_structure) {
            Assert-FileExists 'Page Structure [latest_artifacts]' $s.latest_artifacts.page_structure
        }
        if ($s.latest_artifacts.prd) {
            Assert-FileExists 'PRD [latest_artifacts]' $s.latest_artifacts.prd
        } elseif ($s.stable_baselines.prd) {
            Assert-FileExists 'PRD [stable_baselines]' $s.stable_baselines.prd
        }

        Pass '已发现至少一个可评审对象，前置通过。'
    }

    'pm-fix' {
        $hasMindmap = [bool]$s.latest_artifacts.mindmap
        $hasFeatureList = [bool]($s.latest_artifacts.feature_list -or $s.stable_baselines.feature_list)
        $hasPageStructure = [bool]($s.latest_artifacts.page_structure -or $s.stable_baselines.page_structure)
        $hasPrd = [bool]($s.latest_artifacts.prd -or $s.stable_baselines.prd)

        if (-not ($hasMindmap -or $hasFeatureList -or $hasPageStructure -or $hasPrd)) {
            Fail '未发现可修正的 Mindmap / Feature List / Page Structure / PRD，请先生成至少一个可判断的当前产物，或显式指定当前变更路径。'
        }

        if ($hasMindmap) {
            Assert-FileExists 'Mindmap [latest_artifacts]' $s.latest_artifacts.mindmap
        }
        if ($s.stable_baselines.feature_list) {
            Assert-FileExists 'Feature List [stable_baselines]' $s.stable_baselines.feature_list
        } elseif ($s.latest_artifacts.feature_list) {
            Assert-FileExists 'Feature List [latest_artifacts]' $s.latest_artifacts.feature_list
        }
        if ($s.stable_baselines.page_structure) {
            Assert-FileExists 'Page Structure [stable_baselines]' $s.stable_baselines.page_structure
        } elseif ($s.latest_artifacts.page_structure) {
            Assert-FileExists 'Page Structure [latest_artifacts]' $s.latest_artifacts.page_structure
        }
        if ($s.latest_artifacts.prd) {
            Assert-FileExists 'PRD [latest_artifacts]' $s.latest_artifacts.prd
        } elseif ($s.stable_baselines.prd) {
            Assert-FileExists 'PRD [stable_baselines]' $s.stable_baselines.prd
        }

        Pass '已发现至少一个可修正对象，前置通过。'
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
