$ErrorActionPreference = 'Stop'

$baseDir = Join-Path $env:USERPROFILE '.gemini\antigravity'
$kiDir = Join-Path $baseDir 'knowledge\ShitPM-Workflow'
$artifactsDir = Join-Path $kiDir 'artifacts'

$checks = @(
    @{ Name = 'MetadataFile'; Path = (Join-Path $kiDir 'metadata.json'); Type = 'File' },
    @{ Name = 'ArtifactsDir'; Path = $artifactsDir; Type = 'Directory' },
    @{ Name = 'SkillsNode'; Path = (Join-Path $artifactsDir 'skills'); Type = 'Junction' },
    @{ Name = 'CommandsNode'; Path = (Join-Path $artifactsDir 'commands'); Type = 'Junction' },
    @{ Name = 'TemplatesNode'; Path = (Join-Path $artifactsDir 'templates'); Type = 'Junction' },
    @{ Name = 'ContractsNode'; Path = (Join-Path $artifactsDir 'contracts'); Type = 'Junction' }
)

$allOk = $true

foreach ($check in $checks) {
    $path = $check.Path
    $exists = Test-Path -LiteralPath $path
    
    if (-not $exists) {
        Write-Host "X Missing $($check.Name): $path" -ForegroundColor Red
        $allOk = $false
        continue
    }

    if ($check.Type -eq 'Junction') {
        $item = Get-Item -LiteralPath $path -Force
        if ($item.LinkType -ne 'Junction') {
            Write-Host "X Invalid Format $($check.Name) is not a valid Junction link: $path" -ForegroundColor Red
            $allOk = $false
            continue
        }
    }
}

if (-not $allOk) {
    exit 1
}

Write-Host "Antigravity Verification Passed." -ForegroundColor Green
exit 0
