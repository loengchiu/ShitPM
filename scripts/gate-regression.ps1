param()

$ErrorActionPreference = 'Continue'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$scripts = Join-Path $root 'scripts'
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
    for ($i = 0; $i -lt 8; $i++) {
        if (-not (Test-Path -LiteralPath $statusFile)) { break }
        Remove-Item -LiteralPath $statusFile -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 200
    }
}

function Invoke-Gate {
    param([string]$Target)
    & powershell -NoProfile -File "$scripts\stage-gate.ps1" -Target $Target 2>&1 | Out-Host
    return $LASTEXITCODE
}

function Invoke-Write {
    param([string[]]$WriteParameters)
    & powershell -NoProfile -File "$scripts\status-write.ps1" $WriteParameters 2>&1 | Out-Host
    Start-Sleep -Milliseconds 200
    return $LASTEXITCODE
}

Header 'Scenario 1: stable feature_list allows page'
Cleanup

$fakeFL = Join-Path $root 'docs\feature-lists\regression-fl-v1.md'
New-Item -ItemType Directory -Force -Path (Split-Path $fakeFL) | Out-Null
'# Feature List v1' | Set-Content -LiteralPath $fakeFL -Encoding UTF8

$rc = Invoke-Write @('-Stage', 'feat', '-ArtifactField', 'feature_list', '-ArtifactPath', 'docs/feature-lists/regression-fl-v1.md')
if ($rc -ne 0) { Nok "status-write artifact failed (exit $rc)" }

$rc = Invoke-Write @('-BaselineField', 'feature_list', '-BaselinePath', 'docs/feature-lists/regression-fl-v1.md')
if ($rc -ne 0) { Nok "status-write baseline failed (exit $rc)" }

$rc = Invoke-Gate 'page'
if ($rc -eq 0) { Ok 'stage-gate page passed' } else { Nok "stage-gate page failed (exit $rc)" }

Header 'Scenario 2: blockers stop prd'
Cleanup

$fakePS = Join-Path $root 'docs\page-structures\regression-ps-v1.md'
New-Item -ItemType Directory -Force -Path (Split-Path $fakePS) | Out-Null
'# Page Structure v1' | Set-Content -LiteralPath $fakePS -Encoding UTF8

Invoke-Write @('-Stage', 'page', '-ArtifactField', 'feature_list', '-ArtifactPath', 'docs/feature-lists/regression-fl-v1.md') | Out-Null
Invoke-Write @('-BaselineField', 'feature_list', '-BaselinePath', 'docs/feature-lists/regression-fl-v1.md') | Out-Null
Invoke-Write @('-ArtifactField', 'page_structure', '-ArtifactPath', 'docs/page-structures/regression-ps-v1.md') | Out-Null
Invoke-Write @('-BaselineField', 'page_structure', '-BaselinePath', 'docs/page-structures/regression-ps-v1.md') | Out-Null
Invoke-Write @('-AddBlocker', 'backend review pending') | Out-Null

$rc = Invoke-Gate 'prd'
if ($rc -ne 0) { Ok 'stage-gate prd blocked by blocker' } else { Nok 'stage-gate prd should have been blocked' }

Header 'Scenario 3: pending stops mock'
Cleanup

$fakePRD = Join-Path $root 'docs\prd\regression-prd-v1.md'
New-Item -ItemType Directory -Force -Path (Split-Path $fakePRD) | Out-Null
'# PRD v1' | Set-Content -LiteralPath $fakePRD -Encoding UTF8

Invoke-Write @('-Stage', 'prd', '-BaselineField', 'feature_list', '-BaselinePath', 'docs/feature-lists/regression-fl-v1.md') | Out-Null
Invoke-Write @('-BaselineField', 'page_structure', '-BaselinePath', 'docs/page-structures/regression-ps-v1.md') | Out-Null
Invoke-Write @('-ArtifactField', 'prd', '-ArtifactPath', 'docs/prd/regression-prd-v1.md') | Out-Null
Invoke-Write @('-BaselineField', 'prd', '-BaselinePath', 'docs/prd/regression-prd-v1.md') | Out-Null
Invoke-Write @('-AddPending', 'mobile prototype not confirmed') | Out-Null

$rc = Invoke-Gate 'mock'
if ($rc -ne 0) { Ok 'stage-gate mock blocked by pending confirmation' } else { Nok 'stage-gate mock should have been blocked' }

Header 'Scenario 4: invalid baseline path fails and does not write state'
Cleanup

$existsBefore = Test-Path -LiteralPath $statusFile
$rc = Invoke-Write @('-BaselineField', 'prd', '-BaselinePath', 'docs/prd/does-not-exist.md')
$createdAfter = (Test-Path -LiteralPath $statusFile) -and (-not $existsBefore)

if ($rc -ne 0) { Ok 'status-write failed as expected' } else { Nok 'status-write should have failed' }
if (-not $createdAfter) { Ok 'project-status.json not created on failure' } else { Nok 'project-status.json should not be written on failure' }

Write-Host "`n==== Summary ====" -ForegroundColor Cyan
Write-Host "  PASS: $passed" -ForegroundColor Green
Write-Host "  FAIL: $failed" -ForegroundColor $(if ($failed -gt 0) { 'Red' } else { 'Green' })

Cleanup
@($fakeFL, $fakePS, $fakePRD) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Remove-Item -Force

if ($failed -gt 0) { exit 1 }
exit 0
