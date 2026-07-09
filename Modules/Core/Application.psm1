#==============================================================================
# SNIPER Utilities Suite
# Application Module
# Build 1003
#==============================================================================

Set-StrictMode -Version Latest

function Get-SNPProjectRoot {

    $Root = Resolve-Path (Join-Path $PSScriptRoot "..\..")

    return $Root.Path

}

function Get-SNPVersionObject {

    $VersionFile = Join-Path (Get-SNPProjectRoot) "Metadata\Version.json"

    if (!(Test-Path $VersionFile)) {
        throw "Version file not found: $VersionFile"
    }

    Get-Content $VersionFile -Raw | ConvertFrom-Json

}

function Initialize-SNP {

    if (!(Get-Command Get-SNPConfiguration -ErrorAction SilentlyContinue)) {

        Import-Module (Join-Path (Get-SNPProjectRoot) "Modules\Configuration\Configuration.psd1") -Force -ErrorAction Stop

    }

    $Version = Get-SNPVersionObject

    $Config = Get-SNPConfiguration
if ($null -eq $Config)
{
    throw "Configuration failed to load."
}
    [PSCustomObject]@{

    SuiteName   = $Version.Product

    Version     = $Version.Version

    Major       = $Version.Major

    Minor       = $Version.Minor

    Patch       = $Version.Patch

    Build       = $Version.Build

    Stage       = $Version.Stage

    Author      = $Version.Author

    Company     = $Version.Company

    Website     = $Version.Website

    Computer    = $env:COMPUTERNAME

    User        = $env:USERNAME

    Started     = Get-Date

    ProjectRoot = Get-SNPProjectRoot

    Config      = $Config

}

}

Export-ModuleMember `
-Function Initialize-SNP,
          Get-SNPVersionObject,
          Get-SNPProjectRoot