Set-StrictMode -Version Latest

function Start-SNPBackup {

    Clear-Host

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "      SNIPER BACKUP ENGINE v1.0" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""

    $ProjectRoot = Split-Path (Split-Path $PSScriptRoot)

    # Load required modules
    Import-Module "$ProjectRoot\Modules\Core\Core.psm1" -Force | Out-Null
    Import-Module "$ProjectRoot\Modules\Configuration\Configuration.psm1" -Force | Out-Null

    Start-SNPCore

    Initialize-SNPConfiguration

    # Read configuration
    $Source      = Get-SNPConfigValue "Backup" "Source"
    $Destination = Get-SNPConfigValue "Backup" "Destination"
    $LogFolder   = Get-SNPConfigValue "Backup" "LogFolder"
    $LogFile     = Get-SNPConfigValue "Backup" "LogFile"
    $Options     = Get-SNPConfigValue "Backup" "RoboCopyOptions"

    # Create log folder if missing
    $LogPath = Join-Path $ProjectRoot $LogFolder

    if (!(Test-Path $LogPath)) {
        New-Item -ItemType Directory -Path $LogPath | Out-Null
    }

    $LogFilePath = Join-Path $LogPath $LogFile

    Write-Host ""
    Write-Host "Source      : $Source"
    Write-Host "Destination : $Destination"
    Write-Host "Log File    : $LogFilePath"
    Write-Host ""

    if (!(Test-Path $Source)) {
        Write-Host "ERROR: Source folder not found." -ForegroundColor Red
        return
    }

    if (!(Test-Path $Destination)) {
        Write-Host "ERROR: Destination is not reachable." -ForegroundColor Red
        return
    }

    Write-Host "Configuration verified." -ForegroundColor Green
    Write-Host ""

    $answer = Read-Host "Preview only? (Y/N)"

    if ($answer -eq "Y") {
        $Options = "$Options /L"
    }

    Write-Host ""
    Write-Host "Executing Robocopy..." -ForegroundColor Cyan
    Write-Host ""

    $Arguments = @(
        $Source
        $Destination
    ) + ($Options -split '\s+') + @(
        "/TEE"
        "/LOG:$LogFilePath"
    )

    & robocopy @Arguments

    Write-Host ""
    Write-Host "Operation Finished." -ForegroundColor Green
    Write-Host "Log : $LogFilePath"
}

Export-ModuleMember -Function Start-SNPBackup