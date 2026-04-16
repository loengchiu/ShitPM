param(
    [ValidateSet('copilot', 'codex')][string]$HostKind = 'copilot'
)

. (Join-Path $PSScriptRoot 'common-host.ps1')
$resolved = & (Join-Path $PSScriptRoot 'resolve-paths.ps1') -HostKind $HostKind

$base     = $resolved.Base
$skills   = $resolved.Skills
$root     = Get-ShitPmRoot

$allOk = $true

Write-Host "`n=== Skills (Junctions) ===" -ForegroundColor Cyan
foreach ($name in (Get-ShitPmSkillNames -ShitPmRoot $root)) {
    $path = Join-Path $skills $name
    $md   = Join-Path $path 'SKILL.md'
    $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
    $lt   = if ($item) { $item.LinkType } else { 'MISSING' }
    $sm   = if (Test-Path -LiteralPath $md) { 'ok' } else { 'MISSING' }
    $color = if ($lt -eq 'Junction' -and $sm -eq 'ok') { 'Green' } else { 'Red'; $allOk = $false }
    Write-Host ("  {0,-20} junction={1,-10} SKILL.md={2}" -f $name, $lt, $sm) -ForegroundColor $color
}

Write-Host "`n=== Shared Directories ===" -ForegroundColor Cyan
@('Commands','Templates','Contracts') | ForEach-Object {
    $dir  = $resolved.$_
    $item = Get-Item -LiteralPath $dir -Force -ErrorAction SilentlyContinue
    $lt   = if ($item) { $item.LinkType } else { 'MISSING' }
    $ex   = if (Test-Path -LiteralPath $dir) { 'ok' } else { 'MISSING' }
    $color = if ($lt -eq 'Junction' -and $ex -eq 'ok') { 'Green' } else { 'Red'; $allOk = $false }
    Write-Host ("  {0,-25} junction={1,-10} exists={2}" -f $dir, $lt, $ex) -ForegroundColor $color
}

Write-Host "`n=== Templates ===" -ForegroundColor Cyan
$templateNames = @(
    'feature-list.md', 'page-structure.md', 'prd.md',
    'project-brief-lite.md', 'review-checklist.md',
    'prototype-visual-baseline.md', 'prototype-annotation.md'
)
foreach ($t in $templateNames) {
    $path   = Join-Path $root "templates\$t"
    $ex     = Test-Path -LiteralPath $path
    $status = if ($ex) { 'ok' } else { 'MISSING' }
    $color  = if ($ex) { 'Green' } else { $allOk = $false; 'Red' }
    Write-Host ("  {0,-40} {1}" -f $t, $status) -ForegroundColor $color
}

Write-Host "`n=== Contracts ===" -ForegroundColor Cyan
$contractNames = @(
    'artifact-schema.md', 'workflow-state.md', 'done-criteria.md',
    'stage-gates.md', 'error-handling.md', 'directory-conventions.md',
    'host-contract.md'
)
foreach ($c in $contractNames) {
    $path   = Join-Path $root "contracts\$c"
    $ex     = Test-Path -LiteralPath $path
    $status = if ($ex) { 'ok' } else { 'MISSING' }
    $color  = if ($ex) { 'Green' } else { $allOk = $false; 'Red' }
    Write-Host ("  {0,-40} {1}" -f $c, $status) -ForegroundColor $color
}

Write-Host "`n=== Cross-Reference: commands/ vs skills/ ===" -ForegroundColor Cyan
$skillNames   = Get-ShitPmSkillNames -ShitPmRoot $root
$commandFiles = Get-ChildItem -LiteralPath (Join-Path $root 'commands') -File |
    ForEach-Object { [System.IO.Path]::GetFileNameWithoutExtension($_.Name) }
$internalSkills = @('scope')
foreach ($s in $skillNames) {
    if ($internalSkills -contains $s) {
        Write-Host ("  skill={0,-15} command=internal (skipped)" -f $s) -ForegroundColor DarkGray
        continue
    }
    $has    = $commandFiles -contains $s
    $status = if ($has) { 'ok' } else { 'MISSING' }
    $color  = if ($has) { 'Green' } else { $allOk = $false; 'Red' }
    Write-Host ("  skill={0,-15} command={1}" -f $s, $status) -ForegroundColor $color
}

Write-Host ""
if ($allOk) {
    Write-Host "all-checks:ok" -ForegroundColor Green
} else {
    Write-Error "some checks failed"
    exit 1
}

