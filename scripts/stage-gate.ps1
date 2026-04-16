param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('scope','sum','mind','feat','page','prd','rev','fix','mock','note')]
    [string]$Target
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$statusFile = Join-Path $root 'docs\project-status.json'

function Fail([string]$msg) {
    Write-Host "[ShitPM gate] BLOCKED ($Target): $msg" -ForegroundColor Red
    exit 1
}

function Pass([string]$msg) {
    Write-Host "[ShitPM gate] OK ($Target): $msg" -ForegroundColor Green
}

function Assert-FileExists([string]$label, [string]$relPath) {
    if (-not $relPath) {
        Fail "$label missing stable baseline. Confirm current stable version or repair project state first."
    }
    $full = Join-Path $root ($relPath -replace '/', '\')
    if (-not (Test-Path -LiteralPath $full)) {
        Fail "$label file does not exist: $relPath"
    }
}

$softStages = @('scope', 'sum', 'mind', 'feat')
if ($softStages -contains $Target) {
    Pass 'soft stage with no required file prerequisites'
    exit 0
}

if (-not (Test-Path -LiteralPath $statusFile)) {
    Fail 'project-status.json not found. Initialize the project with /init first.'
}

$s = Get-Content -LiteralPath $statusFile -Raw | ConvertFrom-Json

$blockers = @($s.blockers | Where-Object { $_ })
if ($blockers.Count -gt 0) {
    $list = ($blockers | ForEach-Object { "  - $_" }) -join "`n"
    Fail "unresolved blockers exist:`n$list"
}

$pending = @($s.pending_confirmations | Where-Object { $_ })
if ($pending.Count -gt 0) {
    $list = ($pending | ForEach-Object { "  - $_" }) -join "`n"
    Fail "pending confirmations exist:`n$list"
}

switch ($Target) {
    'page' {
        Assert-FileExists 'Feature List [stable_baselines]' $s.stable_baselines.feature_list
        Pass 'feature list stable baseline exists'
    }

    'prd' {
        Assert-FileExists 'Feature List [stable_baselines]' $s.stable_baselines.feature_list
        Assert-FileExists 'Page Structure [stable_baselines]' $s.stable_baselines.page_structure
        Pass 'feature list and page structure stable baselines exist'
    }

    'rev' {
        $hasMindmap = [bool]$s.latest_artifacts.mindmap
        $hasFeatureList = [bool]($s.latest_artifacts.feature_list -or $s.stable_baselines.feature_list)
        $hasPageStructure = [bool]($s.latest_artifacts.page_structure -or $s.stable_baselines.page_structure)
        $hasPrd = [bool]($s.latest_artifacts.prd -or $s.stable_baselines.prd)

        if (-not ($hasMindmap -or $hasFeatureList -or $hasPageStructure -or $hasPrd)) {
            Fail 'no reviewable object found. Generate at least one of mindmap, feature list, page structure, or prd first.'
        }

        if ($hasMindmap) {
            Assert-FileExists 'Mindmap [latest_artifacts]' $s.latest_artifacts.mindmap
        }
        if ($s.stable_baselines.feature_list) {
            Assert-FileExists 'Feature List [stable_baselines]' $s.stable_baselines.feature_list
        } elseif ($s.latest_artifacts.feature_list) {
            Assert-FileExists 'Feature List [latest_artifacts]' $s.latest_artifacts.feature_list
        }
        if ($s.stable_baselines.page_structure) {
            Assert-FileExists 'Page Structure [stable_baselines]' $s.stable_baselines.page_structure
        } elseif ($s.latest_artifacts.page_structure) {
            Assert-FileExists 'Page Structure [latest_artifacts]' $s.latest_artifacts.page_structure
        }
        if ($s.latest_artifacts.prd) {
            Assert-FileExists 'PRD [latest_artifacts]' $s.latest_artifacts.prd
        } elseif ($s.stable_baselines.prd) {
            Assert-FileExists 'PRD [stable_baselines]' $s.stable_baselines.prd
        }

        Pass 'at least one reviewable object exists'
    }

    'fix' {
        $hasMindmap = [bool]$s.latest_artifacts.mindmap
        $hasFeatureList = [bool]($s.latest_artifacts.feature_list -or $s.stable_baselines.feature_list)
        $hasPageStructure = [bool]($s.latest_artifacts.page_structure -or $s.stable_baselines.page_structure)
        $hasPrd = [bool]($s.latest_artifacts.prd -or $s.stable_baselines.prd)

        if (-not ($hasMindmap -or $hasFeatureList -or $hasPageStructure -or $hasPrd)) {
            Fail 'no fixable object found. Generate at least one of mindmap, feature list, page structure, or prd first.'
        }

        if ($hasMindmap) {
            Assert-FileExists 'Mindmap [latest_artifacts]' $s.latest_artifacts.mindmap
        }
        if ($s.stable_baselines.feature_list) {
            Assert-FileExists 'Feature List [stable_baselines]' $s.stable_baselines.feature_list
        } elseif ($s.latest_artifacts.feature_list) {
            Assert-FileExists 'Feature List [latest_artifacts]' $s.latest_artifacts.feature_list
        }
        if ($s.stable_baselines.page_structure) {
            Assert-FileExists 'Page Structure [stable_baselines]' $s.stable_baselines.page_structure
        } elseif ($s.latest_artifacts.page_structure) {
            Assert-FileExists 'Page Structure [latest_artifacts]' $s.latest_artifacts.page_structure
        }
        if ($s.latest_artifacts.prd) {
            Assert-FileExists 'PRD [latest_artifacts]' $s.latest_artifacts.prd
        } elseif ($s.stable_baselines.prd) {
            Assert-FileExists 'PRD [stable_baselines]' $s.stable_baselines.prd
        }

        Pass 'at least one fixable object exists'
    }

    'mock' {
        Assert-FileExists 'PRD [stable_baselines]' $s.stable_baselines.prd
        Pass 'prd stable baseline exists'
    }

    'note' {
        Assert-FileExists 'PRD [stable_baselines]' $s.stable_baselines.prd
        Assert-FileExists 'Prototype [stable_baselines]' $s.stable_baselines.prototype
        Pass 'prd and prototype stable baselines exist'
    }
}

exit 0
