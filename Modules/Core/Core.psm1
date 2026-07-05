Set-StrictMode -Version Latest

$Script:SuiteName = "SNIPER Utilities Suite"
$Script:Version   = "1.0.0-alpha1"

function Get-SNPVersion {
    return $Script:Version
}

function Start-SNPCore {

    Clear-Host

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "      SNIPER Utilities Suite" -ForegroundColor Green
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host ""

    Write-Host ("Version : " + $Script:Version)
    Write-Host ("Computer: " + $env:COMPUTERNAME)
    Write-Host ("User    : " + $env:USERNAME)
    Write-Host ("Date    : " + (Get-Date))
    Write-Host ""

    $ProjectRoot = Split-Path (Split-Path $PSScriptRoot)

    $Modules = @(
        @{
            Name="Configuration"
            Path="$ProjectRoot\Modules\Configuration\Configuration.psm1"
        },
        @{
            Name="Logging"
            Path="$ProjectRoot\Modules\Logging\Logging.psm1"
        },
        @{
            Name="Network"
            Path="$ProjectRoot\Modules\Network\Network.psm1"
        }
    )

    foreach($Module in $Modules)
    {
        Write-Host ("Loading " + $Module.Name + "...") -NoNewline

        if(Test-Path $Module.Path)
        {
            Import-Module $Module.Path -Force
            Write-Host " OK" -ForegroundColor Green
        }
        else
        {
            Write-Host " FAILED" -ForegroundColor Red
        }
    }

    Write-Host ""
    Write-Host "Core Engine Ready." -ForegroundColor Green
}

Export-ModuleMember `
-Function Start-SNPCore,
          Get-SNPVersion