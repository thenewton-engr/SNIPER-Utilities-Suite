#==============================================================================
# SNIPER Utilities Suite
# Module : Logging
# Version: 2.0 Build 1000
# Author : Eng. Hafeez Ur Rehman
#==============================================================================

Set-StrictMode -Version Latest

$script:LogFile = $null

function Initialize-SNPLogging {

    param(
        [string]$LogFolder = (Join-Path $PSScriptRoot "..\..\Logs")
    )

    # Create Logs folder if missing
    if (!(Test-Path -Path $LogFolder)) {
        New-Item -ItemType Directory -Path $LogFolder -Force | Out-Null
    }

    # Daily log file
    $script:LogFile = Join-Path $LogFolder ("SNIPER_{0}.log" -f (Get-Date -Format "yyyyMMdd"))

    if (!(Test-Path -Path $script:LogFile)) {
        New-Item -ItemType File -Path $script:LogFile -Force | Out-Null
    }

    $line = "{0} [INFO] [{1}] [Logging] Logging initialized." -f `
            (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), `
            $env:COMPUTERNAME

    Add-Content -Path $script:LogFile -Value $line
}

function Write-SNPLog {

    param(
        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet("INFO","SUCCESS","WARNING","ERROR","DEBUG")]
        [string]$Level="INFO",

        [string]$Module="General"
    )

    if ([string]::IsNullOrWhiteSpace($script:LogFile)) {
        Initialize-SNPLogging
    }

    $line = "{0} [{1}] [{2}] [{3}] {4}" -f `
            (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), `
            $Level, `
            $env:COMPUTERNAME, `
            $Module, `
            $Message

    Add-Content -Path $script:LogFile -Value $line

    switch ($Level) {
        "INFO"    { Write-Host $line -ForegroundColor White }
        "SUCCESS" { Write-Host $line -ForegroundColor Green }
        "WARNING" { Write-Host $line -ForegroundColor Yellow }
        "ERROR"   { Write-Host $line -ForegroundColor Red }
        "DEBUG"   { Write-Host $line -ForegroundColor Cyan }
    }
}

function Get-SNPLogFile {

    return $script:LogFile

}

Export-ModuleMember `
    -Function Initialize-SNPLogging, `
              Write-SNPLog, `
              Get-SNPLogFile