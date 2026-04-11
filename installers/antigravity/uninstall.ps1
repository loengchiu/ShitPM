$ErrorActionPreference = 'Stop'

. (Join-Path $PSScriptRoot '..\..\scripts\common-host.ps1')

$baseDir = Join-Path $env:USERPROFILE '.gemini\antigravity'
$kiDir = Join-Path $baseDir 'knowledge\ShitPM-Workflow'

if (Test-Path -LiteralPath $kiDir) {
    # 强制清理 Junction 和实际生成的 KI 描述目录
    function Remove-SafeJunctionOrDir {
        param([string]$Path)
        if (-not (Test-Path -LiteralPath $Path)) { return }
        $item = Get-Item -LiteralPath $Path -Force
        if ($item.LinkType -eq 'Junction') {
            [System.IO.Directory]::Delete($Path, $false)
        } else {
            Remove-Item -LiteralPath $Path -Force -Recurse
        }
    }

    $artifactsDir = Join-Path $kiDir 'artifacts'
    if (Test-Path -LiteralPath $artifactsDir) {
        Remove-SafeJunctionOrDir -Path (Join-Path $artifactsDir 'skills')
        Remove-SafeJunctionOrDir -Path (Join-Path $artifactsDir 'commands')
        Remove-SafeJunctionOrDir -Path (Join-Path $artifactsDir 'contracts')
        Remove-SafeJunctionOrDir -Path (Join-Path $artifactsDir 'templates')
    }

    Remove-SafeJunctionOrDir -Path $kiDir
}

exit 0
