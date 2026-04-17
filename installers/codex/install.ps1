param()

$ErrorActionPreference = 'Stop'

$shitpmRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\\..')).Path
$scriptsDir = Join-Path $shitpmRoot 'scripts'
$resolved = & (Join-Path $scriptsDir 'resolve-paths.ps1') -HostKind 'codex'
$hostBase = $resolved.Base

if (-not (Test-Path -LiteralPath $hostBase)) {
    Write-Error 'Codex host root not found'
    exit 1
}

try {
    & (Join-Path $scriptsDir 'write-mappings.ps1') -HostKind 'codex'
    & (Join-Path $scriptsDir 'write-global-rules.ps1') -HostKind 'codex'
    & (Join-Path $scriptsDir 'verify-mappings.ps1') -HostKind 'codex'
    & (Join-Path $scriptsDir 'verify-global-rules.ps1') -HostKind 'codex'
    exit 0
} catch {
    Write-Error $_
    exit 1
}
