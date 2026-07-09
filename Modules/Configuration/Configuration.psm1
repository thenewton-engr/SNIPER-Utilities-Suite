#==============================================================================
# SNIPER Utilities Suite
# Configuration Module
# Build 1003
#==============================================================================

Set-StrictMode -Version Latest

$script:Config = @{}

function Get-SNPProjectRoot {

    $Root = Resolve-Path (Join-Path $PSScriptRoot "..\..")

    return $Root.Path

}

function Initialize-SNPConfiguration {

    $ConfigFile = Join-Path (Get-SNPProjectRoot) "Config\Config.ini"

    if (!(Test-Path $ConfigFile)) {
        throw "Configuration file not found: $ConfigFile"
    }

    $script:Config = @{}
    $Section = ""

    foreach($Line in Get-Content $ConfigFile)
    {
        $Line = $Line.Trim()

        if([string]::IsNullOrWhiteSpace($Line)){continue}
        if($Line.StartsWith(";")){continue}
        if($Line.StartsWith("#")){continue}

        if($Line.StartsWith("["))
        {
            $Section = $Line.Trim("[","]")

            if(!$script:Config.ContainsKey($Section))
            {
                $script:Config[$Section] = @{}
            }

            continue
        }

        if($Line.Contains("="))
        {
            $Parts = $Line.Split("=",2)

            $script:Config[$Section][$Parts[0].Trim()] = $Parts[1].Trim()
        }

    }

    return $script:Config

}

function Get-SNPConfiguration {

    if($script:Config.Count -eq 0)
    {
        Initialize-SNPConfiguration | Out-Null
    }

    return $script:Config

}

function Get-SNPConfigValue {

    param(
        [string]$Section,
        [string]$Key
    )

    if($script:Config.Count -eq 0)
    {
        Initialize-SNPConfiguration | Out-Null
    }

    if($script:Config.ContainsKey($Section))
    {
        if($script:Config[$Section].ContainsKey($Key))
        {
            return $script:Config[$Section][$Key]
        }
    }

    return $null

}

function Show-SNPConfiguration {

    if($script:Config.Count -eq 0)
    {
        Initialize-SNPConfiguration | Out-Null
    }

    foreach($Section in $script:Config.Keys)
    {
        Write-Host ""
        Write-Host "[$Section]" -ForegroundColor Cyan

        foreach($Key in $script:Config[$Section].Keys)
        {
            Write-Host "$Key = $($script:Config[$Section][$Key])"
        }
    }

}

Export-ModuleMember `
-Function Initialize-SNPConfiguration,
          Get-SNPConfiguration,
          Get-SNPConfigValue,
          Show-SNPConfiguration