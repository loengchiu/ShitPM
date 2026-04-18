param(
    [Parameter(Mandatory = $true)][ValidateSet('copilot', 'codex', 'cursor', 'windsurf', 'trae', 'trae-cn', 'antigravity')][string]$HostKind
)

$base = switch ($HostKind) {
    'copilot'     { Join-Path $env:USERPROFILE '.copilot' }
    'codex'       {
        $new = Join-Path $env:USERPROFILE '.codex'
        $legacy = Join-Path $env:USERPROFILE '.agents'
        if (Test-Path -LiteralPath $new) { $new } else { $legacy }
    }
    'cursor'      { Join-Path $env:USERPROFILE '.cursor' }
    'windsurf'    { Join-Path $env:USERPROFILE '.windsurf' }
    'trae'        { Join-Path $env:USERPROFILE '.trae' }
    'trae-cn'     { Join-Path $env:USERPROFILE '.trae-cn' }
    'antigravity' { Join-Path $env:USERPROFILE '.gemini\antigravity' }
}

[string]$bundle = Join-Path $base 'shitpm'

[pscustomobject]@{
    Host = $HostKind
    Base = $base
    Bundle = $bundle
    Skills = (Join-Path $bundle 'skills')
    Commands = (Join-Path $bundle 'commands')
    Templates = (Join-Path $bundle 'templates')
    Contracts = (Join-Path $bundle 'contracts')
}
