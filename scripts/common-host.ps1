function Get-ShitPmRoot {
    return (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
}

function New-BackupRoot {
    param(
        [Parameter(Mandatory = $true)][string]$HostBase
    )
    $timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupRoot = Join-Path $HostBase ("backups\\shitpm-install-" + $timestamp)
    New-Item -ItemType Directory -Force -Path $backupRoot | Out-Null
    return $backupRoot
}

function Backup-ExistingItem {
    param(
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$BackupRoot
    )
    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    $name = Split-Path -Leaf $Path
    $dest = Join-Path $BackupRoot $name
    Move-Item -LiteralPath $Path -Destination $dest -Force
}

function Ensure-Junction {
    param(
        [Parameter(Mandatory = $true)][string]$LinkPath,
        [Parameter(Mandatory = $true)][string]$TargetPath,
        [Parameter(Mandatory = $true)][string]$BackupRoot
    )

    if (Test-Path -LiteralPath $LinkPath) {
        try {
            $item = Get-Item -LiteralPath $LinkPath -Force
            $normalizedTarget = $TargetPath.TrimEnd('\/').ToLowerInvariant()
            $existingTargets = $item.Target | ForEach-Object { $_.TrimEnd('\/').ToLowerInvariant() }
            if ($item.LinkType -and $existingTargets -contains $normalizedTarget) {
                return
            }
        } catch {
        }
        Backup-ExistingItem -Path $LinkPath -BackupRoot $BackupRoot
    }

    New-Item -ItemType Junction -Path $LinkPath -Target $TargetPath | Out-Null
}

function Remove-SafeJunctionOrDir {
    param(
        [Parameter(Mandatory = $true)][string]$Path
    )

    if (-not (Test-Path -LiteralPath $Path)) {
        return
    }

    $item = Get-Item -LiteralPath $Path -Force
    if ($item.LinkType -eq 'Junction') {
        cmd /c rmdir "$Path" | Out-Null
    } else {
        Remove-Item -LiteralPath $Path -Force -Recurse
    }
}

function Get-ShitPmSkillNames {
    param(
        [Parameter(Mandatory = $true)][string]$ShitPmRoot
    )
    return (Get-ChildItem -LiteralPath (Join-Path $ShitPmRoot 'skills') -Directory | Select-Object -ExpandProperty Name)
}
