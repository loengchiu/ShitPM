param(
    [Parameter(Mandatory = $true)]
    [string]$Message,

    [string[]]$Paths
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $repoRoot

$unlockScript = Join-Path $PSScriptRoot 'git-unlock.ps1'

& powershell -NoProfile -ExecutionPolicy Bypass -File $unlockScript -RepairIndex
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

if ($Paths -and $Paths.Count -gt 0) {
    git add -- $Paths
} else {
    git add -A
}

if ($LASTEXITCODE -ne 0) {
    Write-Error 'git add failed.'
}

$hasStaged = git diff --cached --name-only
if (-not $hasStaged) {
    Write-Error 'No staged changes to commit.'
}

git commit -m $Message
exit $LASTEXITCODE
