param(
    [string]$Version
)

$ErrorActionPreference = 'Stop'

$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$versionFile = Join-Path $projectRoot 'VERSION'

if (-not $Version) {
    if (-not (Test-Path -LiteralPath $versionFile)) {
        throw 'VERSION file not found'
    }
    $Version = (Get-Content -Raw $versionFile).Trim()
}

if ([string]::IsNullOrWhiteSpace($Version)) {
    throw 'Version is empty'
}

$distRoot = Join-Path $projectRoot 'dist'
$releaseName = "ShitPM-$Version"
$releaseDir = Join-Path $distRoot $releaseName
$packageRoot = Join-Path $releaseDir 'shitpm'
$zipPath = Join-Path $distRoot ($releaseName + '.zip')

New-Item -ItemType Directory -Force -Path $distRoot | Out-Null

if (Test-Path -LiteralPath $releaseDir) {
    Remove-Item -LiteralPath $releaseDir -Recurse -Force
}

if (Test-Path -LiteralPath $zipPath) {
    Remove-Item -LiteralPath $zipPath -Force
}

New-Item -ItemType Directory -Force -Path $releaseDir | Out-Null

New-Item -ItemType Directory -Force -Path $packageRoot | Out-Null

$excludeNames = @('dist', '.git')
$itemsToCopy = Get-ChildItem -LiteralPath $projectRoot -Force | Where-Object { $excludeNames -notcontains $_.Name }

foreach ($item in $itemsToCopy) {
    Copy-Item -LiteralPath $item.FullName -Destination $packageRoot -Recurse -Force
}

Compress-Archive -Path $packageRoot -DestinationPath $zipPath -Force

[pscustomobject]@{
    version = $Version
    release_dir = $releaseDir
    package_root = $packageRoot
    zip = $zipPath
} | ConvertTo-Json
