param()
<#
  ShitPM gate-regression.ps1
  覆盖 4 组场景：
    1. 正常流：写入稳定 feature_list 后，stage-gate -Target pm-ps 通过
    2. 阻塞流：blockers 非空时，stage-gate -Target pm-prd 失败
    3. 待确认流：pending_confirmations 非空时，stage-gate -Target pm-pt 失败
    4. 错误流：baseline 路径不存在时，status-write 直接失败且不产生/不污染 project-status.json
#>

$ErrorActionPreference = 'Continue'   # 子进程非零退出不应终止本脚本

$root       = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$scripts    = Join-Path $root 'scripts'
$statusFile = Join-Path $root 'docs\project-status.json'

$passed = 0
$failed = 0

function Header([string]$title) {
    Write-Host "`n==== $title ====" -ForegroundColor Cyan
}

function Ok([string]$msg) {
    Write-Host "  [PASS] $msg" -ForegroundColor Green
    $script:passed++
}

function Nok([string]$msg) {
    Write-Host "  [FAIL] $msg" -ForegroundColor Red
    $script:failed++
}

function Cleanup {
    # 重试删除，防止 Set-Content 句柄未立即释放导致静默失败
    for ($i = 0; $i -lt 8; $i++) {
        if (-not (Test-Path -LiteralPath $statusFile)) { break }
        Remove-Item -LiteralPath $statusFile -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 200
    }
}

# 子进程 stdout/stderr 直接输出到 host（不进入 pipeline），只返回 exit code
function Invoke-Gate {
    param([string]$Target)
    & powershell -NoProfile -File "$scripts\stage-gate.ps1" -Target $Target 2>&1 | Out-Host
    return $LASTEXITCODE
}

function Invoke-Write {
    param([string[]]$WriteArgs)
    & powershell -NoProfile -File "$scripts\status-write.ps1" @WriteArgs 2>&1 | Out-Host
    Start-Sleep -Milliseconds 200   # 等待 Set-Content 句柄释放
    return $LASTEXITCODE
}

# ---------------------------------------------------------------
# 场景 1：正常流
# ---------------------------------------------------------------
Header "场景 1：正常流 — 写入稳定 feature_list 后 stage-gate pm-ps 通过"
Cleanup

# 创建假产物文件
$fakeFL = Join-Path $root 'docs\feature-lists\regression-fl-v1.md'
New-Item -ItemType Directory -Force -Path (Split-Path $fakeFL) | Out-Null
'# Feature List v1' | Set-Content -LiteralPath $fakeFL -Encoding UTF8

# 写入状态和 baseline
$rc = Invoke-Write @('-Stage', 'pm-fl', '-ArtifactField', 'feature_list', '-ArtifactPath', 'docs/feature-lists/regression-fl-v1.md')
if ($rc -ne 0) { Nok "status-write 写 artifact 失败 (exit $rc)" }

$rc = Invoke-Write @('-BaselineField', 'feature_list', '-BaselinePath', 'docs/feature-lists/regression-fl-v1.md')
if ($rc -ne 0) { Nok "status-write 写 baseline 失败 (exit $rc)" }

# 验证
$rc = Invoke-Gate 'pm-ps'
if ($rc -eq 0) { Ok "stage-gate pm-ps 通过 (exit 0)" }
else { Nok "stage-gate pm-ps 应通过但失败了 (exit $rc)" }

# ---------------------------------------------------------------
# 场景 2：阻塞流
# ---------------------------------------------------------------
Header "场景 2：阻塞流 — blockers 非空时 stage-gate pm-prd 失败"
Cleanup

$fakePR = Join-Path $root 'docs\page-structures\regression-ps-v1.md'
New-Item -ItemType Directory -Force -Path (Split-Path $fakePR) | Out-Null
'# Page Structure v1' | Set-Content -LiteralPath $fakePR -Encoding UTF8

Invoke-Write @('-Stage', 'pm-ps',
    '-ArtifactField', 'feature_list', '-ArtifactPath', 'docs/feature-lists/regression-fl-v1.md') | Out-Null
Invoke-Write @('-BaselineField', 'feature_list', '-BaselinePath', 'docs/feature-lists/regression-fl-v1.md') | Out-Null
Invoke-Write @('-ArtifactField', 'page_structure', '-ArtifactPath', 'docs/page-structures/regression-ps-v1.md') | Out-Null
Invoke-Write @('-BaselineField', 'page_structure', '-BaselinePath', 'docs/page-structures/regression-ps-v1.md') | Out-Null
Invoke-Write @('-AddBlocker', '接口规范未确认，等待后端评审结论') | Out-Null

