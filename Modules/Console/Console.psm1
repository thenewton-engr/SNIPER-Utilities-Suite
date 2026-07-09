#==============================================================================
# SNIPER Utilities Suite
# Console Module
# Version : 1.0.0
#==============================================================================

Set-StrictMode -Version Latest

function Write-SNPMessage {

    param(

        [Parameter(Mandatory)]
        [string]$Message,

        [ValidateSet("INFO","SUCCESS","WARNING","ERROR")]
        [string]$Level="INFO"

    )

    $Time = Get-Date -Format "HH:mm:ss"

    switch($Level)
    {
        "INFO"    { $Color="White"  }
        "SUCCESS" { $Color="Green"  }
        "WARNING" { $Color="Yellow" }
        "ERROR"   { $Color="Red"    }
    }

    Write-Host "[$Time] [$Level] $Message" -ForegroundColor $Color

    #
    # Logging is optional.
    # Console NEVER imports Logging.
    #

    if(Get-Command Write-SNPLog -ErrorAction SilentlyContinue)
    {
        Write-SNPLog `
            -Message $Message `
            -Level $Level `
            -Module "Console"
    }

}

function Write-SNPHeader {

    param([string]$Title)

    Write-Host ""
    Write-Host ("="*60) -ForegroundColor DarkCyan
    Write-Host ("  "+$Title) -ForegroundColor Cyan
    Write-Host ("="*60) -ForegroundColor DarkCyan
    Write-Host ""

}

function Write-SNPSeparator {

    Write-Host ("-"*60) -ForegroundColor DarkGray

}

function Write-SNPBlank {

    Write-Host ""

}

function Write-SNPInfo {

    param([string]$Message)

    Write-SNPMessage $Message INFO

}

function Write-SNPSuccess {

    param([string]$Message)

    Write-SNPMessage $Message SUCCESS

}

function Write-SNPWarning {

    param([string]$Message)

    Write-SNPMessage $Message WARNING

}

function Write-SNPError {

    param([string]$Message)

    Write-SNPMessage $Message ERROR

}

Export-ModuleMember -Function `
Write-SNPHeader,`
Write-SNPSeparator,`
Write-SNPBlank,`
Write-SNPInfo,`
Write-SNPSuccess,`
Write-SNPWarning,`
Write-SNPError