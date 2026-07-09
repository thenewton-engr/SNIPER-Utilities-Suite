#==============================================================================
# SNIPER Utilities Suite
# Backup Engine
# Version : 1.0.0-alpha3
# Author  : Eng. Hafeez Ur Rehman
#==============================================================================

Set-StrictMode -Version Latest

function Start-SNPBackup {

   

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
    # Initialize Core
    #----------------------------------------------------------------------

    Start-SNPCore
Write-SNPHeader "Backup Engine"
Write-SNPInfo ("Version : " + (Get-SNPVersion))
Write-SNPBlank


Write-SNPLog `
    -Message "Backup engine initialized." `
    -Level INFO `
    -Module Backup
Write-SNPInfo "Backup Engine Started"
    $App = Initialize-SNP

    #----------------------------------------------------------------------
    # Read Configuration
    #----------------------------------------------------------------------

    $Source      = $App.Config.Backup.Source
    $Destination = $App.Config.Backup.Destination
    $LogFolder   = $App.Config.Backup.LogFolder
    $LogFile     = $App.Config.Backup.LogFile
    $Options     = $App.Config.Backup.RoboCopyOptions

    #----------------------------------------------------------------------
    # Prepare Log Folder
    #----------------------------------------------------------------------

    $LogDirectory = Join-Path $ProjectRoot $LogFolder

    if (!(Test-Path $LogDirectory))
    {
        New-Item -ItemType Directory -Path $LogDirectory | Out-Null
    }

    $LogPath = Join-Path $LogDirectory $LogFile

    #----------------------------------------------------------------------
    # Display Configuration
    #----------------------------------------------------------------------

  Write-SNPInfo ("Source      : " + $Source)
Write-SNPInfo ("Destination : " + $Destination)
Write-SNPInfo ("Log File    : " + $LogPath)
Write-SNPBlank

    #----------------------------------------------------------------------
    # Validate Source
    #----------------------------------------------------------------------

    if (!(Test-Path $Source))
    {
        Write-SNPError "Source folder not found."

return $false
    }

    #----------------------------------------------------------------------
    # Validate Destination
    #----------------------------------------------------------------------

    if (!(Test-Path $Destination))
    {
       Write-SNPError "Destination is not reachable."

	return $false
    }

    Write-SNPSuccess "Configuration Verified"

Write-SNPBlank

    #----------------------------------------------------------------------
    # Preview Option
    #----------------------------------------------------------------------

    $Preview = Read-Host "Preview only (Dry Run)? (Y/N)"

    if ($Preview.ToUpper() -eq "Y")
    {
        $Options = "$Options /L"
    }

    #----------------------------------------------------------------------
    # Confirmation
    #----------------------------------------------------------------------

    $Confirm = Read-Host "Proceed with Backup? (Y/N)"

    if ($Confirm.ToUpper() -ne "Y")
    {
        Write-SNPWarning "Backup Cancelled"

Write-SNPLog `
    -Message "Backup cancelled by user." `
    -Level WARNING `
    -Module Backup

return $false
    }

    #----------------------------------------------------------------------
    # Execute Backup
    #----------------------------------------------------------------------

    Write-SNPInfo "Starting Robocopy..."

Write-SNPLog `
    -Message "Starting Robocopy Backup" `
    -Level INFO `
    -Module Backup

Write-SNPBlank

    $Arguments = @()

    $Arguments += $Source
    $Arguments += $Destination

    $Arguments += ($Options -split '\s+')

    $Arguments += "/TEE"
    $Arguments += "/LOG:$LogPath"

    & robocopy @Arguments

    $ExitCode = $LASTEXITCODE

   Write-SNPSeparator

if($ExitCode -le 7)
{
    Write-SNPSuccess "Backup Completed"

    Write-SNPLog `
        -Message ("Backup completed successfully. ExitCode=" + $ExitCode) `
        -Level SUCCESS `
        -Module Backup
}
else
{
    Write-SNPError ("Backup failed. ExitCode=" + $ExitCode)

    Write-SNPLog `
        -Message ("Backup failed. ExitCode=" + $ExitCode) `
        -Level ERROR `
        -Module Backup
}

Write-SNPInfo ("Robocopy Exit Code : " + $ExitCode)
Write-SNPInfo ("Log File           : " + $LogPath)

Write-SNPBlank
Write-SNPLog `
    -Message "Backup engine finished." `
    -Level INFO `
    -Module Backup

return ($ExitCode -le 7)

}

Export-ModuleMember -Function Start-SNPBackup