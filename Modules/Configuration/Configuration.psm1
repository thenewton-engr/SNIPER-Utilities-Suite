Set-StrictMode -Version Latest

$Script:Config = @{}

function Initialize-SNPConfiguration {

    $ConfigFile = Join-Path $PSScriptRoot "Config.ini"

    if (!(Test-Path $ConfigFile)) {
        throw "Configuration file not found: $ConfigFile"
    }

    $section = ""

    Get-Content $ConfigFile | ForEach-Object {

        $line = $_.Trim()

        if ($line -eq "") { return }

        if ($line.StartsWith(";")) { return }

        if ($line.StartsWith("[")) {

            $section = $line.Trim("[","]")

            if (!$Script:Config.ContainsKey($section)) {
                $Script:Config[$section] = @{}
            }

            return
        }

        if ($line -match "=") {

            $parts = $line.Split("=",2)

            $key   = $parts[0].Trim()
            $value = $parts[1].Trim()

            $Script:Config[$section][$key] = $value

        }

    }

}

function Get-SNPConfigValue {

    param(
        [string]$Section,
        [string]$Key
    )

    return $Script:Config[$Section][$Key]

}

function Show-SNPConfiguration {

    foreach($section in $Script:Config.Keys){

        Write-Host ""
        Write-Host "[$section]" -ForegroundColor Cyan

        foreach($key in $Script:Config[$section].Keys){

            Write-Host "$key = $($Script:Config[$section][$key])"

        }

    }

}

Export-ModuleMember `
-Function Initialize-SNPConfiguration,
          Get-SNPConfigValue,
          Show-SNPConfiguration