$rc = Invoke-Gate 'pm-prd'
if ($rc -ne 0) { Ok "stage-gate pm-prd 被 blocker 正确阻止 (exit $rc)" }
else { Nok "stage-gate pm-prd 有 blockers 但未阻止 (exit 0)" }

# ---------------------------------------------------------------
# 场景 3：待确认流
# ---------------------------------------------------------------
Header "场景 3：待确认流 — pending_confirmations 非空时 stage-gate pm-pt 失败"
Cleanup

$fakePRD = Join-Path $root 'docs\prd\regression-prd-v1.md'
New-Item -ItemType Directory -Force -Path (Split-Path $fakePRD) | Out-Null
'# PRD v1' | Set-Content -LiteralPath $fakePRD -Encoding UTF8

Invoke-Write @('-Stage', 'pm-prd',
    '-BaselineField', 'feature_list', '-BaselinePath', 'docs/feature-lists/regression-fl-v1.md') | Out-Null
Invoke-Write @('-BaselineField', 'page_structure', '-BaselinePath', 'docs/page-structures/regression-ps-v1.md') | Out-Null
Invoke-Write @('-ArtifactField', 'prd', '-ArtifactPath', 'docs/prd/regression-prd-v1.md') | Out-Null
Invoke-Write @('-BaselineField', 'prd', '-BaselinePath', 'docs/prd/regression-prd-v1.md') | Out-Null
Invoke-Write @('-AddPending', '需确认：移动端原型是否本期交付') | Out-Null

$rc = Invoke-Gate 'pm-pt'
if ($rc -ne 0) { Ok "stage-gate pm-pt 被 pending_confirmation 正确阻止 (exit $rc)" }
else { Nok "stage-gate pm-pt 有 pending 但未阻止 (exit 0)" }

# ---------------------------------------------------------------
# 场景 4：错误流
# ---------------------------------------------------------------
Header "场景 4：错误流 — baseline 路径不存在时 status-write 失败且不污染状态文件"
Cleanup

$existsBefore = Test-Path -LiteralPath $statusFile

$rc = Invoke-Write @('-BaselineField', 'prd', '-BaselinePath', 'docs/prd/does-not-exist.md')
$createdAfter = (Test-Path -LiteralPath $statusFile) -and (-not $existsBefore)

if ($rc -ne 0) { Ok "status-write 正确以非零退出 (exit $rc)" }
else { Nok "status-write 应报错但返回 exit 0" }

if (-not $createdAfter) { Ok "project-status.json 未被创建/污染" }
else { Nok "project-status.json 不应在校验失败时写入" }

# ---------------------------------------------------------------
# 汇总 + 清理
# ---------------------------------------------------------------
Write-Host "`n==== 回归结果 ====" -ForegroundColor Cyan
Write-Host "  PASS: $passed" -ForegroundColor Green
Write-Host "  FAIL: $failed" -ForegroundColor $(if ($failed -gt 0) { 'Red' } else { 'Green' })

Cleanup
@($fakeFL, $fakePR, $fakePRD) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Remove-Item -Force

if ($failed -gt 0) { exit 1 }
exit 0

# ---------------------------------------------------------------
# 场景 1：正常流
# ---------------------------------------------------------------
Header "场景 1：正常流 — 写入稳定 feature_list 后 stage-gate pm-ps 通过"
Cleanup

# 创建假产物文件
$fakeFL = Join-Path $root 'docs\feature-lists\regression-fl-v1.md'
New-Item -ItemType Directory -Force -Path (Split-Path $fakeFL) | Out-Null
'# Feature List v1' | Set-Content -LiteralPath $fakeFL -Encoding UTF8

# 写入状态和 baseline
$exitCode = Invoke-Write @('-Stage', 'pm-fl', '-ArtifactField', 'feature_list', '-ArtifactPath', 'docs/feature-lists/regression-fl-v1.md')
if ($exitCode -ne 0) { Fail "status-write 写 artifact 失败 (exit $exitCode)" }

$exitCode = Invoke-Write @('-BaselineField', 'feature_list', '-BaselinePath', 'docs/feature-lists/regression-fl-v1.md')
if ($exitCode -ne 0) { Fail "status-write 写 baseline 失败 (exit $exitCode)" ; Cleanup ; break }

# 测试 gate
$exitCode = Invoke-Gate 'pm-ps'
if ($exitCode -eq 0) { Ok "stage-gate pm-ps 通过 (exit 0)" }
else { Fail "stage-gate pm-ps 应通过但失败了 (exit $exitCode)" }

