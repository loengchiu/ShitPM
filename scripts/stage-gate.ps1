param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('scope','sum','mind','feat','page','prd','rev','fix','mock','note')]
    [string]$Target
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
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
        Fail "$label 缺少稳定锚点。请先确认当前稳定版本，或修复项目状态。"
    }
    $full = Join-Path $root ($relPath -replace '/', '\')
    if (-not (Test-Path -LiteralPath $full)) {
        Fail "$label 文件不存在：$relPath"
    }
}

$softStages = @('scope', 'sum', 'mind', 'feat')
if ($softStages -contains $Target) {
    Pass '当前为软阶段，无需检查文件前置条件'
    exit 0
}

if (-not (Test-Path -LiteralPath $statusFile)) {
    Fail '未找到 docs/project-status.json。请先执行 /start 初始化当前项目。'
}

$s = Get-Content -LiteralPath $statusFile -Raw | ConvertFrom-Json

$blockers = @($s.blockers | Where-Object { $_ })
if ($blockers.Count -gt 0) {
    $list = ($blockers | ForEach-Object { "  - $_" }) -join "`n"
    Fail "存在未解决阻塞项：`n$list"
}

$pending = @($s.pending_confirmations | Where-Object { $_ })
if ($pending.Count -gt 0) {
    $list = ($pending | ForEach-Object { "  - $_" }) -join "`n"
    Fail "存在待确认事项：`n$list"
}

switch ($Target) {
    'page' {
        Assert-FileExists 'Feature List [stable_baselines]' $s.stable_baselines.feature_list
        Pass '功能清单稳定锚点存在'
    }

    'prd' {
        Assert-FileExists 'Feature List [stable_baselines]' $s.stable_baselines.feature_list
        Assert-FileExists 'Page Structure [stable_baselines]' $s.stable_baselines.page_structure
        Pass '功能清单和页面结构稳定锚点存在'
    }

    'rev' {
        $hasMindmap = [bool]$s.latest_artifacts.mindmap
        $hasFeatureList = [bool]($s.latest_artifacts.feature_list -or $s.stable_baselines.feature_list)
        $hasPageStructure = [bool]($s.latest_artifacts.page_structure -or $s.stable_baselines.page_structure)
        $hasPrd = [bool]($s.latest_artifacts.prd -or $s.stable_baselines.prd)

        if (-not ($hasMindmap -or $hasFeatureList -or $hasPageStructure -or $hasPrd)) {
            Fail '未找到可评审对象。请先生成思维导图、功能清单、页面结构或 PRD 中的至少一个。'
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

        Pass '已找到至少一个可评审对象'
    }

    'fix' {
        $hasMindmap = [bool]$s.latest_artifacts.mindmap
        $hasFeatureList = [bool]($s.latest_artifacts.feature_list -or $s.stable_baselines.feature_list)
        $hasPageStructure = [bool]($s.latest_artifacts.page_structure -or $s.stable_baselines.page_structure)
        $hasPrd = [bool]($s.latest_artifacts.prd -or $s.stable_baselines.prd)

        if (-not ($hasMindmap -or $hasFeatureList -or $hasPageStructure -or $hasPrd)) {
            Fail '未找到可修复对象。请先生成思维导图、功能清单、页面结构或 PRD 中的至少一个。'
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

        Pass '已找到至少一个可修复对象'
    }

    'mock' {
        Assert-FileExists 'PRD [stable_baselines]' $s.stable_baselines.prd
        Pass 'PRD 稳定锚点存在'
    }

    'note' {
        Assert-FileExists 'PRD [stable_baselines]' $s.stable_baselines.prd
        Assert-FileExists 'Prototype [stable_baselines]' $s.stable_baselines.prototype
        Pass 'PRD 和原型稳定锚点存在'
    }
}

exit 0
