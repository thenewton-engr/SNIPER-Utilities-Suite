#==============================================================================
# SNIPER Utilities Suite
# Logging Module
# Version : 1.0.0-alpha4
# Author  : Eng. Hafeez Ur Rehman
#==============================================================================

Set-StrictMode -Version Latest

#------------------------------------------------------------------------------
# Module Variables
#------------------------------------------------------------------------------

$script:LogDirectory = $null
$script:LogFile      = $null

#------------------------------------------------------------------------------
# Initialize Logging
#------------------------------------------------------------------------------

function Initialize-SNPLogging {

    $ProjectRoot = Split-Path (Split-Path $PSScriptRoot)

    $script:LogDirectory = Join-Path $ProjectRoot "Logs"

    if (!(Test-Path $script:LogDirectory))
    {
        New-Item -ItemType Directory -Path $script:LogDirectory -Force | Out-Null
    }

    $script:LogFile = Join-Path $script:LogDirectory "SNIPER.log"

    if (!(Test-Path $script:LogFile))
    {
        New-Item -ItemType File -Path $script:LogFile -Force | Out-Null
    }

}

#------------------------------------------------------------------------------
# Write Log Entry
#------------------------------------------------------------------------------

function Write-SNPLog {

    param(

        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet("INFO","SUCCESS","WARNING","ERROR","DEBUG")]
        [string]$Level = "INFO",

        [string]$Module = "General"

    )

    if ([string]::IsNullOrWhiteSpace($script:LogFile))
    {
        Initialize-SNPLogging
    }

    $Line = "{0} [{1}] [{2}] [{3}] {4}" -f `
        (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), `
        $Level, `
        $env:COMPUTERNAME, `
        $Module, `
        $Message

    Add-Content -Path $script:LogFile -Value $Line

}

#------------------------------------------------------------------------------
# Get Current Log File
#------------------------------------------------------------------------------

function Get-SNPLogFile {

    if ([string]::IsNullOrWhiteSpace($script:LogFile))
    {
        Initialize-SNPLogging
    }

    return $script:LogFile

}

#------------------------------------------------------------------------------
# Clear Log File
#------------------------------------------------------------------------------

function Clear-SNPLog {

    if ([string]::IsNullOrWhiteSpace($script:LogFile))
    {
        Initialize-SNPLogging
    }

    Clear-Content -Path $script:LogFile

}

#------------------------------------------------------------------------------
# Export Functions
#------------------------------------------------------------------------------

Export-ModuleMember -Function `
    Initialize-SNPLogging, `
    Write-SNPLog, `
    Get-SNPLogFile, `
    Clear-SNPLog