# 探测当前机器上存在的宿主环境
# 返回一个 HostKind 字符串数组，每项对应一个已就绪的宿主

$knownHosts = @(
    [pscustomobject]@{ Kind = 'copilot'; Base = (Join-Path $env:USERPROFILE '.copilot') },
    [pscustomobject]@{ Kind = 'codex';   Base = (Join-Path $env:USERPROFILE '.agents') },
    [pscustomobject]@{ Kind = 'cursor';  Base = (Join-Path $env:USERPROFILE '.cursor') },
    [pscustomobject]@{ Kind = 'windsurf'; Base = (Join-Path $env:USERPROFILE '.windsurf') },
    [pscustomobject]@{ Kind = 'trae';    Base = (Join-Path $env:USERPROFILE '.trae') },
    [pscustomobject]@{ Kind = 'antigravity'; Base = (Join-Path $env:USERPROFILE '.gemini/antigravity') }
)

$detected = @()
foreach ($h in $knownHosts) {
    if (Test-Path -LiteralPath $h.Base) {
        $detected += $h.Kind
    }
}

return $detected
