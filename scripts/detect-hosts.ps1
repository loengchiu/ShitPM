# 探测当前机器上存在的宿主环境
# 返回一个 HostKind 字符串数组，每项对应一个已就绪的宿主

$knownHosts = @(
    [pscustomobject]@{ Kind = 'copilot'; Base = (Join-Path $env:USERPROFILE '.copilot') },
    # Codex CLI / desktop uses ~/.codex; some older setups used ~/.agents.
    [pscustomobject]@{ Kind = 'codex';   Base = (Join-Path $env:USERPROFILE '.codex') },
    [pscustomobject]@{ Kind = 'cursor';  Base = (Join-Path $env:USERPROFILE '.cursor') },
    [pscustomobject]@{ Kind = 'windsurf'; Base = (Join-Path $env:USERPROFILE '.windsurf') },
    [pscustomobject]@{ Kind = 'trae';    Base = (Join-Path $env:USERPROFILE '.trae') },
    [pscustomobject]@{ Kind = 'trae-cn'; Base = (Join-Path $env:USERPROFILE '.trae-cn') },
    [pscustomobject]@{ Kind = 'antigravity'; Base = (Join-Path $env:USERPROFILE '.gemini/antigravity') }
)

$detected = @()
foreach ($h in $knownHosts) {
    if (Test-Path -LiteralPath $h.Base) {
        $detected += $h.Kind
    }
}

# Back-compat: if ~/.agents exists but ~/.codex does not, still treat as codex host.
$legacyCodexBase = Join-Path $env:USERPROFILE '.agents'
$newCodexBase = Join-Path $env:USERPROFILE '.codex'
if ((-not (Test-Path -LiteralPath $newCodexBase)) -and (Test-Path -LiteralPath $legacyCodexBase)) {
    if ($detected -notcontains 'codex') {
        $detected += 'codex'
    }
}

return $detected
