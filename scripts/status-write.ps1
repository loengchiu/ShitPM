param(
    # --- 顶层字段 ---
    [string]$Stage            ,   # current_stage
    [string]$LastAction       ,   # last_action
    [string]$NextRecommended  ,   # next_recommended
    [string]$ContextSummary   ,   # context_summary

    # --- latest_artifacts ---
    # 标量字段：mindmap | feature_list | page_structure | prd
    # 数组字段（追加去重）：briefs | prototypes | prototype_annotations
    [string]$ArtifactField    ,
    [string]$ArtifactPath     ,

    # --- stable_baselines ---
    # 字段名：feature_list | page_structure | prd | prototype | visual_baseline
    # 目标文件必须已存在，否则脚本报错退出，不落盘
    [string]$BaselineField    ,
    [string]$BaselinePath     ,

    # --- blockers / pending_confirmations（追加或移除一条） ---
    [string]$AddBlocker       ,
    [string]$ResolveBlocker   ,
    [string]$AddPending       ,
    [string]$ResolvePending
)

$ErrorActionPreference = 'Stop'
$bp = $PSBoundParameters

$root       = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$statusFile = Join-Path $root 'docs\project-status.json'
$docsDir    = Join-Path $root 'docs'

function Ensure-ObjectProperty {
    param(
        [Parameter(Mandatory = $true)]$Object,
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)]$DefaultValue
    )

    if ($null -eq $Object.PSObject.Properties[$Name]) {
        $Object | Add-Member -NotePropertyName $Name -NotePropertyValue $DefaultValue
    }
}

function Normalize-Status {
    param([Parameter(Mandatory = $true)]$Status)

    Ensure-ObjectProperty -Object $Status -Name 'current_stage' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status -Name 'last_action' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status -Name 'next_recommended' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status -Name 'context_summary' -DefaultValue ''

    if ($null -eq $Status.PSObject.Properties['stable_baselines']) {
        $Status | Add-Member -NotePropertyName 'stable_baselines' -NotePropertyValue ([PSCustomObject]@{})
    }
    if ($null -eq $Status.PSObject.Properties['scope_decomposition']) {
        $Status | Add-Member -NotePropertyName 'scope_decomposition' -NotePropertyValue ([PSCustomObject]@{})
    }
    if ($null -eq $Status.PSObject.Properties['prd_partition']) {
        $Status | Add-Member -NotePropertyName 'prd_partition' -NotePropertyValue ([PSCustomObject]@{})
    }
    if ($null -eq $Status.PSObject.Properties['latest_artifacts']) {
        $Status | Add-Member -NotePropertyName 'latest_artifacts' -NotePropertyValue ([PSCustomObject]@{})
    }
    Ensure-ObjectProperty -Object $Status -Name 'blockers' -DefaultValue @()
    Ensure-ObjectProperty -Object $Status -Name 'pending_confirmations' -DefaultValue @()

    Ensure-ObjectProperty -Object $Status.stable_baselines -Name 'feature_list' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.stable_baselines -Name 'page_structure' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.stable_baselines -Name 'prd' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.stable_baselines -Name 'prototype' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.stable_baselines -Name 'visual_baseline' -DefaultValue ''

    Ensure-ObjectProperty -Object $Status.scope_decomposition -Name 'required' -DefaultValue $false
    Ensure-ObjectProperty -Object $Status.scope_decomposition -Name 'reason' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.scope_decomposition -Name 'subprojects' -DefaultValue @()

    Ensure-ObjectProperty -Object $Status.prd_partition -Name 'required' -DefaultValue $false
    Ensure-ObjectProperty -Object $Status.prd_partition -Name 'reason' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.prd_partition -Name 'units' -DefaultValue @()

    Ensure-ObjectProperty -Object $Status.latest_artifacts -Name 'briefs' -DefaultValue @()
    Ensure-ObjectProperty -Object $Status.latest_artifacts -Name 'mindmap' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.latest_artifacts -Name 'feature_list' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.latest_artifacts -Name 'page_structure' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.latest_artifacts -Name 'prd' -DefaultValue ''
    Ensure-ObjectProperty -Object $Status.latest_artifacts -Name 'prototypes' -DefaultValue @()
    Ensure-ObjectProperty -Object $Status.latest_artifacts -Name 'prototype_annotations' -DefaultValue @()

    $Status.blockers = @($Status.blockers)
    $Status.pending_confirmations = @($Status.pending_confirmations)
    $Status.latest_artifacts.briefs = @($Status.latest_artifacts.briefs)
    $Status.latest_artifacts.prototypes = @($Status.latest_artifacts.prototypes)
    $Status.latest_artifacts.prototype_annotations = @($Status.latest_artifacts.prototype_annotations)

    return $Status
}

