param(
    [Parameter(Mandatory = $true)][ValidateSet('copilot', 'codex', 'cursor', 'windsurf', 'trae', 'antigravity')][string]$HostKind
)

$base = switch ($HostKind) {
    'copilot'     { Join-Path $env:USERPROFILE '.copilot' }
    'codex'       { Join-Path $env:USERPROFILE '.agents' }
    'cursor'      { Join-Path $env:USERPROFILE '.cursor' }
    'windsurf'    { Join-Path $env:USERPROFILE '.windsurf' }
    'trae'        { Join-Path $env:USERPROFILE '.trae' }
    'antigravity' { Join-Path $env:USERPROFILE '.gemini\antigravity' }
}

[pscustomobject]@{
    Host = $HostKind
    Base = $base
    Skills = (Join-Path $base 'skills')
    Commands = (Join-Path $base 'shitpm-commands')
    Templates = (Join-Path $base 'shitpm-templates')
    Contracts = (Join-Path $base 'shitpm-contracts')
}
