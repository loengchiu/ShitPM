param(
    [Parameter(Mandatory = $true)][ValidateSet('copilot', 'codex', 'trae', 'trae-cn')][string]$HostKind
)

$ErrorActionPreference = 'Stop'

$userHome = $env:USERPROFILE
$startMarker = '<!-- SHITPM GLOBAL RULES START -->'
$endMarker = '<!-- SHITPM GLOBAL RULES END -->'

function Remove-EmptyDirectory {
    param([string]$Path)
    if (-not (Test-Path -LiteralPath $Path)) { return }
    $hasChildren = Get-ChildItem -LiteralPath $Path -Force -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $hasChildren) {
        Remove-Item -LiteralPath $Path -Force
    }
}

switch ($HostKind) {
    'codex' {
        $path = Join-Path $userHome '.codex\AGENTS.md'
        if (Test-Path -LiteralPath $path) {
            $existing = Get-Content -LiteralPath $path -Raw
            if ($existing -match [regex]::Escape($startMarker)) {
                $pattern = "(?s)\s*$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))\s*"
                $updated = [regex]::Replace($existing, $pattern, '')
                $trimmed = $updated.Trim()
                if ([string]::IsNullOrWhiteSpace($trimmed)) {
                    Remove-Item -LiteralPath $path -Force
                } else {
                    Set-Content -LiteralPath $path -Value $trimmed -Encoding UTF8
                }
            }
        }
    }

    'copilot' {
        $dir = Join-Path $userHome '.copilot\instructions'
        $path = Join-Path $dir 'shitpm-global.instructions.md'
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Force
        }
        Remove-EmptyDirectory -Path $dir
    }

    'trae' {
        $dir = Join-Path $userHome '.trae\rules'
        $path = Join-Path $dir 'shitpm-global.md'
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Force
        }
        Remove-EmptyDirectory -Path $dir
    }

    'trae-cn' {
        $dir = Join-Path $userHome '.trae-cn\rules'
        $path = Join-Path $dir 'shitpm-global.md'
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Force
        }
        Remove-EmptyDirectory -Path $dir
    }
}

Write-Output 'global-rules:removed'