# ----------------------------------------------------------------
# 前置校验：baseline 文件必须存在，否则直接失败，不修改状态文件
# ----------------------------------------------------------------
if ($bp.ContainsKey('BaselineField') -and $bp.ContainsKey('BaselinePath')) {
    if (-not $BaselinePath) {
        Write-Error "[ShitPM] -BaselinePath 不能为空字符串。字段：stable_baselines.$BaselineField"
        exit 1
    }
    $baselineFull = Join-Path $root ($BaselinePath -replace '/', '\')
    if (-not (Test-Path -LiteralPath $baselineFull)) {
        Write-Error "[ShitPM] stable_baselines.$BaselineField 指向的文件不存在：$BaselinePath`n请确认文件已生成后再锁定为稳定版。"
        exit 1
    }
}

# ----------------------------------------------------------------
# 确保 docs/ 目录存在
# ----------------------------------------------------------------
if (-not (Test-Path -LiteralPath $docsDir)) {
    New-Item -ItemType Directory -Path $docsDir | Out-Null
}

# 数组类型的 latest_artifacts 字段（写入时追加而非覆盖）
$arrayFields = @('briefs', 'prototypes', 'prototype_annotations')

# ----------------------------------------------------------------
# 加载或初始化空状态
# ----------------------------------------------------------------
if (Test-Path -LiteralPath $statusFile) {
    $status = Get-Content -LiteralPath $statusFile -Raw | ConvertFrom-Json
} else {
    $status = [PSCustomObject]@{
        current_stage     = ''
        last_action       = ''
        next_recommended  = ''
        context_summary   = ''
        stable_baselines  = [PSCustomObject]@{
            feature_list    = ''
            page_structure  = ''
            prd             = ''
            prototype       = ''
            visual_baseline = ''
        }
        scope_decomposition = [PSCustomObject]@{
            required    = $false
            reason      = ''
            subprojects = @()
        }
        prd_partition = [PSCustomObject]@{
            required = $false
            reason   = ''
            units    = @()
        }
        latest_artifacts = [PSCustomObject]@{
            briefs                = @()
            mindmap               = ''
            feature_list          = ''
            page_structure        = ''
            prd                   = ''
            prototypes            = @()
            prototype_annotations = @()
        }
        blockers              = @()
        pending_confirmations = @()
    }
}

$status = Normalize-Status -Status $status

# ----------------------------------------------------------------
# 应用 patch：只更新 PSBoundParameters 中明确传入的参数
# ----------------------------------------------------------------
if ($bp.ContainsKey('Stage'))           { $status.current_stage    = $Stage }
if ($bp.ContainsKey('LastAction'))      { $status.last_action      = $LastAction }
if ($bp.ContainsKey('NextRecommended')) { $status.next_recommended = $NextRecommended }
if ($bp.ContainsKey('ContextSummary'))  { $status.context_summary  = $ContextSummary }

if ($bp.ContainsKey('ArtifactField')) {
    if (-not $bp.ContainsKey('ArtifactPath')) {
        # 仅传 ArtifactField 而不传 ArtifactPath：清空标量字段
        if ($arrayFields -notcontains $ArtifactField) {
            $status.latest_artifacts.$ArtifactField = ''
        }
    } else {
        if ($arrayFields -contains $ArtifactField) {
            $current = @($status.latest_artifacts.$ArtifactField)
            if ($current -notcontains $ArtifactPath) {
                $status.latest_artifacts.$ArtifactField = $current + $ArtifactPath
            }
        } else {
            $status.latest_artifacts.$ArtifactField = $ArtifactPath
        }
    }
}

if ($bp.ContainsKey('BaselineField') -and $bp.ContainsKey('BaselinePath')) {
    # 已在前置校验中确认文件存在，直接写入
    $status.stable_baselines.$BaselineField = $BaselinePath
}

if ($bp.ContainsKey('AddBlocker'))     { $status.blockers              = @($status.blockers)              + $AddBlocker }
if ($bp.ContainsKey('ResolveBlocker')) { $status.blockers              = @($status.blockers              | Where-Object { $_ -ne $ResolveBlocker }) }
if ($bp.ContainsKey('AddPending'))     { $status.pending_confirmations = @($status.pending_confirmations) + $AddPending }
if ($bp.ContainsKey('ResolvePending')) { $status.pending_confirmations = @($status.pending_confirmations | Where-Object { $_ -ne $ResolvePending }) }

# ----------------------------------------------------------------
# 保存
# ----------------------------------------------------------------
$status | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $statusFile -Encoding UTF8

Write-Host "[ShitPM] project-status.json 已更新。stage=$($status.current_stage)" -ForegroundColor Green

