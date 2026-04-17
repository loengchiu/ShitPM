param(
    [Parameter(Mandatory = $true)][ValidateSet('copilot', 'codex')][string]$HostKind
)

$ErrorActionPreference = 'Stop'
$shitpmRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$userHome = $env:USERPROFILE

switch ($HostKind) {
    'codex' {
        $path = Join-Path $userHome '.codex\AGENTS.md'
        if (-not (Test-Path -LiteralPath $path)) {
            Write-Error 'verify failed: codex AGENTS.md missing'
            exit 1
        }
        $content = Get-Content -LiteralPath $path -Raw
        if ($content -notmatch 'ShitPM Global Rules' -or $content -notmatch [regex]::Escape("$shitpmRoot\AGENTS.md")) {
            Write-Error 'verify failed: codex AGENTS.md missing ShitPM rule block'
            exit 1
        }
    }

    'copilot' {
        $path = Join-Path $userHome '.copilot\instructions\shitpm-global.instructions.md'
        if (-not (Test-Path -LiteralPath $path)) {
            Write-Error 'verify failed: copilot global instructions missing'
            exit 1
        }
        $content = Get-Content -LiteralPath $path -Raw
        if ($content -notmatch 'ShitPM Global Rules' -or $content -notmatch [regex]::Escape("$shitpmRoot\AGENTS.md")) {
            Write-Error 'verify failed: copilot global instructions missing ShitPM rule'
            exit 1
        }
    }
}

Write-Output 'global-rules:verify-ok'
