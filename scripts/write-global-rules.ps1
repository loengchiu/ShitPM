param(
    [Parameter(Mandatory = $true)][ValidateSet('copilot', 'codex', 'trae', 'trae-cn')][string]$HostKind
)

$ErrorActionPreference = 'Stop'

$shitpmRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$userHome = $env:USERPROFILE
$startMarker = '<!-- SHITPM GLOBAL RULES START -->'
$endMarker = '<!-- SHITPM GLOBAL RULES END -->'

switch ($HostKind) {
    'codex' {
        $path = Join-Path $userHome '.codex\AGENTS.md'
        $dir = Split-Path -Parent $path
        if (-not (Test-Path -LiteralPath $dir)) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
        }

        $block = @(
            $startMarker
            '# ShitPM Global Rules'
            ''
            'If the current project root contains `docs/project-status.json`,'
            "read ${shitpmRoot}\AGENTS.md and follow all rules in that file."
            'If `docs/project-status.json` does not exist, ignore this rule and do not run any ShitPM workflow.'
            $endMarker
        ) -join "`r`n"

        $existing = if (Test-Path -LiteralPath $path) { Get-Content -LiteralPath $path -Raw } else { '' }
        if ($existing -match [regex]::Escape($startMarker)) {
            $pattern = "(?s)$([regex]::Escape($startMarker)).*?$([regex]::Escape($endMarker))"
            $updated = [regex]::Replace($existing, $pattern, $block)
        } elseif ([string]::IsNullOrWhiteSpace($existing)) {
            $updated = $block
        } else {
            $updated = ($existing.TrimEnd() + "`r`n`r`n" + $block)
        }

        Set-Content -LiteralPath $path -Value $updated -Encoding UTF8
    }

    'copilot' {
        $dir = Join-Path $userHome '.copilot\instructions'
        $path = Join-Path $dir 'shitpm-global.instructions.md'
        if (-not (Test-Path -LiteralPath $dir)) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
        }

        $content = @(
            '---'
            'applyTo: "**"'
            '---'
            '# ShitPM Global Rules'
            ''
            'If the current project root contains `docs/project-status.json`,'
            "read ${shitpmRoot}\AGENTS.md and follow all rules in that file."
            'If `docs/project-status.json` does not exist, ignore this rule and do not run any ShitPM workflow.'
        ) -join "`r`n"

        Set-Content -LiteralPath $path -Value $content -Encoding UTF8
    }

    'trae' {
        $dir = Join-Path $userHome '.trae\rules'
        $path = Join-Path $dir 'shitpm-global.md'
        if (-not (Test-Path -LiteralPath $dir)) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
        }

        $content = @(
            '---'
            'alwaysApply: true'
            '---'
            '# ShitPM Global Rules'
            ''
            'If the current project root contains `docs/project-status.json`,'
            "read ${shitpmRoot}\AGENTS.md and follow all rules in that file."
            'If `docs/project-status.json` does not exist, ignore this rule and do not run any ShitPM workflow.'
        ) -join "`r`n"

        Set-Content -LiteralPath $path -Value $content -Encoding UTF8
    }

    'trae-cn' {
        $dir = Join-Path $userHome '.trae-cn\rules'
        $path = Join-Path $dir 'shitpm-global.md'
        if (-not (Test-Path -LiteralPath $dir)) {
            New-Item -ItemType Directory -Force -Path $dir | Out-Null
        }

        $content = @(
            '---'
            'alwaysApply: true'
            '---'
            '# ShitPM Global Rules'
            ''
            'If the current project root contains `docs/project-status.json`,'
            "read ${shitpmRoot}\AGENTS.md and follow all rules in that file."
            'If `docs/project-status.json` does not exist, ignore this rule and do not run any ShitPM workflow.'
        ) -join "`r`n"

        Set-Content -LiteralPath $path -Value $content -Encoding UTF8
    }
}

Write-Output 'global-rules:ok'
