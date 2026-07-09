#==============================================================================
# SNIPER Utilities Suite
# Restore Engine
# Build 1004
# Author : Eng. Hafeez Ur Rehman
#==============================================================================

Set-StrictMode -Version Latest

function Start-SNPRestore {

    #----------------------------------------------------------------------
    # Project Root
    #----------------------------------------------------------------------

    $ProjectRoot = Split-Path (Split-Path $PSScriptRoot)

    #----------------------------------------------------------------------
    # Load Core Modules
    #----------------------------------------------------------------------

    Import-Module "$ProjectRoot\Modules\Core\Core.psd1" -Force | Out-Null
    Import-Module "$ProjectRoot\Modules\Core\Application.psd1" -Force | Out-Null
    Import-Module "$ProjectRoot\Modules\Logging\Logging.psd1" -Force | Out-Null
    Import-Module "$ProjectRoot\Modules\Console\Console.psd1" -Force | Out-Null
    Import-Module "$ProjectRoot\Modules\Network\Network.psd1" -Force | Out-Null

    #----------------------------------------------------------------------
    # Initialize Framework
    #----------------------------------------------------------------------

    Start-SNPCore

    Write-SNPBlank

    Write-SNPSeparator
    Write-SNPHeader "Restore Engine"

    Write-SNPInfo ("Version : " + (Get-SNPVersion))
    Write-SNPBlank

    Write-SNPLog `
        -Message "Restore engine initialized." `
        -Level INFO `
        -Module Restore

    Write-SNPInfo "Restore Engine Started"

    $App = Initialize-SNP

    #----------------------------------------------------------------------
    # Read Configuration
    #----------------------------------------------------------------------

    $BackupSource      = $App.Config.Backup.Destination
    $RestoreTarget     = $App.Config.Backup.Source

    $LogFolder         = $App.Config.Backup.LogFolder
    $LogFile = "SNPRestore.log"

    $Options           = $App.Config.Backup.RoboCopyOptions

    #----------------------------------------------------------------------
    # Prepare Log Folder
    #----------------------------------------------------------------------

    $LogDirectory = Join-Path $ProjectRoot $LogFolder

    if (!(Test-Path $LogDirectory))
    {
        New-Item `
            -ItemType Directory `
            -Path $LogDirectory `
            -Force | Out-Null
    }

    $LogPath = Join-Path $LogDirectory $LogFile

    #----------------------------------------------------------------------
    # Display Configuration
    #----------------------------------------------------------------------

    Write-SNPInfo ("Backup Source : " + $BackupSource)
    Write-SNPInfo ("Restore To    : " + $RestoreTarget)
    Write-SNPInfo ("Log File      : " + $LogPath)

    Write-SNPBlank

    #----------------------------------------------------------------------
    # Validate Backup Source
    #----------------------------------------------------------------------

    if (!(Test-SNPShare $BackupSource))
    {
        Write-SNPError "Backup source is not reachable."

        Write-SNPLog `
            -Message "Backup source unavailable." `
            -Level ERROR `
            -Module Restore

        return $false
    }

    #----------------------------------------------------------------------
    # Validate Restore Target
    #----------------------------------------------------------------------

    if (!(Test-Path $RestoreTarget))
{
    Write-SNPWarning "Restore target does not exist."

    Write-SNPInfo "Creating restore target..."

    New-Item `
        -ItemType Directory `
        -Path $RestoreTarget `
        -Force | Out-Null

    Write-SNPSuccess "Restore target created."

    Write-SNPLog `
        -Message "Restore target created." `
        -Level INFO `
        -Module Restore
}

    Write-SNPSuccess "Configuration Verified"

    Write-SNPBlank
        #----------------------------------------------------------------------
    # Preview Option
    #----------------------------------------------------------------------

    $Preview = Read-Host "Preview only (Dry Run)? (Y/N)"

    if($Preview.ToUpper() -eq "Y")
    {
        $Options = "$Options /L"

        Write-SNPWarning "Running in Preview Mode (No files will be restored)."

        Write-SNPLog `
            -Message "Restore preview mode enabled." `
            -Level INFO `
            -Module Restore
    }

    #----------------------------------------------------------------------
    # Confirmation
    #----------------------------------------------------------------------

    $Confirm = Read-Host "Proceed with Restore? (Y/N)"

    if($Confirm.ToUpper() -ne "Y")
    {
        Write-SNPWarning "Restore Cancelled"

        Write-SNPLog `
            -Message "Restore cancelled by user." `
            -Level WARNING `
            -Module Restore

        return $false
    }

    #----------------------------------------------------------------------
    # Execute Restore
    #----------------------------------------------------------------------

    Write-SNPInfo "Starting Restore..."

    Write-SNPLog `
        -Message "Starting restore operation." `
        -Level INFO `
        -Module Restore

    Write-SNPBlank

    $Arguments = @()

    $Arguments += $BackupSource
    $Arguments += $RestoreTarget

    $Arguments += ($Options -split '\s+')

    $Arguments += "/TEE"
    $Arguments += "/LOG:$LogPath"

    & robocopy @Arguments

    $ExitCode = $LASTEXITCODE

    Write-SNPSeparator

    if($ExitCode -le 7)
    {
        Write-SNPSuccess "Restore Completed"

        Write-SNPLog `
            -Message ("Restore completed successfully. ExitCode=" + $ExitCode) `
            -Level SUCCESS `
            -Module Restore
    }
    else
    {
        Write-SNPError ("Restore failed. ExitCode=" + $ExitCode)

        Write-SNPLog `
            -Message ("Restore failed. ExitCode=" + $ExitCode) `
            -Level ERROR `
            -Module Restore
    }

    Write-SNPInfo ("Robocopy Exit Code : " + $ExitCode)
    Write-SNPInfo ("Log File           : " + $LogPath)

    Write-SNPBlank

    Write-SNPLog `
        -Message "Restore engine finished." `
        -Level INFO `
        -Module Restore

    return ($ExitCode -le 7)

}

Export-ModuleMember -Function Start-SNPRestore