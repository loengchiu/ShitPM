param()

$shitpmRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\\..')).Path
$scriptsDir = Join-Path $shitpmRoot 'scripts'

& (Join-Path $scriptsDir 'verify-mappings.ps1') -HostKind 'trae-cn'
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& (Join-Path $scriptsDir 'verify-global-rules.ps1') -HostKind 'trae-cn'
exit $LASTEXITCODE
