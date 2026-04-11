$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\..\scripts\common-host.ps1')

$shitpmRoot = Get-ShitPmRoot
$baseDir = Join-Path $env:USERPROFILE '.gemini\antigravity'
$knowledgeDir = Join-Path $baseDir 'knowledge'
$kiDir = Join-Path $knowledgeDir 'ShitPM-Workflow'
$artifactsDir = Join-Path $kiDir 'artifacts'

if (-not (Test-Path -LiteralPath $baseDir)) {
    # 如果根目录都没有，那就静默创建以便原生支持，毕竟我们在给别人打底
    New-Item -ItemType Directory -Force -Path $baseDir | Out-Null
}

if (-not (Test-Path -LiteralPath $knowledgeDir)) {
    New-Item -ItemType Directory -Force -Path $knowledgeDir | Out-Null
}

if (-not (Test-Path -LiteralPath $kiDir)) {
    New-Item -ItemType Directory -Force -Path $kiDir | Out-Null
}

if (-not (Test-Path -LiteralPath $artifactsDir)) {
    New-Item -ItemType Directory -Force -Path $artifactsDir | Out-Null
}

# 编排元数据 json
$metadataPath = Join-Path $kiDir 'metadata.json'
$metadata = @{
    summary = "ShitPM - AI Product Manager Workflow Commands, Templates, and Skills. Used to build PM features and act as a PM. This Knowledge Item persists local workflow instructions."
    created_at = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
    updated_at = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
    references = @("file:///" + (Join-Path $shitpmRoot 'README.md'))
}
$metadata | ConvertTo-Json -Depth 2 | Out-File -FilePath $metadataPath -Encoding utf8 -Force

$backupRoot = New-BackupRoot -HostBase $baseDir

function Sync-Junction {
    param([string]$SourceDir, [string]$DestDir)
    Ensure-Junction -LinkPath $DestDir -TargetPath $SourceDir -BackupRoot $backupRoot
}

Sync-Junction -SourceDir (Join-Path $shitpmRoot 'skills') -DestDir (Join-Path $artifactsDir 'skills')
Sync-Junction -SourceDir (Join-Path $shitpmRoot 'commands') -DestDir (Join-Path $artifactsDir 'commands')
Sync-Junction -SourceDir (Join-Path $shitpmRoot 'contracts') -DestDir (Join-Path $artifactsDir 'contracts')
Sync-Junction -SourceDir (Join-Path $shitpmRoot 'templates') -DestDir (Join-Path $artifactsDir 'templates')

exit 0
