param(
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$templatesDir = Join-Path $root 'templates'
$docsDir = Join-Path $root 'docs'
$prototypesDir = Join-Path $docsDir 'prototypes'

$srcCss = Join-Path $templatesDir 'prototype-shared.css'
$srcJs  = Join-Path $templatesDir 'prototype-shared.js'
$dstCss = Join-Path $prototypesDir 'shared.css'
$dstJs  = Join-Path $prototypesDir 'shared.js'

if (-not (Test-Path -LiteralPath $srcCss)) { Write-Error "Missing template: $srcCss" }
if (-not (Test-Path -LiteralPath $srcJs))  { Write-Error "Missing template: $srcJs" }

if (-not (Test-Path -LiteralPath $prototypesDir)) {
    New-Item -ItemType Directory -Path $prototypesDir | Out-Null
}

function Copy-IfNeeded([string]$src, [string]$dst) {
    if ($Force -or (-not (Test-Path -LiteralPath $dst))) {
        Copy-Item -LiteralPath $src -Destination $dst -Force
        return $true
    }
    return $false
}

$copiedCss = Copy-IfNeeded -src $srcCss -dst $dstCss
$copiedJs  = Copy-IfNeeded -src $srcJs  -dst $dstJs

if ($copiedCss -or $copiedJs) {
    Write-Host "[ShitPM] Prototype shared assets ensured: $dstCss, $dstJs" -ForegroundColor Green
} else {
    Write-Host "[ShitPM] Prototype shared assets already exist: $dstCss, $dstJs" -ForegroundColor Green
}

exit 0
