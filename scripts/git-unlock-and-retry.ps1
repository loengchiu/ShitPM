param(
    [string]$RetryCommand = ""
)

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
Set-Location $repoRoot

$lockPath = Join-Path $repoRoot ".git/index.lock"

if (Test-Path $lockPath) {
    Remove-Item -Force $lockPath -ErrorAction SilentlyContinue
}

if (Test-Path $lockPath) {
    Write-Error "Failed to remove $lockPath"
    exit 1
}

Write-Host "index.lock cleared"

if (-not [string]::IsNullOrWhiteSpace($RetryCommand)) {
    Write-Host "retrying: $RetryCommand"
    Invoke-Expression $RetryCommand
    exit $LASTEXITCODE
}

# Default health check if no retry command was provided.
git status -sb
exit $LASTEXITCODE
