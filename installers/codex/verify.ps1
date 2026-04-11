param()

$shitpmRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\\..')).Path
$scriptsDir = Join-Path $shitpmRoot 'scripts'

& (Join-Path $scriptsDir 'verify-mappings.ps1') -HostKind 'codex'
exit $LASTEXITCODE
