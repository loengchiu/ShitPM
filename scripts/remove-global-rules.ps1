param(
    [Parameter(Mandatory = $true)][ValidateSet('copilot', 'codex')][string]$HostKind
)

$ErrorActionPreference = 'Stop'

$userHome = $env:USERPROFILE
$startMarker = '<!-- SHITPM GLOBAL RULES START -->'
$endMarker = '<!-- SHITPM GLOBAL RULES END -->'

switch ($HostKind) {
    'codex' {
        $path = Join-Path $userHome '.codex\AGENTS.md'
        if (Test-Path -LiteralPath $path) {
            $existing = Get-Content -LiteralPath $path -Raw
            if ($existing -match [regex]::Escape($startMarker)) {
                $pattern = "(?s)\s*$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))\s*"
                $updated = [regex]::Replace($existing, $pattern, '')
                Set-Content -LiteralPath $path -Value $updated.Trim() -Encoding UTF8
            }
        }
    }

    'copilot' {
        $path = Join-Path $userHome '.copilot\instructions\shitpm-global.instructions.md'
        if (Test-Path -LiteralPath $path) {
            Remove-Item -LiteralPath $path -Force
        }
    }
}

Write-Output 'global-rules:removed'
