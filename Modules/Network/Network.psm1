#==============================================================================
# SNIPER Utilities Suite
# Network Module
# Build 1002 Rev 1
# Author : Eng. Hafeez Ur Rehman
#==============================================================================

Set-StrictMode -Version Latest

function Initialize-SNPNetwork {
    Write-Host "SNIPER Network Module Initialized." -ForegroundColor Green
}

function Test-SNPComputer {

    param(
        [Parameter(Mandatory)]
        [string]$ComputerName
    )

    return Test-Connection -ComputerName $ComputerName -Count 1 -Quiet
}

function Test-SNPShare {

    param(
        [Parameter(Mandatory)]
        [string]$Share
    )

    try {

        $null = cmd /c "dir `"$Share`"" 2>$null

        if ($LASTEXITCODE -eq 0) {
            return $true
        }

        return $false

    }
    catch {
        return $false
    }

}

function Map-SNPDrive {

    param(

        [Parameter(Mandatory)]
        [string]$DriveLetter,

        [Parameter(Mandatory)]
        [string]$Share,

        [string]$Username,

        [string]$Password

    )

    $DriveLetter = $DriveLetter.Replace(":","")

    cmd /c "net use $DriveLetter`: /delete /y" | Out-Null

    if([string]::IsNullOrWhiteSpace($Username))
    {
        cmd /c "net use $DriveLetter`: `"$Share`" /persistent:yes"
    }
    else
    {
        cmd /c "net use $DriveLetter`: `"$Share`" `"$Password`" /user:`"$Username`" /persistent:yes"
    }

    Start-Sleep 1

    return (Test-Path "$DriveLetter`:\")
}

function Unmap-SNPDrive {

    param(
        [Parameter(Mandatory)]
        [string]$DriveLetter
    )

    $DriveLetter = $DriveLetter.Replace(":","")

    cmd /c "net use $DriveLetter`: /delete /y" | Out-Null

    Start-Sleep 1

    return !(Test-Path "$DriveLetter`:\")
}

function Get-SNPMappedDrives {

    Get-CimInstance Win32_LogicalDisk |
        Where-Object {$_.DriveType -eq 4} |
        Select-Object DeviceID,
                      ProviderName,
                      VolumeName

}

function Get-SNPShareStatus {

    param(
        [Parameter(Mandatory)]
        [string]$Share
    )

    [PSCustomObject]@{

        Share      = $Share
        Reachable  = Test-SNPShare $Share
        Time       = Get-Date
        Computer   = $env:COMPUTERNAME

    }

}

Export-ModuleMember -Function `
Initialize-SNPNetwork,
Test-SNPComputer,
Test-SNPShare,
Map-SNPDrive,
Unmap-SNPDrive,
Get-SNPMappedDrives,
Get-SNPShareStatus