# ---------------------------------------------------------------
# 场景 2：阻塞流
# ---------------------------------------------------------------
Header "场景 2：阻塞流 — blockers 非空时 stage-gate pm-prd 失败"
Cleanup

# 创建所需文件
$fakePR = Join-Path $root 'docs\page-structures\regression-ps-v1.md'
New-Item -ItemType Directory -Force -Path (Split-Path $fakePR) | Out-Null
'# Page Structure v1' | Set-Content -LiteralPath $fakePR -Encoding UTF8

Invoke-Write @('-Stage','pm-ps',
    '-ArtifactField','feature_list', '-ArtifactPath','docs/feature-lists/regression-fl-v1.md') | Out-Null
Invoke-Write @('-BaselineField','feature_list', '-BaselinePath','docs/feature-lists/regression-fl-v1.md') | Out-Null
Invoke-Write @('-ArtifactField','page_structure', '-ArtifactPath','docs/page-structures/regression-ps-v1.md') | Out-Null
Invoke-Write @('-BaselineField','page_structure', '-BaselinePath','docs/page-structures/regression-ps-v1.md') | Out-Null

# 注入阻塞项
Invoke-Write @('-AddBlocker', '接口规范未确认，等待后端评审结论') | Out-Null

$exitCode = Invoke-Gate 'pm-prd'
if ($exitCode -ne 0) { Ok "stage-gate pm-prd 被 blocker 正确阻止 (exit $exitCode)" }
else { Fail "stage-gate pm-prd 有 blockers 但未阻止 (exit 0)" }

# ---------------------------------------------------------------
# 场景 3：待确认流
# ---------------------------------------------------------------
Header "场景 3：待确认流 — pending_confirmations 非空时 stage-gate pm-pt 失败"
Cleanup

# 创建所需文件
$fakePRD = Join-Path $root 'docs\prd\regression-prd-v1.md'
New-Item -ItemType Directory -Force -Path (Split-Path $fakePRD) | Out-Null
'# PRD v1' | Set-Content -LiteralPath $fakePRD -Encoding UTF8

Invoke-Write @('-Stage','pm-prd',
    '-BaselineField','feature_list',   '-BaselinePath','docs/feature-lists/regression-fl-v1.md') | Out-Null
Invoke-Write @('-BaselineField','page_structure', '-BaselinePath','docs/page-structures/regression-ps-v1.md') | Out-Null
Invoke-Write @('-ArtifactField','prd', '-ArtifactPath','docs/prd/regression-prd-v1.md') | Out-Null
Invoke-Write @('-BaselineField','prd', '-BaselinePath','docs/prd/regression-prd-v1.md') | Out-Null

# 注入待确认项
Invoke-Write @('-AddPending', '需确认：移动端原型是否本期交付') | Out-Null

$exitCode = Invoke-Gate 'pm-pt'
if ($exitCode -ne 0) { Ok "stage-gate pm-pt 被 pending_confirmation 正确阻止 (exit $exitCode)" }
else { Fail "stage-gate pm-pt 有 pending 但未阻止 (exit 0)" }

# ---------------------------------------------------------------
# 场景 4：错误流
# ---------------------------------------------------------------
Header "场景 4：错误流 — baseline 路径不存在时 status-write 失败且不污染状态文件"
Cleanup

# 记录当前状态文件是否存在
$existsBefore = Test-Path -LiteralPath $statusFile

$exitCode = Invoke-Write @('-BaselineField','prd', '-BaselinePath','docs/prd/does-not-exist.md')
$statusChanged = (Test-Path -LiteralPath $statusFile) -and (-not $existsBefore)

if ($exitCode -ne 0) { Ok "status-write 正确以非零退出 (exit $exitCode)" }
else { Fail "status-write 应报错但返回 exit 0" }

if (-not $statusChanged) { Ok "project-status.json 未被创建/污染" }
else { Fail "project-status.json 不应在校验失败时写入" }

# ---------------------------------------------------------------
# 汇总
# ---------------------------------------------------------------
Write-Host "`n==== 回归结果 ====" -ForegroundColor Cyan
Write-Host "  PASS: $passed" -ForegroundColor Green
Write-Host "  FAIL: $failed" -ForegroundColor $(if ($failed -gt 0) { 'Red' } else { 'Green' })

# 清理产物
Cleanup
@($fakeFL, $fakePR, $fakePRD) | Where-Object { Test-Path -LiteralPath $_ } | Remove-Item -Force

if ($failed -gt 0) { exit 1 }
exit 0
