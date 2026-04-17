param(
    [switch]$RepairIndex
)

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $repoRoot

$gitDir = Join-Path $repoRoot '.git'
$indexPath = Join-Path $gitDir 'index'
$lockPaths = @(
    (Join-Path $gitDir 'index.lock'),
    (Join-Path $gitDir 'index.v2.tmp.lock')
)

function Get-ActiveGitProcesses {
    Get-Process -ErrorAction SilentlyContinue |
        Where-Object { $_.ProcessName -match '^(git|git-remote-http|git-remote-https|git-lfs)$' }
}

function Test-GitIndexHealthy {
    git status --short *> $null
    return ($LASTEXITCODE -eq 0)
}

function Backup-File([string]$Path) {
    if (-not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupPath = "$Path.corrupt-backup-$timestamp"
    Copy-Item -LiteralPath $Path -Destination $backupPath -Force
    return $backupPath
}

$activeGit = Get-ActiveGitProcesses
if ($activeGit) {
    $names = ($activeGit | Select-Object -ExpandProperty ProcessName | Sort-Object -Unique) -join ', '
    Write-Error "Active git processes detected: $names. Close editor Git integrations or wait for them to finish, then retry."
}

$removedLocks = @()
foreach ($lockPath in $lockPaths) {
    if (Test-Path -LiteralPath $lockPath) {
        Remove-Item -LiteralPath $lockPath -Force
        $removedLocks += $lockPath
    }
}

if ($removedLocks.Count -gt 0) {
    Write-Host ("Removed lock files: " + ($removedLocks -join ', ')) -ForegroundColor Yellow
} else {
    Write-Host 'No stale index lock files found.' -ForegroundColor Green
}

$indexHealthy = $true
try {
    $indexHealthy = Test-GitIndexHealthy
} catch {
    $indexHealthy = $false
}

if (-not $indexHealthy) {
    if (-not $RepairIndex) {
        Write-Error 'Git index is unhealthy. Re-run with -RepairIndex to rebuild .git/index.'
    }

    $backupPath = Backup-File -Path $indexPath
    if ($backupPath) {
        Write-Host "Backed up corrupt index to $backupPath" -ForegroundColor Yellow
    }

    if (Test-Path -LiteralPath $indexPath) {
        Remove-Item -LiteralPath $indexPath -Force
    }

    git reset --mixed HEAD
    if ($LASTEXITCODE -ne 0) {
        Write-Error 'Failed to rebuild git index via git reset --mixed HEAD.'
    }

    Write-Host 'Git index rebuilt successfully.' -ForegroundColor Green
}

git status --short
exit $LASTEXITCODE
