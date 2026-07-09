#==============================================================================
# SNIPER Utilities Suite
# Network Module
# Build 1002 Rev 1
# Author : Eng. Hafeez Ur Rehman
#==============================================================================

Set-StrictMode -Version Latest

function Initialize-SNPNetwork {

    Write-SNPInfo "Initializing Network Module"

    return $true

}
function Test-SNPComputer {

    param(
        [Parameter(Mandatory)]
        [string]$ComputerName
    )

    try {

    return (Test-Connection `
        -ComputerName $ComputerName `
        -Count 1 `
        -Quiet `
        -ErrorAction Stop)

}
catch {

    return $false

}
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

function Connect-SNPDrive {

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

    $Connected = Test-Path "$DriveLetter`:\"

if($Connected)
{
    Write-SNPSuccess "Mapped $DriveLetter`: to $Share"
}
else
{
    Write-SNPError "Unable to map $DriveLetter`: to $Share"
}

return $Connected
}

function Disconnect-SNPDrive {

    param(
        [Parameter(Mandatory)]
        [string]$DriveLetter
    )

    $DriveLetter = $DriveLetter.Replace(":","")

    cmd /c "net use $DriveLetter`: /delete /y" | Out-Null

    Start-Sleep 1

    $Disconnected = !(Test-Path "$DriveLetter`:\")

if($Disconnected)
{
    Write-SNPInfo "$DriveLetter`: disconnected"
}
else
{
    Write-SNPWarning "$DriveLetter`: still connected"
}

return $Disconnected
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
function Test-SNPInternet {

    try {

        return (Test-Connection `
            -ComputerName "8.8.8.8" `
            -Count 1 `
            -Quiet `
            -ErrorAction Stop)

    }
    catch {

        return $false

    }

}
Export-ModuleMember -Function `
Initialize-SNPNetwork,
Test-SNPComputer,
Test-SNPShare,
Connect-SNPDrive,
Disconnect-SNPDrive,
Get-SNPMappedDrives,
Get-SNPShareStatus,
Test-SNPInternet