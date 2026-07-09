#==============================================================================
# SNIPER Utilities Suite
# Core Module
# Build 1003 Rev 1
# Author : Eng. Hafeez Ur Rehman
#==============================================================================

Set-StrictMode -Version Latest

function Get-SNPProjectRoot {

    Split-Path (Split-Path $PSScriptRoot)

}

function Get-SNPVersion {

    $VersionFile = Join-Path (Get-SNPProjectRoot) "Metadata\Version.json"

    if (!(Test-Path $VersionFile))
    {
        throw "Version file not found:`n$VersionFile"
    }

    return (
        Get-Content $VersionFile -Raw |
        ConvertFrom-Json
    ).Version

}

function Import-SNPFramework {

    $Root = Get-SNPProjectRoot

    $Modules = @(

    "$Root\Modules\Configuration\Configuration.psd1",

    "$Root\Modules\Logging\Logging.psd1",

    "$Root\Modules\Console\Console.psd1",

    "$Root\Modules\Core\Application.psd1",

    "$Root\Modules\Network\Network.psd1",

    "$Root\Modules\Backup\Backup.psd1"

)

    foreach($Module in $Modules)
    {
        if(Test-Path $Module)
        {
            Import-Module $Module -Force -ErrorAction Stop
        }
    }

}

function Start-SNPCore {

    Clear-Host

    Import-SNPFramework

    if(!(Get-Command Initialize-SNP -ErrorAction SilentlyContinue))
    {
        throw "Application module failed to load."
    }

    $App = Initialize-SNP

    Write-SNPHeader $App.SuiteName

    Write-SNPInfo ("Version    : " + $App.Version)
    Write-SNPInfo ("Computer   : " + $App.Computer)
    Write-SNPInfo ("User       : " + $App.User)
    Write-SNPInfo ("Started    : " + $App.Started)

    Write-SNPBlank

    Write-SNPSuccess "Framework Loaded"

    return $App

}

Export-ModuleMember -Function `
    Start-SNPCore, `
    Get-SNPVersion, `
    Get-SNPProjectRoot, `
    Import-SNPFramework