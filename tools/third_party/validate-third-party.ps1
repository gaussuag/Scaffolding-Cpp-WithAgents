param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$Root = (Resolve-Path -LiteralPath $Root).Path
$ThirdPartyRoot = Join-Path $Root "third_party"
$Failures = New-Object System.Collections.Generic.List[string]

function Add-Failure {
    param([string]$Message)
    $Failures.Add($Message) | Out-Null
}

function Get-TopLevelYamlKeys {
    param([string[]]$Lines)

    $keys = @{}
    foreach ($line in $Lines) {
        if ($line -match "^([A-Za-z_][A-Za-z0-9_-]*):\s*(.*)$") {
            $value = $Matches[2].Trim()
            $value = $value.Trim('"')
            $keys[$Matches[1]] = $value
        }
    }
    return $keys
}

function Get-YamlListItemPaths {
    param(
        [string[]]$Lines,
        [string]$SectionName
    )

    $paths = New-Object System.Collections.Generic.List[string]
    $inside = $false
    foreach ($line in $Lines) {
        if ($line -match "^$([regex]::Escape($SectionName)):\s*(.*)$") {
            $inside = $true
            continue
        }

        if ($inside -and $line -match "^[A-Za-z_][A-Za-z0-9_-]*:") {
            break
        }

        if ($inside -and $line -match "^\s*-\s*path:\s*(.+)$") {
            $path = $Matches[1].Trim().Trim('"')
            if ($path -ne "") {
                $paths.Add($path) | Out-Null
            }
        }
    }
    return $paths
}

function Get-YamlDependencies {
    param([string[]]$Lines)

    $deps = @()
    $inside = $false
    $current = $null

    foreach ($line in $Lines) {
        if ($line -match "^dependencies:\s*(.*)$") {
            $inside = $true
            continue
        }

        if ($inside -and $line -match "^[A-Za-z_][A-Za-z0-9_-]*:") {
            if ($null -ne $current) {
                $deps += $current
            }
            break
        }

        if (-not $inside) {
            continue
        }

        if ($line -match "^\s*-\s*name:\s*(.+)$") {
            if ($null -ne $current) {
                $deps += $current
            }
            $current = [ordered]@{ name = $Matches[1].Trim().Trim('"'); version = "" }
        } elseif ($null -ne $current -and $line -match "^\s+version:\s*(.+)$") {
            $current.version = $Matches[1].Trim().Trim('"')
        }
    }

    if ($inside -and $null -ne $current) {
        $deps += $current
    }

    return $deps
}

if (-not (Test-Path -LiteralPath $ThirdPartyRoot)) {
    Add-Failure "third_party directory is missing."
} else {
    $packages = @(Get-ChildItem -LiteralPath $ThirdPartyRoot -Directory)
    foreach ($package in $packages) {
        $metadataPath = Join-Path $package.FullName "THIRD_PARTY.yml"
        if (-not (Test-Path -LiteralPath $metadataPath)) {
            Add-Failure "$($package.Name): missing THIRD_PARTY.yml"
            continue
        }

        $lines = Get-Content -LiteralPath $metadataPath
        $keys = Get-TopLevelYamlKeys $lines
        $required = @(
            "name",
            "version",
            "revision",
            "category",
            "update_policy",
            "source",
            "license",
            "triplets",
            "crt_linkage",
            "features",
            "dependencies",
            "artifacts"
        )

        foreach ($key in $required) {
            if (-not $keys.ContainsKey($key)) {
                Add-Failure "$($package.Name): THIRD_PARTY.yml missing required key '$key'"
            }
        }

        if ($keys.ContainsKey("name") -and $keys["name"] -ne $package.Name) {
            Add-Failure "$($package.Name): metadata name '$($keys["name"])' must match directory name"
        }

        if ($keys.ContainsKey("category") -and $keys.ContainsKey("update_policy")) {
            if ($keys["category"] -eq "foundation" -and $keys["update_policy"] -ne "frozen") {
                Add-Failure "$($package.Name): foundation dependencies must use update_policy: frozen"
            }
        }

        $packageFiles = @(Get-ChildItem -LiteralPath $package.FullName -Filter "*Package.cmake" -File)
        if ($packageFiles.Count -eq 0) {
            Add-Failure "$($package.Name): missing <Lib>Package.cmake"
        } elseif ($packageFiles.Count -gt 1) {
            Add-Failure "$($package.Name): expected one package CMake entry, found $($packageFiles.Count)"
        } else {
            $packageText = Get-Content -LiteralPath $packageFiles[0].FullName -Raw
            if ($packageText -notmatch "ScaffoldingCpp::ThirdParty::") {
                Add-Failure "$($package.Name): package file must expose a ScaffoldingCpp::ThirdParty::<Lib> target"
            }
            if ($packageText -match "FetchContent|ExternalProject_Add|find_package\s*\(") {
                Add-Failure "$($package.Name): package file must not fetch or implicitly discover dependencies"
            }
        }

        foreach ($artifactPath in (Get-YamlListItemPaths -Lines $lines -SectionName "artifacts")) {
            $fullArtifactPath = [System.IO.Path]::GetFullPath((Join-Path $package.FullName $artifactPath))
            if (-not $fullArtifactPath.StartsWith($package.FullName, [System.StringComparison]::OrdinalIgnoreCase)) {
                Add-Failure "$($package.Name): artifact path escapes package: $artifactPath"
            } elseif (-not (Test-Path -LiteralPath $fullArtifactPath)) {
                Add-Failure "$($package.Name): artifact path does not exist: $artifactPath"
            }
        }
    }

    $metadataByName = @{}
    foreach ($package in $packages) {
        $metadataPath = Join-Path $package.FullName "THIRD_PARTY.yml"
        if (Test-Path -LiteralPath $metadataPath) {
            $metadataByName[$package.Name] = Get-TopLevelYamlKeys (Get-Content -LiteralPath $metadataPath)
        }
    }

    foreach ($package in $packages) {
        $metadataPath = Join-Path $package.FullName "THIRD_PARTY.yml"
        if (-not (Test-Path -LiteralPath $metadataPath)) {
            continue
        }

        foreach ($dep in (Get-YamlDependencies (Get-Content -LiteralPath $metadataPath))) {
            if (-not $metadataByName.ContainsKey($dep.name)) {
                Add-Failure "$($package.Name): dependency '$($dep.name)' is not frozen under third_party"
                continue
            }

            $actualVersion = $metadataByName[$dep.name]["version"]
            if ($dep.version -ne "" -and $actualVersion -ne $dep.version) {
                Add-Failure "$($package.Name): dependency '$($dep.name)' expects version '$($dep.version)' but frozen package is '$actualVersion'"
            }
        }
    }
}

$attributesPath = Join-Path $Root ".gitattributes"
if (-not (Test-Path -LiteralPath $attributesPath)) {
    Add-Failure ".gitattributes is missing"
} else {
    $attributesText = Get-Content -LiteralPath $attributesPath -Raw
    foreach ($extension in @("lib", "dll", "exe", "pdb")) {
        $pattern = "third_party/\*\*/\*\.$extension"
        if ($attributesText -notmatch [regex]::Escape("third_party/**/*.${extension}")) {
            Add-Failure ".gitattributes missing Git LFS rule for third_party/**/*.${extension}"
        }
    }
}

if ($Failures.Count -gt 0) {
    Write-Host "third_party validation failed:" -ForegroundColor Red
    foreach ($failure in $Failures) {
        Write-Host "  - $failure" -ForegroundColor Red
    }
    exit 1
}

Write-Host "third_party validation passed." -ForegroundColor Green
